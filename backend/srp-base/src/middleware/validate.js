module.exports = function validate(schema) {
  return (req, res, next) => {
    try {
      schema(req);
      next();
    } catch (e) {
      res.status(400).json({ error: 'validation_failed', message: e.message });
    }
  };
};
