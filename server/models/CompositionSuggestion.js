const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const CompositionSuggestion = sequelize.define(
  'CompositionSuggestion',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    title: {
      type: DataTypes.STRING(200),
      allowNull: false,
    },
    composer: {
      type: DataTypes.STRING(150),
      allowNull: false,
    },
    instrument: {
      type: DataTypes.STRING(100),
      allowNull: true,
    },
    reference_audio_path: {
      type: DataTypes.STRING(500),
      allowNull: true,
    },
    sheet_file_path: {
      type: DataTypes.STRING(500),
      allowNull: true,
    },
    status: {
      type: DataTypes.ENUM('pending', 'approved', 'rejected'),
      defaultValue: 'pending',
    },
    created_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    tableName: 'composition_suggestions',
    timestamps: false,
  },
);

module.exports = CompositionSuggestion;
