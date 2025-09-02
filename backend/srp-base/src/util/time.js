export function getCurrentTime() {
  const tz = process.env.TIMEZONE || 'UTC';
  return new Date().toLocaleString('sv-SE', { timeZone: tz, hour12: false }).replace(' ', 'T');
}
