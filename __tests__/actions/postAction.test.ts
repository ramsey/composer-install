import * as cache from '../../src/cache'
import {postAction} from '../../src/actions'

jest.mock('../../src/cache', () => {
  return {
    cache: jest.fn(),
    saveFactory: jest.fn().mockReturnValue(jest.fn())
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

describe('post action', () => {
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
    const mockFactory = cache.saveFactory()

    process.env['INPUT_COMPOSER-OPTIONS'] = ''
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'highest'

    await postAction()

    expect(cacheMock).toHaveBeenCalledTimes(1)
    expect(cacheMock).toHaveBeenCalledWith(
      mockFactory,
      ['/path/to/composer/cache'],
      'cache-key-mock',
      ['cache-key-', 'cache-']
    )
  })

  test('runs with a custom working-directory', async () => {
    const cacheMock = jest.spyOn(cache, 'cache')
    const mockFactory = cache.saveFactory()

    process.env['INPUT_COMPOSER-OPTIONS'] = ''
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'highest'
    process.env['INPUT_WORKING-DIRECTORY'] = 'subdirectory'

    await postAction()

    expect(cacheMock).toHaveBeenCalledTimes(1)
    expect(cacheMock).toHaveBeenCalledWith(
      mockFactory,
      ['/path/to/composer/cache'],
      'cache-key-mock',
      ['cache-key-', 'cache-']
    )
  })

  test('sets failure state with error', async () => {
    const cacheMock = jest.spyOn(cache, 'cache').mockRejectedValue({
      message: 'a mocked error message'
    })

    await postAction()

    expect(cacheMock).toHaveBeenCalledTimes(1)
  })
})
