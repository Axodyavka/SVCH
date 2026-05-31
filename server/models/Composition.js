const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Composition = sequelize.define(
  'Composition',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
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
      allowNull: false,
    },
    difficulty: {
      type: DataTypes.ENUM('easy', 'medium', 'hard'),
      defaultValue: 'easy',
    },
    material_type: {
      type: DataTypes.STRING(30),
      allowNull: false,
      defaultValue: 'composition',
      validate: {
        isIn: [['composition', 'exercise']],
      },
    },
    midi_path: {
      type: DataTypes.STRING(500),
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
    sheet_notes: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  },
  {
    tableName: 'compositions',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
  },
);

module.exports = Composition;
