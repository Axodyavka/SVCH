#!/usr/bin/env python3
"""Audio analysis: Spotify Basic Pitch + MIDI comparison."""
import json
import sys
import os
from contextlib import redirect_stdout


def note_name(midi_num):
    names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    octave = int(midi_num // 12) - 1
    return f"{names[int(midi_num % 12)]}{octave}"


MATCH_WINDOW_SECONDS = 1.5
TIMING_TOLERANCE_MS = 500
DURATION_TOLERANCE_RATIO = 1.0
PITCH_ERROR_THRESHOLD = 2.5
MISSING_NOTE_SCORE_WEIGHT = 0.25
SCORE_PENALTY_FACTOR = 120


def fallback(reason="Автоматический анализ недоступен"):
    return {
        "intonation": 0,
        "rhythm": 0,
        "articulation": 0,
        "total": 0,
        "errors": [
            {
                "type": "analysis_unavailable",
                "description": reason,
                "expected_value": "",
                "actual_value": "",
                "time_sec": None,
            }
        ],
    }


def calc_scores(errors, ref_count):
    if ref_count == 0:
        return {"intonation": 70, "rhythm": 70, "articulation": 70, "total": 70}
    wrong_pitch_err = sum(1 for e in errors if e["type"] == "wrong_pitch")
    missing_err = sum(1 for e in errors if e["type"] == "missing_note")
    pitch_err = wrong_pitch_err + missing_err * MISSING_NOTE_SCORE_WEIGHT
    rhythm_err = sum(1 for e in errors if e["type"] in ("early", "late"))
    art_err = sum(1 for e in errors if e["type"] in ("articulation", "duration"))

    intonation = max(0, 100 - round(pitch_err / max(ref_count, 1) * SCORE_PENALTY_FACTOR))
    rhythm = max(0, 100 - round(rhythm_err / max(ref_count, 1) * SCORE_PENALTY_FACTOR))
    articulation = max(0, 100 - round(art_err / max(ref_count, 1) * SCORE_PENALTY_FACTOR))
    total = round((intonation + rhythm + articulation) / 3)
    return {"intonation": intonation, "rhythm": rhythm, "articulation": articulation, "total": total}


def compare_notes(performed, reference):
    errors = []
    used = set()
    ref_start = reference[0].start if reference else 0
    perf_start = performed[0].start if performed else 0
    ref_span = max(reference[-1].end - ref_start, 0.001) if reference else 1
    perf_span = max(performed[-1].end - perf_start, 0.001) if performed else 1
    tempo_scale = min(2.0, max(0.5, perf_span / ref_span))

    for i, ref in enumerate(reference):
        expected_start = perf_start + (ref.start - ref_start) * tempo_scale
        best_j = None
        best_score = float("inf")
        best_dist = float("inf")
        for j, perf in enumerate(performed):
            if j in used:
                continue
            time_diff = perf.start - expected_start
            dist = abs(time_diff)
            if dist > MATCH_WINDOW_SECONDS:
                continue

            pitch_diff = abs(perf.pitch - ref.pitch)
            score = dist + min(pitch_diff, 12) * 0.08
            if score < best_score:
                best_score = score
                best_dist = dist
                best_j = j

        if best_j is None or best_dist > MATCH_WINDOW_SECONDS:
            errors.append(
                {
                    "type": "missing_note",
                    "description": f"Пропущена нота {note_name(ref.pitch)}",
                    "expected_value": note_name(ref.pitch),
                    "actual_value": "—",
                    "time_sec": round(float(ref.start), 2),
                }
            )
            continue

        used.add(best_j)
        perf = performed[best_j]
        pitch_diff = abs(perf.pitch - ref.pitch)

        if pitch_diff >= PITCH_ERROR_THRESHOLD:
            errors.append(
                {
                    "type": "wrong_pitch",
                    "description": f"Отклонение ноты {note_name(ref.pitch)}",
                    "expected_value": note_name(ref.pitch),
                    "actual_value": note_name(perf.pitch),
                    "time_sec": round(float(ref.start), 2),
                }
            )

        time_diff_ms = int((perf.start - expected_start) * 1000)
        if time_diff_ms > TIMING_TOLERANCE_MS:
            errors.append(
                {
                    "type": "late",
                    "description": "Задержка начала ноты",
                    "expected_value": f"±{TIMING_TOLERANCE_MS} ms",
                    "actual_value": f"{time_diff_ms} ms",
                    "time_sec": round(float(ref.start), 2),
                }
            )
        elif time_diff_ms < -TIMING_TOLERANCE_MS:
            errors.append(
                {
                    "type": "early",
                    "description": "Преждевременное начало ноты",
                    "expected_value": f"±{TIMING_TOLERANCE_MS} ms",
                    "actual_value": f"{time_diff_ms} ms",
                    "time_sec": round(float(ref.start), 2),
                }
            )

        ref_dur = (ref.end - ref.start) * tempo_scale
        perf_dur = perf.end - perf.start
        if ref_dur > 0 and abs(perf_dur - ref_dur) / ref_dur > DURATION_TOLERANCE_RATIO:
            errors.append(
                {
                    "type": "articulation",
                    "description": "Несоответствие длительности ноты",
                    "expected_value": f"{ref_dur:.2f}s",
                    "actual_value": f"{perf_dur:.2f}s",
                    "time_sec": round(float(ref.start), 2),
                }
            )

    return errors


def analyze(audio_path, midi_path):
    try:
        from basic_pitch.inference import predict
        import pretty_midi
    except ImportError as exc:
        print(f"Analysis import error: {exc}", file=sys.stderr)
        return fallback("Не удалось загрузить библиотеки анализа Basic Pitch или pretty_midi.")

    if not os.path.exists(audio_path):
        return fallback("Загруженный аудиофайл не найден на сервере.")

    if not midi_path or not os.path.exists(midi_path):
        return fallback("MIDI-эталон не найден на сервере.")

    try:
        with redirect_stdout(sys.stderr):
            _, midi_data, _ = predict(audio_path)
        if not midi_data.instruments or not midi_data.instruments[0].notes:
            return fallback(
                "В загруженном аудио не удалось распознать ноты. Проверьте, что файл содержит "
                "достаточно громкую запись инструмента и не повреждён."
            )

        performed = sorted(midi_data.instruments[0].notes, key=lambda n: n.start)
        ref_midi = pretty_midi.PrettyMIDI(midi_path)
        if not ref_midi.instruments or not ref_midi.instruments[0].notes:
            return fallback("В MIDI-эталоне не найдено нот для сравнения.")

        reference = sorted(ref_midi.instruments[0].notes, key=lambda n: n.start)
        errors = compare_notes(performed, reference)
        scores = calc_scores(errors, len(reference))
        return {**scores, "errors": errors}
    except Exception as exc:
        print(f"Analysis runtime error: {exc}", file=sys.stderr)
        return fallback("Во время автоматического анализа произошла ошибка. Попробуйте другой аудиофайл.")


if __name__ == "__main__":
    audio = sys.argv[1] if len(sys.argv) > 1 else ""
    midi = sys.argv[2] if len(sys.argv) > 2 else ""
    print(json.dumps(analyze(audio, midi), ensure_ascii=True))
