/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable @typescript-eslint/no-require-imports */
import * as cache from '../../src/cache'

jest.mock('cache/dist/save', () => ({
  run: jest.fn()
}))

const saveCache = require('cache/dist/save')

describe('save cache', () => {
  const OLD_ENV = process.env

  beforeEach(() => {
    jest.resetModules()
    process.env = {...OLD_ENV}
  })

  afterAll(() => {
    process.env = OLD_ENV
  })

  test('calls the run() function on cache/dist/save', async () => {
    await cache.save(
      ['/path/to/cache1', '/path/to/cache2'],
      'primary-cache-key',
      ['primary-cache-', 'primary-']
    )

    expect(saveCache.run).toHaveBeenCalledTimes(1)

    expect(process.env['INPUT_PATH']).toEqual(
      `/path/to/cache1\n/path/to/cache2`
    )
    expect(process.env['INPUT_KEY']).toEqual(`primary-cache-key`)
    expect(process.env['INPUT_RESTORE-KEYS']).toEqual(
      `primary-cache-\nprimary-`
    )
  })
})
