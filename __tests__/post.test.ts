import * as process from 'process'
import * as post from '../src/post'
import * as cache from '@actions/cache'
import * as core from '@actions/core'

jest.mock('@actions/cache')
jest.mock('@actions/core')

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

describe('post script', () => {
  beforeEach(() => {
    jest.resetModules()
  })

  test('runs', async () => {
    const saveCacheMock = jest.spyOn(cache, 'saveCache').mockResolvedValue(1234)

    process.env['INPUT_COMPOSER-OPTIONS'] = ''
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'locked'

    await post.default()

    expect(saveCacheMock).toHaveBeenCalledTimes(1)
    expect(saveCacheMock).toHaveBeenCalledWith(
      ['/path/to/composer/cache'],
      'cache-key-mock'
    )
  })

  test('sets failure state with error', async () => {
    const setFailed = jest.spyOn(core, 'setFailed')
    const saveCacheMock = jest.spyOn(cache, 'saveCache').mockRejectedValue({
      message: 'a mocked error message'
    })

    await post.default()

    expect(saveCacheMock).toHaveBeenCalledTimes(1)
    expect(setFailed).toHaveBeenCalledTimes(1)
    expect(setFailed).toHaveBeenCalledWith('a mocked error message')
  })
})
