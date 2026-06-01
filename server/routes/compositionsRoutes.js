const express = require('express');
const { Op } = require('sequelize');
const path = require('path');
const fs = require('fs');
const { body, validationResult } = require('express-validator');
const multer = require('multer');
const { Composition, CompositionSuggestion } = require('../models');
const { protect, adminOnly } = require('../middleware/authMiddleware');

const router = express.Router();
const serverRoot = path.join(__dirname, '..');
const midiDir = path.join(serverRoot, 'uploads/midi');
const sheetDir = path.join(serverRoot, 'uploads/sheets');
const referenceDir = path.join(serverRoot, 'uploads/reference-audio');

[midiDir, sheetDir, referenceDir].forEach((dir) => fs.mkdirSync(dir, { recursive: true }));

function toRelativePath(absolutePath) {
  return path.relative(serverRoot, absolutePath).split(path.sep).join('/');
}

function resolveStoredPath(storedPath) {
  if (!storedPath) return null;
  if (path.isAbsolute(storedPath)) return storedPath;
  return path.join(serverRoot, storedPath);
}

function removeStoredFile(storedPath) {
  const fullPath = resolveStoredPath(storedPath);
  if (fullPath && fs.existsSync(fullPath)) {
    fs.unlinkSync(fullPath);
  }
}

const adminMediaUpload = multer({
  storage: multer.diskStorage({
    destination: (_req, file, cb) => {
      if (file.fieldname === 'midi') cb(null, midiDir);
      else if (file.fieldname === 'sheet') cb(null, sheetDir);
      else cb(null, referenceDir);
    },
    filename: (_req, file, cb) => {
      const unique = `${Date.now()}-${Math.round(Math.random() * 1e9)}`;
      cb(null, `${unique}${path.extname(file.originalname).toLowerCase()}`);
    },
  }),
  limits: { fileSize: 20 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    if (file.fieldname === 'midi') {
      if (['.mid', '.midi'].includes(ext)) cb(null, true);
      else cb(new Error('MIDI: допустимы только .mid и .midi'));
      return;
    }
    if (file.fieldname === 'sheet') {
      if (['.pdf', '.png', '.jpg', '.jpeg'].includes(ext)) cb(null, true);
      else cb(new Error('Ноты: допустимы PDF, PNG или JPG'));
      return;
    }
    if (file.fieldname === 'referenceAudio') {
      if (['.mp3', '.wav', '.mpeg'].includes(ext)) cb(null, true);
      else cb(new Error('Аудио: допустимы только WAV и MP3'));
      return;
    }
    cb(new Error('Неизвестный тип файла'));
  },
});

function applyUploadedFiles(composition, files) {
  if (files?.midi?.[0]) {
    removeStoredFile(composition.midi_path);
    composition.midi_path = toRelativePath(files.midi[0].path);
  }
  if (files?.sheet?.[0]) {
    removeStoredFile(composition.sheet_file_path);
    composition.sheet_file_path = toRelativePath(files.sheet[0].path);
  }
  if (files?.referenceAudio?.[0]) {
    removeStoredFile(composition.reference_audio_path);
    composition.reference_audio_path = toRelativePath(files.referenceAudio[0].path);
  }
}

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
  adminMediaUpload.fields([
    { name: 'sheet', maxCount: 1 },
    { name: 'referenceAudio', maxCount: 1 },
  ]),
  [
    body('title').trim().notEmpty().withMessage('Укажите название'),
    body('composer').trim().notEmpty().withMessage('Укажите композитора'),
    body('instrument').trim().notEmpty().withMessage('Укажите инструмент'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg });
      }

      if (!req.files?.sheet?.[0]) {
        return res.status(400).json({ message: 'Загрузите файл нот' });
      }
      if (!req.files?.referenceAudio?.[0]) {
        return res.status(400).json({ message: 'Загрузите эталонную запись' });
      }

      const suggestion = await CompositionSuggestion.create({
        user_id: req.user.id,
        title: req.body.title,
        composer: req.body.composer,
        instrument: req.body.instrument,
        sheet_file_path: toRelativePath(req.files.sheet[0].path),
        reference_audio_path: toRelativePath(req.files.referenceAudio[0].path),
        status: 'pending',
      });
      res.status(201).json(suggestion);
    } catch (error) {
      next(error);
    }
  },
);

router.get('/:id/files/:kind', async (req, res, next) => {
  try {
    const { kind } = req.params;
    const composition = await Composition.findByPk(req.params.id);
    if (!composition) {
      return res.status(404).json({ message: 'Произведение не найдено' });
    }

    const fileMap = {
      midi: composition.midi_path,
      sheet: composition.sheet_file_path,
      'reference-audio': composition.reference_audio_path,
    };

    const storedPath = fileMap[kind];
    if (!storedPath) {
      return res.status(404).json({ message: 'Файл не найден' });
    }

    const fullPath = resolveStoredPath(storedPath);
    if (!fullPath || !fs.existsSync(fullPath)) {
      return res.status(404).json({ message: 'Файл не найден на сервере' });
    }

    return res.sendFile(fullPath);
  } catch (error) {
    return next(error);
  }
});

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
  adminMediaUpload.fields([
    { name: 'midi', maxCount: 1 },
    { name: 'sheet', maxCount: 1 },
    { name: 'referenceAudio', maxCount: 1 },
  ]),
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

      const composition = await Composition.create({
        title: req.body.title,
        composer: req.body.composer,
        instrument: req.body.instrument,
        difficulty: req.body.difficulty || 'easy',
        material_type: req.body.material_type || 'composition',
        sheet_notes: req.body.sheet_notes || null,
      });

      applyUploadedFiles(composition, req.files);
      await composition.save();

      res.status(201).json(composition);
    } catch (error) {
      next(error);
    }
  },
);

router.put(
  '/:id',
  protect,
  adminOnly,
  adminMediaUpload.fields([
    { name: 'midi', maxCount: 1 },
    { name: 'sheet', maxCount: 1 },
    { name: 'referenceAudio', maxCount: 1 },
  ]),
  async (req, res, next) => {
    try {
      const composition = await Composition.findByPk(req.params.id);
      if (!composition) {
        return res.status(404).json({ message: 'Произведение не найдено' });
      }

      const { title, composer, instrument, difficulty, material_type, sheet_notes } = req.body;
      if (title != null) composition.title = title;
      if (composer != null) composition.composer = composer;
      if (instrument != null) composition.instrument = instrument;
      if (difficulty != null) composition.difficulty = difficulty;
      if (material_type != null) composition.material_type = material_type;
      if (sheet_notes !== undefined) composition.sheet_notes = sheet_notes || null;

      applyUploadedFiles(composition, req.files);
      await composition.save();

      res.json(composition);
    } catch (error) {
      next(error);
    }
  },
);

router.delete('/:id', protect, adminOnly, async (req, res, next) => {
  try {
    const composition = await Composition.findByPk(req.params.id);
    if (!composition) {
      return res.status(404).json({ message: 'Произведение не найдено' });
    }

    removeStoredFile(composition.midi_path);
    removeStoredFile(composition.sheet_file_path);
    removeStoredFile(composition.reference_audio_path);

    await composition.destroy();
    res.json({ message: 'Произведение удалено' });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
