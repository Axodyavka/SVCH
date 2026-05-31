const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { body, validationResult } = require('express-validator');
const express = require('express');
const { User } = require('../models');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

const signToken = (user) =>
  jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, { expiresIn: '30d' });

router.post(
  '/register',
  [
    body('login').trim().isLength({ min: 3 }).withMessage('Логин минимум 3 символа'),
    body('email').isEmail().withMessage('Некорректный email'),
    body('password').isLength({ min: 6 }).withMessage('Пароль минимум 6 символов'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg });
      }

      const { login, email, password } = req.body;
      const exists = await User.findOne({ where: { email } });
      if (exists) {
        return res.status(400).json({ message: 'Email уже занят' });
      }

      const loginExists = await User.findOne({ where: { login } });
      if (loginExists) {
        return res.status(400).json({ message: 'Логин уже занят' });
      }

      const user = await User.create({ login, email, password, role: 'musician' });
      const token = signToken(user);
      res.status(201).json({ user: user.toSafeJSON(), token });
    } catch (error) {
      next(error);
    }
  },
);

router.post(
  '/login',
  [
    body('login').trim().notEmpty().withMessage('Введите email или логин'),
    body('password').notEmpty().withMessage('Введите пароль'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg });
      }

      const { login, password } = req.body;
      const user = await User.findOne({
        where: {
          [require('sequelize').Op.or]: [{ email: login }, { login }],
        },
      });

      if (!user) {
        return res.status(401).json({ message: 'Неверный логин или пароль' });
      }

      if (user.status === 'blocked') {
        return res.status(403).json({ message: 'Аккаунт заблокирован' });
      }

      const valid = await bcrypt.compare(password, user.password);
      if (!valid) {
        return res.status(401).json({ message: 'Неверный логин или пароль' });
      }

      const token = signToken(user);
      res.json({ user: user.toSafeJSON(), token });
    } catch (error) {
      next(error);
    }
  },
);

router.get('/me', protect, async (req, res) => {
  res.json({ user: req.user.toSafeJSON() });
});

router.put(
  '/profile',
  protect,
  [
    body('login').optional().trim().isLength({ min: 3 }),
    body('email').optional().isEmail(),
  ],
  async (req, res, next) => {
    try {
      const { login, email, instrument, level, avatar } = req.body;
      const user = req.user;

      if (login && login !== user.login) {
        const exists = await User.findOne({ where: { login } });
        if (exists) return res.status(400).json({ message: 'Логин уже занят' });
        user.login = login;
      }

      if (email && email !== user.email) {
        const exists = await User.findOne({ where: { email } });
        if (exists) return res.status(400).json({ message: 'Email уже занят' });
        user.email = email;
      }

      if (instrument !== undefined) user.instrument = instrument;
      if (level !== undefined) user.level = level;
      if (avatar !== undefined) user.avatar = avatar;

      await user.save();
      res.json({ user: user.toSafeJSON() });
    } catch (error) {
      next(error);
    }
  },
);

router.put(
  '/password',
  protect,
  [
    body('currentPassword').notEmpty().withMessage('Введите текущий пароль'),
    body('newPassword').isLength({ min: 6 }).withMessage('Новый пароль минимум 6 символов'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg });
      }

      const { currentPassword, newPassword } = req.body;
      const valid = await bcrypt.compare(currentPassword, req.user.password);
      if (!valid) {
        return res.status(400).json({ message: 'Неверный текущий пароль' });
      }

      req.user.password = newPassword;
      await req.user.save();
      res.json({ message: 'Пароль изменён' });
    } catch (error) {
      next(error);
    }
  },
);

module.exports = router;
