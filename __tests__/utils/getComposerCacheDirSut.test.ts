import * as exec from '@actions/exec'
import { getComposerCacheDir } from "../../src/utils/getComposerCacheDir";

describe('getComposerCacheDir using SUT', () => {
  test('returns the real Composer cache directory', async () => {
    let localComposerCacheDir = ''

    const composerExecOptions = {
      silent: true,
      listeners: {
        stdout: (data: Buffer) => (localComposerCacheDir += data.toString())
      }
    }

    await exec.exec(
      'composer',
      ['config', 'cache-files-dir'],
      composerExecOptions
    )

    expect(await getComposerCacheDir()).toEqual(localComposerCacheDir.trim())
  })
})
