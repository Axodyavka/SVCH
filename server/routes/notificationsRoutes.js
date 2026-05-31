const express = require('express');
const { Notification } = require('../models');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.get('/', protect, async (req, res, next) => {
  try {
    const notifications = await Notification.findAll({
      where: { user_id: req.user.id },
      order: [['created_at', 'DESC']],
      limit: 30,
    });
    const unreadCount = await Notification.count({
      where: { user_id: req.user.id, is_read: false },
    });
    res.json({ notifications, unreadCount });
  } catch (error) {
    next(error);
  }
});

router.put('/read-all', protect, async (req, res, next) => {
  try {
    await Notification.update(
      { is_read: true },
      { where: { user_id: req.user.id, is_read: false } },
    );
    res.json({ message: 'Все уведомления прочитаны' });
  } catch (error) {
    next(error);
  }
});

router.put('/:id/read', protect, async (req, res, next) => {
  try {
    const notification = await Notification.findOne({
      where: { id: req.params.id, user_id: req.user.id },
    });
    if (!notification) {
      return res.status(404).json({ message: 'Уведомление не найдено' });
    }
    notification.is_read = true;
    await notification.save();
    res.json({ message: 'Прочитано' });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
