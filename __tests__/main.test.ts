import * as process from 'process'
import * as main from '../src/main'
import * as cache from '@actions/cache'
import * as composer from '../src/composer'

jest.mock('@actions/cache')
jest.mock('../src/composer')

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
  beforeEach(() => {
    jest.resetModules()
  })

  test('runs', async () => {
    const restoreCacheMock = jest
      .spyOn(cache, 'restoreCache')
      .mockResolvedValue('fooCacheKey')
    const composerInstallMock = jest.spyOn(composer, 'install')

    process.env['INPUT_COMPOSER-OPTIONS'] = '--ignore-platform-reqs'
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'lowest'

    await main.default()

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
    const restoreCacheMock = jest
      .spyOn(cache, 'restoreCache')
      .mockRejectedValue({
        message: 'a mocked error message'
      })
    const composerInstallMock = jest
      .spyOn(composer, 'install')
      .mockRejectedValue({
        message: 'another mocked error message'
      })

    await main.default()

    expect(restoreCacheMock).toHaveBeenCalledTimes(1)
    expect(composerInstallMock).toHaveBeenCalledTimes(1)
  })
})
