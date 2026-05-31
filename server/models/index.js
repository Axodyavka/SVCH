const User = require('./User');
const Composition = require('./Composition');
const Recording = require('./Recording');
const Report = require('./Report');
const ErrorItem = require('./ErrorItem');
const Recommendation = require('./Recommendation');
const Achievement = require('./Achievement');
const UserAchievement = require('./UserAchievement');
const Notification = require('./Notification');
const CompositionSuggestion = require('./CompositionSuggestion');

User.hasMany(Recording, { foreignKey: 'user_id', as: 'recordings' });
Recording.belongsTo(User, { foreignKey: 'user_id', as: 'user' });

Composition.hasMany(Recording, { foreignKey: 'composition_id', as: 'recordings' });
Recording.belongsTo(Composition, { foreignKey: 'composition_id', as: 'composition' });

Recording.hasOne(Report, { foreignKey: 'recording_id', as: 'report' });
Report.belongsTo(Recording, { foreignKey: 'recording_id', as: 'recording' });

Report.hasMany(ErrorItem, { foreignKey: 'report_id', as: 'errors' });
ErrorItem.belongsTo(Report, { foreignKey: 'report_id', as: 'report' });

User.hasMany(Recommendation, { foreignKey: 'user_id', as: 'recommendations' });
Recommendation.belongsTo(User, { foreignKey: 'user_id', as: 'user' });
Report.hasMany(Recommendation, { foreignKey: 'report_id', as: 'recommendations' });
Recommendation.belongsTo(Report, { foreignKey: 'report_id', as: 'report' });

Achievement.hasMany(UserAchievement, { foreignKey: 'achievement_id', as: 'userAchievements' });
UserAchievement.belongsTo(Achievement, { foreignKey: 'achievement_id', as: 'achievement' });
User.hasMany(UserAchievement, { foreignKey: 'user_id', as: 'userAchievements' });
UserAchievement.belongsTo(User, { foreignKey: 'user_id', as: 'user' });

User.hasMany(Notification, { foreignKey: 'user_id', as: 'notifications' });
Notification.belongsTo(User, { foreignKey: 'user_id', as: 'user' });

User.hasMany(CompositionSuggestion, { foreignKey: 'user_id', as: 'suggestions' });
CompositionSuggestion.belongsTo(User, { foreignKey: 'user_id', as: 'user' });

module.exports = {
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
};
