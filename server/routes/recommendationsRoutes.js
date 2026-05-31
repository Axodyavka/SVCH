const express = require('express');
const { Recommendation } = require('../models');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.get('/', protect, async (req, res, next) => {
  try {
    const recommendations = await Recommendation.findAll({
      where: { user_id: req.user.id },
      order: [['created_at', 'DESC']],
      limit: 10,
    });
    res.json(recommendations);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
