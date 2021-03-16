import {getCacheKeys} from '../../src/utils'
import * as utils from '../../src/utils'

jest.mock('@actions/core')

jest.mock('../../src/utils/getPhpVersion', () => {
  return {
    getPhpVersion: jest.fn().mockReturnValue(Promise.resolve('7.99.99'))
  }
})

jest.mock('../../src/utils/getOperatingSystem', () => {
  return {
    getOperatingSystem: jest.fn().mockReturnValue('fooplatform')
  }
})

jest.mock('../../src/utils/hashFiles', () => {
  return {
    hashFiles: jest.fn().mockResolvedValue('foobar')
  }
})

describe('cache keys', () => {
  beforeEach(() => {
    jest.resetModules()
  })

  test('returns cache keys WITHOUT dependency-versions or composer-options or working-directory', async () => {
    await expect(getCacheKeys()).resolves.toEqual({
      key: 'fooplatform-php-7.99.99-locked-foobar-',
      restoreKeys: ['fooplatform-php-7.99.99-locked-foobar-', 'fooplatform-php-7.99.99-locked-']
    })
    expect(utils.hashFiles).toHaveBeenCalledWith('composer.json\ncomposer.lock');
  })

  test('returns cache keys WITH dependency-versions but WITHOUT composer-options and working-directory', async () => {
    await expect(getCacheKeys('lowest')).resolves.toEqual({
      key: 'fooplatform-php-7.99.99-lowest-foobar-',
      restoreKeys: ['fooplatform-php-7.99.99-lowest-foobar-', 'fooplatform-php-7.99.99-lowest-']
    })
    expect(utils.hashFiles).toHaveBeenCalledWith('composer.json\ncomposer.lock');
  })

  test('returns cache keys WITH dependency-versions and composer-options but WITHOUT working-directory', async () => {
    await expect(
      getCacheKeys('highest', '--some-other-option --and-another')
    ).resolves.toEqual({
      key: 'fooplatform-php-7.99.99-highest-foobar---some-other-option --and-another',
      restoreKeys: ['fooplatform-php-7.99.99-highest-foobar-', 'fooplatform-php-7.99.99-highest-']
    })
    expect(utils.hashFiles).toHaveBeenCalledWith('composer.json\ncomposer.lock');
  })

  test('returns cache keys WITH dependency-versions and composer-options and working-directory', async () => {
    await expect(
      getCacheKeys('highest', '--some-other-option --and-another', 'subdirectory')
    ).resolves.toEqual({
      key: 'fooplatform-php-7.99.99-highest-foobar---some-other-option --and-another',
      restoreKeys: ['fooplatform-php-7.99.99-highest-foobar-', 'fooplatform-php-7.99.99-highest-']
    })
    expect(utils.hashFiles).toHaveBeenCalledWith('subdirectory/composer.json\nsubdirectory/composer.lock');
  })
})
