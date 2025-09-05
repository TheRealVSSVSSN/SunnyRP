import test from 'node:test';
import assert from 'node:assert/strict';

import { getCurrentTime } from '../src/util/time.js';

test('getCurrentTime returns ISO string in UTC by default', (t) => {
  const original = process.env.TIMEZONE;
  process.env.TIMEZONE = '';
  t.after(() => {
    process.env.TIMEZONE = original;
  });

  const time = getCurrentTime();
  assert.match(time, /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z/);
});

test('getCurrentTime appends timezone offset when specified', (t) => {
  const original = process.env.TIMEZONE;
  process.env.TIMEZONE = '+02:00';
  t.after(() => {
    process.env.TIMEZONE = original;
  });

  const time = getCurrentTime();
  assert.ok(time.endsWith('+02:00'));
});

