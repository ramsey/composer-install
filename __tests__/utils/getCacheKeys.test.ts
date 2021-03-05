import {getCacheKeys} from '../../src/utils'

jest.mock('@actions/core')

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
  beforeEach(() => {
    jest.resetModules()
  })

  test('returns cache keys WITHOUT dependency-versions or composer-options or working-directory', async () => {
    await expect(getCacheKeys()).resolves.toEqual({
      key: 'php-7.99.99-locked-foobar-',
      restoreKeys: ['php-7.99.99-locked-foobar-', 'php-7.99.99-locked-']
    })
  })

  test('returns cache keys WITH dependency-versions but WITHOUT composer-options and working-directory', async () => {
    await expect(getCacheKeys('lowest')).resolves.toEqual({
      key: 'php-7.99.99-lowest-foobar-',
      restoreKeys: ['php-7.99.99-lowest-foobar-', 'php-7.99.99-lowest-']
    })
  })

  test('returns cache keys WITH dependency-versions and composer-options but WITHOUT working-directory', async () => {
    await expect(
      getCacheKeys('highest', '--some-other-option --and-another')
    ).resolves.toEqual({
      key: 'php-7.99.99-highest-foobar---some-other-option --and-another',
      restoreKeys: ['php-7.99.99-highest-foobar-', 'php-7.99.99-highest-']
    })
  })

  test('returns cache keys WITH dependency-versions and composer-options and working-directory', async () => {
    await expect(
      getCacheKeys('highest', '--some-other-option --and-another', 'subdirectory')
    ).resolves.toEqual({
      key: 'php-7.99.99-subdirectory-highest-foobar---some-other-option --and-another',
      restoreKeys: ['php-7.99.99-subdirectory-highest-foobar-', 'php-7.99.99-subdirectory-highest-']
    })
  })
})
