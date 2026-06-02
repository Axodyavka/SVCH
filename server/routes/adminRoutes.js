const express = require('express');
const path = require('path');
const fs = require('fs');
const {
  User,
  Composition,
  Recording,
  Report,
  CompositionSuggestion,
  Notification,
} = require('../models');
const { protect, adminOnly } = require('../middleware/authMiddleware');

const router = express.Router();
const serverRoot = path.join(__dirname, '..');

function resolveStoredPath(storedPath) {
  if (!storedPath) return null;
  if (path.isAbsolute(storedPath)) return storedPath;
  return path.join(serverRoot, storedPath);
}

router.use(protect, adminOnly);

router.get('/stats', async (_req, res, next) => {
  try {
    const [users, musicians, admins, recordings, reports, suggestions] = await Promise.all([
      User.count(),
      User.count({ where: { role: 'musician' } }),
      User.count({ where: { role: 'admin' } }),
      Recording.count(),
      Report.count(),
      CompositionSuggestion.count({ where: { status: 'pending' } }),
    ]);
    res.json({ users, musicians, admins, recordings, reports, pendingSuggestions: suggestions });
  } catch (error) {
    next(error);
  }
});

router.get('/suggestions', async (_req, res, next) => {
  try {
    const suggestions = await CompositionSuggestion.findAll({
      include: [{ model: User, as: 'user', attributes: ['login', 'email'] }],
      order: [['created_at', 'DESC']],
    });
    res.json(suggestions);
  } catch (error) {
    next(error);
  }
});

router.get('/suggestions/:id/files/:kind', async (req, res, next) => {
  try {
    const suggestion = await CompositionSuggestion.findByPk(req.params.id);
    if (!suggestion) return res.status(404).json({ message: 'Предложение не найдено' });

    const fileMap = {
      midi: suggestion.midi_path,
      sheet: suggestion.sheet_file_path,
      audio: suggestion.reference_audio_path,
    };
    const storedPath = fileMap[req.params.kind];
    if (!storedPath) return res.status(404).json({ message: 'Файл не найден' });

    const fullPath = resolveStoredPath(storedPath);
    if (!fullPath || !fs.existsSync(fullPath)) {
      return res.status(404).json({ message: 'Файл не найден на сервере' });
    }

    return res.sendFile(fullPath);
  } catch (error) {
    return next(error);
  }
});

router.put('/suggestions/:id/approve', async (req, res, next) => {
  try {
    const suggestion = await CompositionSuggestion.findByPk(req.params.id);
    if (!suggestion) return res.status(404).json({ message: 'Предложение не найдено' });
    if (suggestion.status !== 'pending') {
      return res.status(400).json({ message: 'Предложение уже обработано' });
    }

    await Composition.create({
      title: suggestion.title,
      composer: suggestion.composer,
      instrument: suggestion.instrument || 'Фортепиано',
      difficulty: suggestion.difficulty || 'Легкий',
      material_type: 'composition',
      midi_path: suggestion.midi_path,
      sheet_file_path: suggestion.sheet_file_path,
      reference_audio_path: suggestion.reference_audio_path,
    });

    suggestion.status = 'approved';
    await suggestion.save();

    await Notification.create({
      user_id: suggestion.user_id,
      type: 'suggestion_approved',
      title: `Произведение «${suggestion.title}» принято в библиотеку`,
      link: '/library',
    });

    res.json({ message: 'Произведение добавлено в библиотеку' });
  } catch (error) {
    next(error);
  }
});

router.put('/suggestions/:id/reject', async (req, res, next) => {
  try {
    const suggestion = await CompositionSuggestion.findByPk(req.params.id);
    if (!suggestion) return res.status(404).json({ message: 'Предложение не найдено' });
    if (suggestion.status !== 'pending') {
      return res.status(400).json({ message: 'Предложение уже обработано' });
    }

    suggestion.status = 'rejected';
    await suggestion.save();

    await Notification.create({
      user_id: suggestion.user_id,
      type: 'suggestion_rejected',
      title: `Произведение «${suggestion.title}» отклонено`,
      link: '/suggest',
    });

    res.json({ message: 'Предложение отклонено' });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
