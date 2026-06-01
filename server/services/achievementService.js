const { Op } = require('sequelize');
const {
  Achievement,
  UserAchievement,
  Recording,
  Report,
  Notification,
} = require('../models');

const ACHIEVEMENT_RULES = [
  {
    code: 'first_upload',
    target: 1,
    getValue: ({ recordingsCount }) => recordingsCount,
  },
  {
    code: 'five_reports',
    target: 5,
    getValue: ({ reportsCount }) => reportsCount,
  },
  {
    code: 'score_80',
    target: 1,
    getValue: ({ bestScore }) => (bestScore >= 80 ? 1 : 0),
  },
  {
    code: 'library_explorer',
    target: 10,
    getValue: ({ uniqueCompositionsCount }) => uniqueCompositionsCount,
  },
  {
    code: 'week_streak',
    target: 7,
    getValue: ({ practiceDaysCount }) => practiceDaysCount,
  },
];

async function getAchievementStats(userId) {
  const recordings = await Recording.findAll({
    where: { user_id: userId, status: 'completed' },
    attributes: ['id', 'composition_id', 'uploaded_at'],
  });
  const recordingIds = recordings.map((recording) => recording.id);
  const reports = recordingIds.length
    ? await Report.findAll({
        where: { recording_id: { [Op.in]: recordingIds } },
        attributes: ['id', 'total_score'],
      })
    : [];

  const practiceDays = new Set(
    recordings.map((recording) => new Date(recording.uploaded_at).toISOString().slice(0, 10)),
  );
  const uniqueCompositions = new Set(recordings.map((recording) => recording.composition_id));

  return {
    recordingsCount: recordings.length,
    reportsCount: reports.length,
    bestScore: reports.reduce((max, report) => Math.max(max, report.total_score || 0), 0),
    uniqueCompositionsCount: uniqueCompositions.size,
    practiceDaysCount: practiceDays.size,
  };
}

async function getAchievementsProgress(userId) {
  const [achievements, earnedRows, stats] = await Promise.all([
    Achievement.findAll({ order: [['id', 'ASC']] }),
    UserAchievement.findAll({
      where: { user_id: userId },
      include: [{ model: Achievement, as: 'achievement' }],
    }),
    getAchievementStats(userId),
  ]);

  const earnedByCode = new Map(earnedRows.map((row) => [row.achievement.code, row]));

  return achievements.map((achievement) => {
    const rule = ACHIEVEMENT_RULES.find((item) => item.code === achievement.code);
    const target = rule?.target || 1;
    const value = Math.min(rule ? rule.getValue(stats) : 0, target);
    const earned = earnedByCode.get(achievement.code);

    return {
      id: achievement.id,
      code: achievement.code,
      title: achievement.title,
      description: achievement.description,
      progress: value,
      target,
      isEarned: Boolean(earned),
      earned_at: earned?.earned_at || null,
    };
  });
}

async function awardAvailableAchievements(userId) {
  const progress = await getAchievementsProgress(userId);
  const newlyEarned = [];

  for (const item of progress) {
    if (item.isEarned || item.progress < item.target) continue;

    await UserAchievement.create({
      user_id: userId,
      achievement_id: item.id,
    });
    await Notification.create({
      user_id: userId,
      type: 'achievement',
      title: `Получено достижение: ${item.title}`,
      link: '/profile',
    });
    newlyEarned.push(item);
  }

  return newlyEarned;
}

module.exports = {
  awardAvailableAchievements,
  getAchievementsProgress,
};
