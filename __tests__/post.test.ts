import * as cache from '../src/cache'
import post from '../src/post'

jest.mock('@actions/cache')

jest.mock('../src/cache', () => {
  return {
    save: jest.fn()
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

describe('post script', () => {
  const OLD_ENV = process.env

  beforeEach(() => {
    jest.resetModules()
    process.env = {...OLD_ENV}
  })

  afterAll(() => {
    process.env = OLD_ENV
  })

  test('runs', async () => {
    const saveCacheMock = jest.spyOn(cache, 'save')

    process.env['INPUT_COMPOSER-OPTIONS'] = ''
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'locked'

    await post()

    expect(saveCacheMock).toHaveBeenCalledTimes(1)
    expect(saveCacheMock).toHaveBeenCalledWith(
      ['/path/to/composer/cache'],
      'cache-key-mock',
      ['cache-key-', 'cache-']
    )
  })

  test('sets failure state with error', async () => {
    const saveCacheMock = jest.spyOn(cache, 'save').mockRejectedValue({
      message: 'a mocked error message'
    })

    await post()

    expect(saveCacheMock).toHaveBeenCalledTimes(1)
  })
})
