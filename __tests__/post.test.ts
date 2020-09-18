import * as process from 'process'
import * as post from '../src/post'
import * as cache from '@actions/cache'
import * as core from '@actions/core'

jest.mock('@actions/cache')
jest.mock('@actions/core')

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
    const saveCacheMock = jest.spyOn(cache, 'saveCache')
    const getState = jest.spyOn(core, 'getState')

    getState.mockReturnValueOnce('cache-state')
    getState.mockReturnValueOnce('primary-cache-key')

    process.env['INPUT_COMPOSER-OPTIONS'] = ''
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'locked'

    await post.default()

    expect(saveCacheMock).toHaveBeenCalledTimes(1)
    expect(saveCacheMock).toHaveBeenCalledWith(
      ['/path/to/composer/cache'],
      'primary-cache-key'
    )
  })

  test('sets failure state with error', async () => {
    const info = jest.spyOn(core, 'info')
    const getState = jest.spyOn(core, 'getState')
    const saveCacheMock = jest.spyOn(cache, 'saveCache').mockRejectedValue({
      message: 'a mocked error message'
    })

    getState.mockReturnValueOnce('cache-state')
    getState.mockReturnValueOnce('primary-cache-key')

    await post.default()

    expect(saveCacheMock).toHaveBeenCalledTimes(1)
    expect(info).toHaveBeenCalledTimes(1)
    expect(info).toHaveBeenCalledWith('[warning] a mocked error message')
  })
})
