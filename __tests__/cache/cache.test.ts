import * as cache from '../../src/cache'

describe('cache', () => {
  const OLD_ENV = process.env

  beforeEach(() => {
    jest.resetModules()
    process.env = {...OLD_ENV}
  })

  afterAll(() => {
    process.env = OLD_ENV
  })

  test('calls the factory()', async () => {
    const mockFactory = jest.fn()

    await cache.cache(
      mockFactory,
      ['/path/to/cache1', '/path/to/cache2'],
      'primary-cache-key',
      ['primary-cache-', 'primary-']
    )

    expect(mockFactory).toHaveBeenCalledTimes(1)

    expect(process.env['INPUT_PATH']).toEqual(
      `/path/to/cache1\n/path/to/cache2`
    )
    expect(process.env['INPUT_KEY']).toEqual(`primary-cache-key`)
    expect(process.env['INPUT_RESTORE-KEYS']).toEqual(
      `primary-cache-\nprimary-`
    )
  })
})
