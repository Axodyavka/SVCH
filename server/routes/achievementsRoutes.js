const express = require('express');
const { protect } = require('../middleware/authMiddleware');
const { getAchievementsProgress } = require('../services/achievementService');

const router = express.Router();

router.get('/', protect, async (req, res, next) => {
  try {
    const achievements = await getAchievementsProgress(req.user.id);
    res.json(achievements);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
