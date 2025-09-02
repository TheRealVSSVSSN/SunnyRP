import crypto from 'crypto';

export function verifySignature(req, res, next) {
  const signature = req.get('x-srp-signature');
  if (!signature) return res.status(401).json({ error: 'Missing signature' });
  const secret = process.env.SRP_HMAC_SECRET || 'changeme';
  const payload = req.rawBody || '';
  const hmac = crypto.createHmac('sha256', secret).update(payload).digest('hex');
  if (hmac !== signature) return res.status(401).json({ error: 'Invalid signature' });
  next();
}
