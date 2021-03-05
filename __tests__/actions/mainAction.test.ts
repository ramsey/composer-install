import * as cache from '../../src/cache'
import * as composer from '../../src/composer'
import {mainAction} from '../../src/actions'

jest.mock('../../src/cache', () => {
  return {
    cache: jest.fn(),
    restoreFactory: jest.fn().mockReturnValue(jest.fn())
  }
})

jest.mock('../../src/composer', () => {
  return {
    install: jest.fn()
  }
})

jest.mock('../../src/utils/getCacheKeys', () => {
  return {
    getCacheKeys: jest.fn().mockResolvedValue({
      key: 'cache-key-mock',
      restoreKeys: ['cache-key-', 'cache-']
    })
  }
})

jest.mock('../../src/utils/getComposerCacheDir', () => {
  return {
    getComposerCacheDir: jest.fn().mockResolvedValue('/path/to/composer/cache')
  }
})

describe('main action', () => {
  const OLD_ENV = process.env

  beforeEach(() => {
    jest.resetModules()
    process.env = {...OLD_ENV}
  })

  afterAll(() => {
    process.env = OLD_ENV
  })

  test('runs', async () => {
    const cacheMock = jest.spyOn(cache, 'cache')
    const composerInstallMock = jest.spyOn(composer, 'install')
    const mockFactory = cache.restoreFactory()

    process.env['INPUT_COMPOSER-OPTIONS'] = '--ignore-platform-reqs'
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'lowest'

    await mainAction()

    expect(cacheMock).toHaveBeenCalledTimes(1)
    expect(cacheMock).toHaveBeenCalledWith(
      mockFactory,
      ['/path/to/composer/cache'],
      'cache-key-mock',
      ['cache-key-', 'cache-']
    )

    expect(composerInstallMock).toHaveBeenCalledTimes(1)
    expect(composerInstallMock).toHaveBeenCalledWith(
      'lowest',
      '--ignore-platform-reqs',
      ''
    )
  })


  test('runs with a different working directory', async () => {
    const cacheMock = jest.spyOn(cache, 'cache')
    const composerInstallMock = jest.spyOn(composer, 'install')
    const mockFactory = cache.restoreFactory()

    process.env['INPUT_COMPOSER-OPTIONS'] = '--ignore-platform-reqs'
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'lowest'
    process.env['INPUT_WORKING-DIRECTORY'] = 'subdirectory'

    await mainAction()

    expect(cacheMock).toHaveBeenCalledTimes(1)
    expect(cacheMock).toHaveBeenCalledWith(
      mockFactory,
      ['/path/to/composer/cache'],
      'cache-key-mock',
      ['cache-key-', 'cache-']
    )

    expect(composerInstallMock).toHaveBeenCalledTimes(1)
    expect(composerInstallMock).toHaveBeenCalledWith(
      'lowest',
      '--ignore-platform-reqs',
      'subdirectory'
    )
  })

  test('sets failure state with error', async () => {
    const cacheMock = jest.spyOn(cache, 'cache').mockRejectedValue({
      message: 'a mocked error message'
    })
    const composerInstallMock = jest.spyOn(composer, 'install')

    await mainAction()

    expect(cacheMock).toHaveBeenCalledTimes(1)
    expect(composerInstallMock).not.toHaveBeenCalled()
  })
})
