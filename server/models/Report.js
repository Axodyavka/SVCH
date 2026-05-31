const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Report = sequelize.define(
  'Report',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    recording_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      unique: true,
    },
    total_score: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    intonation: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    rhythm: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    articulation: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    created_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    tableName: 'reports',
    timestamps: false,
  },
);

module.exports = Report;
