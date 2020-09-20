import * as exec from '@actions/exec'
import {getComposerCacheDir} from '../../src/utils'

jest.mock('@actions/core')
jest.mock('@actions/exec')

describe('getComposerCacheDir with mocked exec', () => {
  test('executes command to get Composer cache directory', async () => {
    const execMock = jest.spyOn(exec, 'exec')

    await getComposerCacheDir()

    expect(execMock).toHaveBeenCalledTimes(1)
    expect(execMock).toHaveBeenCalledWith(
      'composer',
      ['config', 'cache-dir'],
      expect.objectContaining({
        silent: true,
        listeners: {
          stdout: expect.any(Function)
        }
      })
    )
  })
})
