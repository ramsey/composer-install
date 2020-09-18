import {exec} from '@actions/exec'

export async function getPhpVersion(): Promise<string> {
  let phpVersion = ''
  const phpExecOptions = {
    silent: true,
    listeners: {
      stdout: (data: Buffer) => (phpVersion += data.toString())
    }
  }

  await exec('php', ['-r', 'echo phpversion();'], phpExecOptions)

  return phpVersion
}
