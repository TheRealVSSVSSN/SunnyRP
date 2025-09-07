/**
 * SRP Base
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

module.exports = (err, req, res) => {
  console.error(err);
  if (res.headersSent) return;
  res.status(err.status || 500).json({ error: err.message || 'internal_error' });
};
