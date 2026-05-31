const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Achievement = sequelize.define(
  'Achievement',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    code: {
      type: DataTypes.STRING(50),
      allowNull: false,
      unique: true,
    },
    title: {
      type: DataTypes.STRING(150),
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
  },
  {
    tableName: 'achievements',
    timestamps: false,
  },
);

module.exports = Achievement;
