function mockReqRes(headers = {}) {
  const req = { headers: Object.fromEntries(Object.entries(headers).map(([k, v]) => [k.toLowerCase(), v])) };
  const store = { statusCode: 200, headers: {}, body: undefined };
  const res = {
    status(code) { store.statusCode = code; return this; },
    send(body) { store.body = body; },
    json(obj) { store.body = JSON.stringify(obj); },
    setHeader(k, v) { store.headers[k] = v; },
    getHeaders() { return { ...store.headers }; },
  };
  return { req, res, store };
}

describe('middleware', () => {
  test('hmacAuth denies without header, allows with correct key', () => {
    jest.isolateModules(() => {
      process.env.SRP_INTERNAL_KEY = 'secret';
      const hmac = require('../src/middleware/hmacAuth');

      const { req: r1, res: s1, store: st1 } = mockReqRes({});
      let called = false;
      hmac(r1, s1, () => { called = true; });
      expect(called).toBe(false);
      expect(st1.statusCode).toBe(401);

      const { req: r2, res: s2 } = mockReqRes({ 'x-srp-internal-key': 'secret' });
      called = false;
      hmac(r2, s2, () => { called = true; });
      expect(called).toBe(true);
    });
  });

  test('idempotency caches responses with same key', () => {
    const idempotency = require('../src/middleware/idempotency');
    const mw = idempotency();

    const key = 'abc-123';
    const first = mockReqRes({ 'idempotency-key': key });
    let nextCalled = false;
    mw(first.req, first.res, () => { nextCalled = true; });
    expect(nextCalled).toBe(true);
    first.res.status(201).send('created');

    const second = mockReqRes({ 'idempotency-key': key });
    nextCalled = false;
    mw(second.req, second.res, () => { nextCalled = true; });
    // Should not call next; response served from cache
    expect(nextCalled).toBe(false);
    expect(second.store.statusCode).toBe(201);
    expect(second.store.body).toBe('created');
  });
});
