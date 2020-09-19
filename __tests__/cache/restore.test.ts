/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable @typescript-eslint/no-require-imports */
import * as cache from '../../src/cache'

jest.mock('cache/dist/restore', () => ({
  run: jest.fn()
}))

const restoreCache = require('cache/dist/restore')

describe('restore cache', () => {
  const OLD_ENV = process.env

  beforeEach(() => {
    jest.resetModules()
    process.env = {...OLD_ENV}
  })

  afterAll(() => {
    process.env = OLD_ENV
  })

  test('calls the run() function on cache/dist/restore', async () => {
    await cache.restore(
      ['/path/to/cache1', '/path/to/cache2'],
      'primary-cache-key',
      ['primary-cache-', 'primary-']
    )

    expect(restoreCache.run).toHaveBeenCalledTimes(1)

    expect(process.env['INPUT_PATH']).toEqual(
      `/path/to/cache1\n/path/to/cache2`
    )
    expect(process.env['INPUT_KEY']).toEqual(`primary-cache-key`)
    expect(process.env['INPUT_RESTORE-KEYS']).toEqual(
      `primary-cache-\nprimary-`
    )
  })
})
