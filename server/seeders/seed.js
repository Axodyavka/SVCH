require('dotenv').config();
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
  CompositionSuggestion,
} = require('../models');

const composers = [
  'Бах', 'Моцарт', 'Бетховен', 'Шопен', 'Вивальди', 'Гайдн', 'Шуберт', 'Дебюсси',
];
const titles = [
  'Маленькая ночная серенада', 'Лунная соната', 'Экспромт', 'Прелюдия', 'Этюд',
  'Менуэт', 'Сонатина', 'Гамма до мажор', 'Вальс', 'Марш', 'Баркарола', 'Ноктюрн',
  'Адажио', 'Скерцо', 'Рондо', 'Каприс', 'Баллада', 'Фантазия', 'Пассаж', 'Полонез',
];
const instruments = ['Фортепиано', 'Скрипка', 'Гитара', 'Флейта'];
const errorTypes = ['wrong_pitch', 'missing_note', 'early', 'late', 'articulation'];

const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];

async function seed() {
  try {
    await sequelize.sync({ force: true });
    console.log('Tables recreated');

    const admin1 = await User.create({
      login: 'admin',
      email: 'admin@music.local',
      password: 'admin123',
      role: 'admin',
    });
    const admin2 = await User.create({
      login: 'admin2',
      email: 'admin2@music.local',
      password: 'admin123',
      role: 'admin',
    });

    const musicians = [];
    for (let i = 1; i <= 8; i += 1) {
      musicians.push(
        await User.create({
          login: `musician${i}`,
          email: `musician${i}@music.local`,
          password: 'pass123',
          role: 'musician',
          instrument: pick(instruments),
          level: pick(['Начинающий', 'Средний', 'Продвинутый']),
        }),
      );
    }

    const compositions = [];
    for (let i = 0; i < 20; i += 1) {
      compositions.push(
        await Composition.create({
          title: titles[i],
          composer: composers[i % composers.length],
          instrument: instruments[i % instruments.length],
          difficulty: pick(['Легкий', 'Средний', 'Сложный']),
          material_type: i === 7 || i === 18 ? 'exercise' : 'composition',
          midi_path: null,
          sheet_notes:
            i === 7
              ? 'Гамма до мажор, 2 октавы, ровные восьмые, темп 60.'
              : i === 18
                ? 'Пассаж на ровность пальцев, темп 70, следить за одинаковой длительностью нот.'
              : i === 4
                ? 'Этюд на легато. Следить за ровным соединением нот.'
                : null,
        }),
      );
    }

    const achievements = [];
    const achievementDefs = [
      { code: 'first_upload', title: 'Первый шаг', description: 'Загрузите первую запись' },
      { code: 'five_reports', title: 'Пятёрка', description: 'Получите 5 отчётов' },
      { code: 'score_80', title: 'Отличник', description: 'Наберите 80+ баллов' },
      { code: 'week_streak', title: 'Неделя практики', description: '7 дней подряд с записями' },
      { code: 'library_explorer', title: 'Исследователь', description: 'Исполните 10 произведений' },
    ];
    for (const def of achievementDefs) {
      achievements.push(await Achievement.create(def));
    }

    let totalRecords = 10 + 20 + achievements.length;

    for (const musician of musicians) {
      const reportCount = 10;
      for (let r = 0; r < reportCount; r += 1) {
        const composition = compositions[(musician.id + r) % compositions.length];
        const recording = await Recording.create({
          user_id: musician.id,
          composition_id: composition.id,
          audio_path: `uploads/audio/demo-${musician.id}-${r}.wav`,
          status: 'completed',
          uploaded_at: new Date(Date.now() - (reportCount - r) * 86400000),
        });
        totalRecords += 1;

        const intonation = 55 + Math.floor(Math.random() * 40);
        const rhythm = 55 + Math.floor(Math.random() * 40);
        const articulation = 55 + Math.floor(Math.random() * 40);
        const total = Math.round((intonation + rhythm + articulation) / 3);

        const report = await Report.create({
          recording_id: recording.id,
          total_score: total,
          intonation,
          rhythm,
          articulation,
          created_at: recording.uploaded_at,
        });
        totalRecords += 1;

        for (let e = 0; e < 2; e += 1) {
          await ErrorItem.create({
            report_id: report.id,
            type: pick(errorTypes),
            description: 'Ошибка при сравнении с эталоном',
            expected_value: 'C4',
            actual_value: 'B3',
            time_sec: Math.round(Math.random() * 30 * 100) / 100,
          });
          totalRecords += 1;
        }

        await Recommendation.create({
          user_id: musician.id,
          report_id: report.id,
          text: 'Практикуйте с метрономом для улучшения ритма.',
        });
        totalRecords += 1;

        if (r === reportCount - 1) {
          await Notification.create({
            user_id: musician.id,
            type: 'report_ready',
            title: 'Отчёт готов',
            link: `/reports/${report.id}`,
            is_read: Math.random() > 0.5,
          });
          totalRecords += 1;
        }
      }

      await UserAchievement.create({
        user_id: musician.id,
        achievement_id: achievements[0].id,
        earned_at: new Date(),
      });
      totalRecords += 1;

      if (musician.id % 2 === 0) {
        await CompositionSuggestion.create({
          user_id: musician.id,
          title: `Предложение от ${musician.login}`,
          composer: pick(composers),
          instrument: musician.instrument,
          status: 'pending',
        });
        totalRecords += 1;
      }
    }

    console.log(`Seed complete. Admin: admin / admin123`);
    console.log(`Musicians: musician1..8 / pass123`);
    console.log(`Total records: ${totalRecords}`);
    process.exit(0);
  } catch (error) {
    console.error('Seed failed:', error);
    process.exit(1);
  }
}

seed();
