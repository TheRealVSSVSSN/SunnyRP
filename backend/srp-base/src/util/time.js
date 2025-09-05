export function getCurrentTime() {
  const tz = process.env.TIMEZONE || 'UTC';
  const now = new Date();

  const offsetPattern = /^([+-])(\d{2}):?(\d{2})$/;

  if (tz === 'UTC') {
    return now.toISOString();
  }

  let offsetMinutes;

  if (offsetPattern.test(tz)) {
    const [, sign, hh, mm] = tz.match(offsetPattern);
    offsetMinutes = (sign === '+' ? 1 : -1) * (parseInt(hh, 10) * 60 + parseInt(mm, 10));
  } else {
    const tzDate = new Date(now.toLocaleString('en-US', { timeZone: tz }));
    offsetMinutes = (tzDate.getTime() - now.getTime()) / 60000;
  }

  const sign = offsetMinutes >= 0 ? '+' : '-';
  const abs = Math.abs(offsetMinutes);
  const hours = String(Math.floor(abs / 60)).padStart(2, '0');
  const minutes = String(abs % 60).padStart(2, '0');
  const adjusted = new Date(now.getTime() + offsetMinutes * 60000);
  const iso = adjusted.toISOString().replace('Z', '');
  return `${iso}${sign}${hours}:${minutes}`;
}
