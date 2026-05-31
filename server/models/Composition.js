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
    midi_path: {
      type: DataTypes.STRING(500),
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
