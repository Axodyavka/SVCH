const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { Recording, Composition, Notification } = require('../models');
const { protect } = require('../middleware/authMiddleware');
const { analyzeRecording } = require('../services/analysisService');
const { awardAvailableAchievements } = require('../services/achievementService');

const router = express.Router();

const uploadDir = path.join(__dirname, '../uploads/audio');
fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, uploadDir),
  filename: (_req, file, cb) => {
    const unique = `${Date.now()}-${Math.round(Math.random() * 1e9)}`;
    cb(null, `${unique}${path.extname(file.originalname)}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 20 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    const allowed = ['.mp3', '.wav', '.mpeg'];
    const ext = path.extname(file.originalname).toLowerCase();
    if (allowed.includes(ext)) cb(null, true);
    else cb(new Error('Допустимы только WAV и MP3'));
  },
});

router.post('/', protect, upload.single('audio'), async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'Загрузите аудиофайл' });
    }

    const { compositionId } = req.body;
    if (!compositionId) {
      return res.status(400).json({ message: 'Выберите произведение' });
    }

    const composition = await Composition.findByPk(compositionId);
    if (!composition) {
      return res.status(404).json({ message: 'Произведение не найдено' });
    }

    const recording = await Recording.create({
      user_id: req.user.id,
      composition_id: composition.id,
      audio_path: req.file.path,
      status: 'processing',
    });

    try {
      const report = await analyzeRecording(recording, composition);
      recording.status = 'completed';
      await recording.save();

      await Notification.create({
        user_id: req.user.id,
        type: 'report_ready',
        title: 'Отчёт готов',
        link: `/reports/${report.id}`,
      });
      await awardAvailableAchievements(req.user.id);

      res.status(201).json({ recording, reportId: report.id });
    } catch (err) {
      recording.status = 'failed';
      await recording.save();
      throw err;
    }
  } catch (error) {
    next(error);
  }
});

router.get('/', protect, async (req, res, next) => {
  try {
    const recordings = await Recording.findAll({
      where: { user_id: req.user.id },
      include: [{ model: Composition, as: 'composition' }],
      order: [['uploaded_at', 'DESC']],
    });
    res.json(recordings);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
