require('dotenv').config({ path: require('path').join(__dirname, '..', '.env') });
const fs = require('fs');
const path = require('path');

const sequelize = require('../config/database');
const {
  User,
  Composition,
  Recording,
  Report,
  ErrorItem,
  Recommendation,
  Achievement,
  UserAchievement,
  Notification,
} = require('../models');

const serverRoot = path.join(__dirname, '..');
const uploadsRoot = path.join(serverRoot, 'uploads');
const uploadsDirs = {
  audio: path.join(uploadsRoot, 'audio'),
  midi: path.join(uploadsRoot, 'midi'),
  sheets: path.join(uploadsRoot, 'sheets'),
  referenceAudio: path.join(uploadsRoot, 'reference-audio'),
};

function ensureUploadsDirs() {
  Object.values(uploadsDirs).forEach((dir) => fs.mkdirSync(dir, { recursive: true }));
}

function toRelativePath(filePath) {
  return path.relative(serverRoot, filePath).split(path.sep).join('/');
}

function listFilesSafe(dirPath) {
  if (!fs.existsSync(dirPath)) return [];
  return fs
    .readdirSync(dirPath, { withFileTypes: true })
    .filter((entry) => entry.isFile() && !entry.name.startsWith('.'))
    .map((entry) => path.join(dirPath, entry.name))
    .sort((a, b) => a.localeCompare(b));
}

function listFilesByExtensions(dirPath, extensions) {
  const allowed = new Set(extensions.map((ext) => ext.toLowerCase()));
  return listFilesSafe(dirPath).filter((filePath) => allowed.has(path.extname(filePath).toLowerCase()));
}

function pickByIndex(files, idx) {
  if (!files.length) return null;
  return files[idx % files.length];
}

