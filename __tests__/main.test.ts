import * as cache from '../src/cache'
import * as composer from '../src/composer'
import main from '../src/main'

jest.mock('../src/cache', () => {
  return {
    restore: jest.fn()
  }
})

jest.mock('../src/composer', () => {
  return {
    install: jest.fn()
  }
})

jest.mock('../src/utils/getCacheKeys', () => {
  return {
    getCacheKeys: jest.fn().mockResolvedValue({
      key: 'cache-key-mock',
      restoreKeys: ['cache-key-', 'cache-']
    })
  }
})

jest.mock('../src/utils/getComposerCacheDir', () => {
  return {
    getComposerCacheDir: jest.fn().mockResolvedValue('/path/to/composer/cache')
  }
})

describe('main script', () => {
  const OLD_ENV = process.env

  beforeEach(() => {
    jest.resetModules()
    process.env = {...OLD_ENV}
  })

  afterAll(() => {
    process.env = OLD_ENV
  })

  test('runs', async () => {
    const restoreCacheMock = jest.spyOn(cache, 'restore')
    const composerInstallMock = jest.spyOn(composer, 'install')

    process.env['INPUT_COMPOSER-OPTIONS'] = '--ignore-platform-reqs'
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'lowest'

    await main()

    expect(restoreCacheMock).toHaveBeenCalledTimes(1)
    expect(restoreCacheMock).toHaveBeenCalledWith(
      ['/path/to/composer/cache'],
      'cache-key-mock',
      ['cache-key-', 'cache-']
    )

    expect(composerInstallMock).toHaveBeenCalledTimes(1)
    expect(composerInstallMock).toHaveBeenCalledWith(
      'lowest',
      '--ignore-platform-reqs'
    )
  })

  test('sets failure state with error', async () => {
    const restoreCacheMock = jest.spyOn(cache, 'restore').mockRejectedValue({
      message: 'a mocked error message'
    })
    const composerInstallMock = jest.spyOn(composer, 'install')

    await main()

    expect(restoreCacheMock).toHaveBeenCalledTimes(1)
    expect(composerInstallMock).not.toHaveBeenCalled()
  })
})
