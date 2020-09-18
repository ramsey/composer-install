import * as exec from '@actions/exec'
import { getPhpVersion } from "../../src/utils/getPhpVersion";

jest.mock('@actions/exec')

describe('getPhpVersion with mocked exec', () => {
  test('executes command to get PHP version', async () => {
    const execMock = jest.spyOn(exec, 'exec')

    await getPhpVersion()

    expect(execMock).toHaveBeenCalledTimes(1)
    expect(execMock).toHaveBeenCalledWith(
      'php',
      ['-r', 'echo phpversion();'],
      expect.objectContaining({
        silent: true,
        listeners: {
          stdout: expect.any(Function)
        }
      })
    )
  })
})