async function seed() {
  ensureUploadsDirs();

  const mediaFiles = {
    audio: listFilesByExtensions(uploadsDirs.audio, ['.mp3', '.wav']),
    midi: listFilesByExtensions(uploadsDirs.midi, ['.mid', '.midi']),
    sheets: listFilesByExtensions(uploadsDirs.sheets, ['.pdf', '.png', '.jpg', '.jpeg']),
    referenceAudio: listFilesByExtensions(uploadsDirs.referenceAudio, ['.mp3', '.wav']),
  };

  await sequelize.authenticate();
  await sequelize.sync({ force: true });

  const achievements = await Achievement.bulkCreate([
    {
      code: 'first_upload',
      title: 'Первый шаг',
      description: 'Загрузите первую аудиозапись исполнения',
    },
    {
      code: 'five_reports',
      title: 'На верном пути',
      description: 'Получите 5 отчётов об исполнении',
    },
    {
      code: 'score_80',
      title: 'Отличный результат',
      description: 'Получите оценку 80 и выше хотя бы один раз',
    },
    {
      code: 'library_explorer',
      title: 'Исследователь библиотеки',
      description: 'Исполните 10 разных произведений',
    },
    {
      code: 'week_streak',
      title: 'Неделя практики',
      description: 'Практикуйтесь 7 дней подряд',
    },
  ]);

  const users = await User.bulkCreate([
    { login: 'admin', email: 'admin@music.local', password: 'admin123', role: 'admin' },
    { login: 'admin2', email: 'admin2@music.local', password: 'admin123', role: 'admin' },
    { login: 'musician1', email: 'musician1@music.local', password: 'pass123', role: 'musician', instrument: 'Фортепиано' },
    { login: 'musician2', email: 'musician2@music.local', password: 'pass123', role: 'musician', instrument: 'Скрипка' },
    { login: 'musician3', email: 'musician3@music.local', password: 'pass123', role: 'musician', instrument: 'Гитара' },
    { login: 'musician4', email: 'musician4@music.local', password: 'pass123', role: 'musician', instrument: 'Флейта' },
    { login: 'musician5', email: 'musician5@music.local', password: 'pass123', role: 'musician' },
    { login: 'musician6', email: 'musician6@music.local', password: 'pass123', role: 'musician' },
    { login: 'musician7', email: 'musician7@music.local', password: 'pass123', role: 'musician' },
    { login: 'musician8', email: 'musician8@music.local', password: 'pass123', role: 'musician' },
  ]);

  const compositions = await Composition.bulkCreate(
    [
      { title: 'Prelude in C Major', composer: 'J. S. Bach', instrument: 'Фортепиано', difficulty: 'Легкий', material_type: 'composition' },
      { title: 'Minuet in G', composer: 'J. S. Bach', instrument: 'Фортепиано', difficulty: 'Легкий', material_type: 'composition' },
      { title: 'Fur Elise (fragment)', composer: 'L. van Beethoven', instrument: 'Фортепиано', difficulty: 'Средний', material_type: 'composition' },
      { title: 'Etude Op. 599 No. 1', composer: 'C. Czerny', instrument: 'Фортепиано', difficulty: 'Легкий', material_type: 'exercise' },
      { title: 'Twinkle, Twinkle, Little Star', composer: 'Traditional', instrument: 'Скрипка', difficulty: 'Легкий', material_type: 'composition' },
      { title: 'Gavotte', composer: 'F. Gossec', instrument: 'Скрипка', difficulty: 'Средний', material_type: 'composition' },
      { title: 'Romanza', composer: 'Anonymous', instrument: 'Гитара', difficulty: 'Легкий', material_type: 'composition' },
      { title: 'Andantino', composer: 'M. Carcassi', instrument: 'Гитара', difficulty: 'Средний', material_type: 'composition' },
      { title: 'Long tones practice', composer: 'Methodical', instrument: 'Флейта', difficulty: 'Легкий', material_type: 'exercise' },
      { title: 'Scale in C major', composer: 'Methodical', instrument: 'Флейта', difficulty: 'Легкий', material_type: 'exercise' },
    ].map((composition, idx) => ({
      ...composition,
      midi_path: pickByIndex(mediaFiles.midi, idx) ? toRelativePath(pickByIndex(mediaFiles.midi, idx)) : null,
      sheet_file_path: pickByIndex(mediaFiles.sheets, idx) ? toRelativePath(pickByIndex(mediaFiles.sheets, idx)) : null,
      reference_audio_path: pickByIndex(mediaFiles.referenceAudio, idx)
        ? toRelativePath(pickByIndex(mediaFiles.referenceAudio, idx))
        : null,
    })),
  );

  const musician1 = users.find((u) => u.login === 'musician1');
  const now = Date.now();

  const recordings = [];
  for (let i = 0; i < 6; i += 1) {
    const rec = await Recording.create({
      user_id: musician1.id,
      composition_id: compositions[i % compositions.length].id,
      audio_path: pickByIndex(mediaFiles.audio, i)
        ? toRelativePath(pickByIndex(mediaFiles.audio, i))
        : `uploads/audio/demo-${i + 1}.mp3`,
      status: 'completed',
      uploaded_at: new Date(now - (6 - i) * 24 * 60 * 60 * 1000),
    });
    recordings.push(rec);
  }

  const demoScores = [62, 71, 78, 82, 86, 90];
  for (let i = 0; i < recordings.length; i += 1) {
    const score = demoScores[i];
    const report = await Report.create({
      recording_id: recordings[i].id,
      total_score: score,
      intonation: Math.max(40, score - 8),
      rhythm: Math.max(40, score - 6),
      articulation: Math.max(40, score - 10),
      created_at: recordings[i].uploaded_at,
    });

    await ErrorItem.bulkCreate([
      {
        report_id: report.id,
        type: 'intonation',
        description: 'Нестабильная высота звука на отдельных нотах',
        expected_value: 'Точное попадание в высоту',
        actual_value: 'Колебание тона',
        time_sec: 12.5,
      },
      {
        report_id: report.id,
        type: 'rhythm',
        description: 'Опережение доли в конце фразы',
        expected_value: 'Ровный пульс',
        actual_value: 'Небольшое ускорение',
        time_sec: 28.1,
      },
    ]);

    await Recommendation.create({
      user_id: musician1.id,
      report_id: report.id,
      text: 'Работайте с метрономом и уделите внимание ровности ритма в концах фраз.',
      created_at: recordings[i].uploaded_at,
    });
  }

  const byCode = new Map(achievements.map((a) => [a.code, a]));
  await UserAchievement.bulkCreate([
    { user_id: musician1.id, achievement_id: byCode.get('first_upload').id },
    { user_id: musician1.id, achievement_id: byCode.get('five_reports').id },
    { user_id: musician1.id, achievement_id: byCode.get('score_80').id },
  ]);

  await Notification.bulkCreate([
    {
      user_id: musician1.id,
      type: 'report_ready',
      title: 'Отчёт готов: Prelude in C Major',
      link: `/reports/${1}`,
    },
    {
      user_id: musician1.id,
      type: 'achievement',
      title: 'Получено достижение: Первый шаг',
      link: '/profile',
    },
  ]);

  console.log('Seed completed successfully.');
  console.log('Admin: admin / admin123');
  console.log('Musician: musician1 / pass123');
  console.log(`Found media files: audio=${mediaFiles.audio.length}, midi=${mediaFiles.midi.length}, sheets=${mediaFiles.sheets.length}, referenceAudio=${mediaFiles.referenceAudio.length}`);
}

seed()
  .catch((error) => {
    console.error('Seed failed:', error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await sequelize.close();
  });
