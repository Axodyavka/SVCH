const express = require('express');
const authRoutes = require('./authRoutes');
const compositionsRoutes = require('./compositionsRoutes');
const recordingsRoutes = require('./recordingsRoutes');
const reportsRoutes = require('./reportsRoutes');
const recommendationsRoutes = require('./recommendationsRoutes');
const notificationsRoutes = require('./notificationsRoutes');
const achievementsRoutes = require('./achievementsRoutes');
const adminRoutes = require('./adminRoutes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/compositions', compositionsRoutes);
router.use('/recordings', recordingsRoutes);
router.use('/reports', reportsRoutes);
router.use('/recommendations', recommendationsRoutes);
router.use('/notifications', notificationsRoutes);
router.use('/achievements', achievementsRoutes);
router.use('/admin', adminRoutes);

module.exports = router;
