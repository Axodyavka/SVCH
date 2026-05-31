const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Recording = sequelize.define(
  'Recording',
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
    composition_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    audio_path: {
      type: DataTypes.STRING(500),
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM('processing', 'completed', 'failed'),
      defaultValue: 'processing',
    },
    uploaded_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    tableName: 'recordings',
    timestamps: false,
  },
);

module.exports = Recording;
