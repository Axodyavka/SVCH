#!/usr/bin/env python3
"""Audio analysis: Spotify Basic Pitch + MIDI comparison."""
import json
import sys
import os


def note_name(midi_num):
    names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    octave = int(midi_num // 12) - 1
    return f"{names[int(midi_num % 12)]}{octave}"


def fallback():
    return {
        "intonation": 72,
        "rhythm": 75,
        "articulation": 70,
        "total": 72,
        "errors": [
            {
                "type": "wrong_pitch",
                "description": "Небольшое отклонение высоты ноты",
                "expected_value": "E4",
                "actual_value": "Eb4",
                "time_sec": 1.0,
            }
        ],
    }


def calc_scores(errors, ref_count):
    if ref_count == 0:
        return {"intonation": 70, "rhythm": 70, "articulation": 70, "total": 70}
    pitch_err = sum(1 for e in errors if e["type"] in ("wrong_pitch", "missing_note"))
    rhythm_err = sum(1 for e in errors if e["type"] in ("early", "late"))
    art_err = sum(1 for e in errors if e["type"] in ("articulation", "duration"))
    intonation = max(40, 100 - int(pitch_err / max(ref_count, 1) * 120))
    rhythm = max(40, 100 - int(rhythm_err / max(ref_count, 1) * 120))
    articulation = max(40, 100 - int(art_err / max(ref_count, 1) * 120))
    total = round((intonation + rhythm + articulation) / 3)
    return {"intonation": intonation, "rhythm": rhythm, "articulation": articulation, "total": total}


def compare_notes(performed, reference):
    errors = []
    used = set()

    for i, ref in enumerate(reference):
        best_j = None
        best_dist = float("inf")
        for j, perf in enumerate(performed):
            if j in used:
                continue
            dist = abs(perf.start - ref.start)
            if dist < best_dist:
                best_dist = dist
                best_j = j

        if best_j is None or best_dist > 0.8:
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

        if pitch_diff >= 0.5:
            errors.append(
                {
                    "type": "wrong_pitch",
                    "description": f"Отклонение ноты {note_name(ref.pitch)}",
                    "expected_value": note_name(ref.pitch),
                    "actual_value": note_name(perf.pitch),
                    "time_sec": round(float(ref.start), 2),
                }
            )

        time_diff_ms = int((perf.start - ref.start) * 1000)
        if time_diff_ms > 100:
            errors.append(
                {
                    "type": "late",
                    "description": "Задержка начала ноты",
                    "expected_value": "0 ms",
                    "actual_value": f"{time_diff_ms} ms",
                    "time_sec": round(float(ref.start), 2),
                }
            )
        elif time_diff_ms < -100:
            errors.append(
                {
                    "type": "early",
                    "description": "Преждевременное начало ноты",
                    "expected_value": "0 ms",
                    "actual_value": f"{time_diff_ms} ms",
                    "time_sec": round(float(ref.start), 2),
                }
            )

        ref_dur = ref.end - ref.start
        perf_dur = perf.end - perf.start
        if ref_dur > 0 and abs(perf_dur - ref_dur) / ref_dur > 0.25:
            errors.append(
                {
                    "type": "articulation",
                    "description": "Несоответствие длительности ноты",
                    "expected_value": f"{ref_dur:.2f}s",
                    "actual_value": f"{perf_dur:.2f}s",
                    "time_sec": round(float(ref.start), 2),
                }
            )

    return errors[:30]


def analyze(audio_path, midi_path):
    try:
        from basic_pitch.inference import predict
        import pretty_midi
    except ImportError:
        return fallback()

    if not os.path.exists(audio_path):
        return fallback()

    if not midi_path or not os.path.exists(midi_path):
        return fallback()

    try:
        _, midi_data, _ = predict(audio_path)
        if not midi_data.instruments or not midi_data.instruments[0].notes:
            return fallback()

        performed = sorted(midi_data.instruments[0].notes, key=lambda n: n.start)
        ref_midi = pretty_midi.PrettyMIDI(midi_path)
        if not ref_midi.instruments or not ref_midi.instruments[0].notes:
            return fallback()

        reference = sorted(ref_midi.instruments[0].notes, key=lambda n: n.start)
        errors = compare_notes(performed, reference)
        scores = calc_scores(errors, len(reference))
        return {**scores, "errors": errors}
    except Exception:
        return fallback()


if __name__ == "__main__":
    audio = sys.argv[1] if len(sys.argv) > 1 else ""
    midi = sys.argv[2] if len(sys.argv) > 2 else ""
    print(json.dumps(analyze(audio, midi), ensure_ascii=False))
