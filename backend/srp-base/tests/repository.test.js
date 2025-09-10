describe('BaseRepository', () => {
  function freshRepo() {
    let repo;
    jest.isolateModules(() => {
      // Each call loads a fresh instance (module exports a singleton)
      // eslint-disable-next-line global-require
      repo = require('../src/repositories/baseRepository');
    });
    return repo;
  }

  test('create/list/select/delete character flow', () => {
    const repo = freshRepo();
    const accountId = 'acc-1';

    expect(repo.listCharacters(accountId)).toEqual([]);

    const created = repo.createCharacter(accountId, { firstName: 'Jane', lastName: 'Doe' });
    expect(created).toMatchObject({ id: expect.any(String), firstName: 'Jane', lastName: 'Doe' });

    const list = repo.listCharacters(accountId);
    expect(list).toHaveLength(1);

    const selected = repo.selectCharacter(accountId, created.id);
    expect(selected).toMatchObject({ id: created.id });

    const deleted = repo.deleteCharacter(accountId, created.id);
    expect(deleted).toBe(true);
    expect(repo.listCharacters(accountId)).toHaveLength(0);
  });
});

