const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const ErrorItem = sequelize.define(
  'ErrorItem',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    report_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    type: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    expected_value: {
      type: DataTypes.STRING(100),
      allowNull: true,
    },
    actual_value: {
      type: DataTypes.STRING(100),
      allowNull: true,
    },
    time_sec: {
      type: DataTypes.FLOAT,
      allowNull: true,
    },
  },
  {
    tableName: 'errors',
    timestamps: false,
  },
);

module.exports = ErrorItem;
