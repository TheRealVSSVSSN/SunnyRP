/** @type {import('jest').Config} */
module.exports = {
  testEnvironment: 'node',
  roots: ['<rootDir>/tests'],
  moduleFileExtensions: ['js', 'json'],
  verbose: false,
  collectCoverageFrom: [
    'src/**/*.js',
    '!src/realtime/**',
  ],
};

