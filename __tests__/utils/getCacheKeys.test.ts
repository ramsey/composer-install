import { getCacheKeys } from "../../src/utils/getCacheKeys";

jest.mock('../../src/utils/getPhpVersion', () => {
  return {
    getPhpVersion: jest.fn().mockReturnValue(Promise.resolve('7.99.99'))
  }
})

jest.mock('../../src/utils/hashFiles', () => {
  return {
    hashFiles: jest.fn().mockResolvedValue('foobar')
  }
})

describe('cache keys', () => {
  const OLD_ENV =  process.env

  beforeEach(() => {
    jest.resetModules()
    process.env = { ...OLD_ENV }
  })

  afterAll(() => {
    process.env = OLD_ENV
  })

  test('returns cache keys WITHOUT composer-options or dependency-versions', async () => {
    await expect(getCacheKeys()).resolves.toEqual({
      key: 'php-7.99.99-locked-foobar-',
      restoreKeys: [
        'php-7.99.99-locked-foobar-',
        'php-7.99.99-locked-'
      ]
    })
  })

  test('returns cache keys WITH composer-options and WITHOUT dependency-versions', async () => {
    process.env['INPUT_COMPOSER-OPTIONS'] = '--ignore-platform-reqs'

    await expect(getCacheKeys()).resolves.toEqual({
      key: 'php-7.99.99-locked-foobar---ignore-platform-reqs',
      restoreKeys: [
        'php-7.99.99-locked-foobar-',
        'php-7.99.99-locked-'
      ]
    })
  })

  test('returns cache keys WITHOUT composer-options and WITH dependency-versions', async () => {
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'lowest'

    await expect(getCacheKeys()).resolves.toEqual({
      key: 'php-7.99.99-lowest-foobar-',
      restoreKeys: [
        'php-7.99.99-lowest-foobar-',
        'php-7.99.99-lowest-'
      ]
    })
  })

  test('returns cache keys WITH composer-options and dependency-versions', async () => {
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'highest'
    process.env['INPUT_COMPOSER-OPTIONS'] = '--some-other-option --and-another'

    await expect(getCacheKeys()).resolves.toEqual({
      key: 'php-7.99.99-highest-foobar---some-other-option --and-another',
      restoreKeys: [
        'php-7.99.99-highest-foobar-',
        'php-7.99.99-highest-'
      ]
    })
  })
})
