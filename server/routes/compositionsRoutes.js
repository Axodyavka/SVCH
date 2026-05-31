const express = require('express');
const { Op } = require('sequelize');
const { body, validationResult } = require('express-validator');
const { Composition } = require('../models');
const { protect, adminOnly } = require('../middleware/authMiddleware');

const router = express.Router();

router.get('/', async (req, res, next) => {
  try {
    const { search, instrument } = req.query;
    const where = {};

    if (search) {
      where[Op.or] = [
        { title: { [Op.iLike]: `%${search}%` } },
        { composer: { [Op.iLike]: `%${search}%` } },
      ];
    }

    if (instrument) {
      where.instrument = instrument;
    }

    const compositions = await Composition.findAll({
      where,
      order: [['title', 'ASC']],
    });

    res.json(compositions);
  } catch (error) {
    next(error);
  }
});

router.post(
  '/suggest',
  protect,
  [
    body('title').trim().notEmpty().withMessage('Укажите название'),
    body('composer').trim().notEmpty().withMessage('Укажите композитора'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg });
      }
      const { CompositionSuggestion } = require('../models');
      const suggestion = await CompositionSuggestion.create({
        user_id: req.user.id,
        title: req.body.title,
        composer: req.body.composer,
        instrument: req.body.instrument || req.user.instrument,
        status: 'pending',
      });
      res.status(201).json(suggestion);
    } catch (error) {
      next(error);
    }
  },
);

router.get('/:id', async (req, res, next) => {
  try {
    const composition = await Composition.findByPk(req.params.id);
    if (!composition) {
      return res.status(404).json({ message: 'Произведение не найдено' });
    }
    res.json(composition);
  } catch (error) {
    next(error);
  }
});

router.post(
  '/',
  protect,
  adminOnly,
  [
    body('title').trim().notEmpty(),
    body('composer').trim().notEmpty(),
    body('instrument').trim().notEmpty(),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg });
      }
      const composition = await Composition.create(req.body);
      res.status(201).json(composition);
    } catch (error) {
      next(error);
    }
  },
);

router.put('/:id', protect, adminOnly, async (req, res, next) => {
  try {
    const composition = await Composition.findByPk(req.params.id);
    if (!composition) {
      return res.status(404).json({ message: 'Произведение не найдено' });
    }
    await composition.update(req.body);
    res.json(composition);
  } catch (error) {
    next(error);
  }
});

router.delete('/:id', protect, adminOnly, async (req, res, next) => {
  try {
    const composition = await Composition.findByPk(req.params.id);
    if (!composition) {
      return res.status(404).json({ message: 'Произведение не найдено' });
    }
    await composition.destroy();
    res.json({ message: 'Произведение удалено' });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
