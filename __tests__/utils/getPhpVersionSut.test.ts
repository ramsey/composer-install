import * as exec from '@actions/exec'
import { getPhpVersion } from "../../src/utils/getPhpVersion";

describe('getPhpVersion using SUT', () => {
  test('returns the real PHP version', async () => {
    let localPhpVersion = ''

    const phpExecOptions = {
      silent: true,
      listeners: {
        stdout: (data: Buffer) => (localPhpVersion += data.toString())
      }
    }

    await exec.exec(
      'php',
      ['-r', 'echo phpversion();'],
      phpExecOptions
    )

    const phpVersion = await getPhpVersion();

    expect(phpVersion).toEqual(expect.stringMatching(/^\d+\.\d+\.\d+$/))
    expect(phpVersion).toEqual(localPhpVersion.trim())
  })
})
