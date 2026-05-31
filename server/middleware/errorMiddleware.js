const errorMiddleware = (err, req, res, next) => {
  console.error(err);
  const status = err.code === 'LIMIT_FILE_SIZE' ? 413 : err.status || 500;
  res.status(status).json({
    message: err.message || 'Внутренняя ошибка сервера',
  });
};

module.exports = errorMiddleware;
