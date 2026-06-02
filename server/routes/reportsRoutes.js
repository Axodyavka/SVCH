const express = require('express');
const { Op } = require('sequelize');
const {
  Report,
  Recording,
  Composition,
  ErrorItem,
  Recommendation,
} = require('../models');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

const reportInclude = [
  {
    model: Recording,
    as: 'recording',
    include: [{ model: Composition, as: 'composition' }],
  },
  { model: ErrorItem, as: 'errors' },
  { model: Recommendation, as: 'recommendations' },
];

function buildDateWhere(dateFrom, dateTo) {
  const where = {};
  if (dateFrom || dateTo) {
    where.created_at = {};
    if (dateFrom) where.created_at[Op.gte] = new Date(dateFrom);
    if (dateTo) {
      const endDate = new Date(dateTo);
      endDate.setHours(23, 59, 59, 999);
      where.created_at[Op.lte] = endDate;
    }
  }
  return where;
}

router.get('/recent', protect, async (req, res, next) => {
  try {
    const reports = await Report.findAll({
      include: [
        {
          model: Recording,
          as: 'recording',
          where: { user_id: req.user.id },
          include: [{ model: Composition, as: 'composition' }],
        },
      ],
      order: [['created_at', 'DESC']],
      limit: 5,
    });
    res.json(reports);
  } catch (error) {
    next(error);
  }
});

router.get('/progress', protect, async (req, res, next) => {
  try {
    const { dateFrom, dateTo } = req.query;
    const where = buildDateWhere(dateFrom, dateTo);

    const reports = await Report.findAll({
      where,
      attributes: ['id', 'total_score', 'intonation', 'rhythm', 'articulation', 'created_at'],
      include: [
        {
          model: Recording,
          as: 'recording',
          attributes: ['id'],
          where: { user_id: req.user.id },
          include: [{ model: Composition, as: 'composition', attributes: ['title'] }],
        },
      ],
      order: [['created_at', 'ASC']],
    });
    res.json(reports);
  } catch (error) {
    next(error);
  }
});

router.get('/', protect, async (req, res, next) => {
  try {
    const { sort = 'date_desc', dateFrom, dateTo } = req.query;
    const where = buildDateWhere(dateFrom, dateTo);

    let order = [['created_at', 'DESC']];
    if (sort === 'date_asc') order = [['created_at', 'ASC']];
    if (sort === 'score_desc') order = [['total_score', 'DESC']];
    if (sort === 'score_asc') order = [['total_score', 'ASC']];

    const reports = await Report.findAll({
      where,
      include: [
        {
          model: Recording,
          as: 'recording',
          where: { user_id: req.user.id },
          include: [{ model: Composition, as: 'composition' }],
        },
      ],
      order,
    });

    res.json(reports);
  } catch (error) {
    next(error);
  }
});

router.get('/:id', protect, async (req, res, next) => {
  try {
    const report = await Report.findByPk(req.params.id, { include: reportInclude });

    if (!report || report.recording.user_id !== req.user.id) {
      return res.status(404).json({ message: 'Отчёт не найден' });
    }

    res.json(report);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
