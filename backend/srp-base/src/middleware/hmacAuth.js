module.exports = (req, res, next) => {
  const key = req.headers['x-srp-internal-key'];
  const expected = process.env.SRP_INTERNAL_KEY || 'change_me';
  if (key && key === expected) {
    return next();
  }
  res.status(401).json({ error: 'unauthorized' });
};
