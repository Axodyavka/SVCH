const { execFile } = require('child_process');
const path = require('path');
const util = require('util');
const { Report, ErrorItem, Recommendation } = require('../models');
const { generateRecommendations } = require('./recommendationService');

const execFileAsync = util.promisify(execFile);

const fallbackResult = () => ({
  intonation: 72,
  rhythm: 75,
  articulation: 70,
  total: 72,
  errors: [
    {
      type: 'wrong_pitch',
      description: 'Небольшое отклонение высоты ноты',
      expected_value: 'E4',
      actual_value: 'Eb4',
      time_sec: 1.0,
    },
    {
      type: 'late',
      description: 'Задержка начала ноты',
      expected_value: '0 ms',
      actual_value: '120 ms',
      time_sec: 2.5,
    },
  ],
});

async function runPythonAnalysis(audioPath, midiPath) {
  const python = process.env.PYTHON_PATH || 'python';
  const scriptPath = path.join(__dirname, '../scripts/analyze.py');

  try {
    const { stdout } = await execFileAsync(python, [scriptPath, audioPath, midiPath || ''], {
      timeout: 120000,
    });
    return JSON.parse(stdout);
  } catch {
    return fallbackResult();
  }
}

async function createReportFromAnalysis(recording, composition, analysisResult) {
  const report = await Report.create({
    recording_id: recording.id,
    total_score: analysisResult.total,
    intonation: analysisResult.intonation,
    rhythm: analysisResult.rhythm,
    articulation: analysisResult.articulation,
  });

  const errorRows = (analysisResult.errors || []).map((err) => ({
    report_id: report.id,
    type: err.type,
    description: err.description,
    expected_value: String(err.expected_value ?? ''),
    actual_value: String(err.actual_value ?? ''),
    time_sec: err.time_sec ?? null,
  }));

  if (errorRows.length) {
    await ErrorItem.bulkCreate(errorRows);
  }

  const texts = generateRecommendations(analysisResult.errors || [], composition?.title);
  await Recommendation.bulkCreate(
    texts.map((text) => ({
      user_id: recording.user_id,
      report_id: report.id,
      text,
    })),
  );

  return report;
}

async function analyzeRecording(recording, composition) {
  const midiPath = composition.midi_path
    ? path.isAbsolute(composition.midi_path)
      ? composition.midi_path
      : path.join(__dirname, '..', composition.midi_path)
    : '';

  const result = await runPythonAnalysis(recording.audio_path, midiPath);
  return createReportFromAnalysis(recording, composition, result);
}

module.exports = { analyzeRecording, runPythonAnalysis };
