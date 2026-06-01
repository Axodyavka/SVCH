const { execFile } = require('child_process');
const path = require('path');
const util = require('util');
const { Report, ErrorItem, Recommendation } = require('../models');
const { generateRecommendations } = require('./recommendationService');

const execFileAsync = util.promisify(execFile);

const fallbackResult = (reason = 'Автоматический анализ недоступен') => ({
  intonation: 0,
  rhythm: 0,
  articulation: 0,
  total: 0,
  errors: [
    {
      type: 'analysis_unavailable',
      description: reason,
      expected_value: '',
      actual_value: '',
      time_sec: null,
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
  } catch (error) {
    console.error('Python analysis failed:', error.message);
    if (error.stderr) console.error(error.stderr);
    if (error.stdout) console.error(error.stdout);
    return fallbackResult('Не удалось выполнить Python-анализ записи.');
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
