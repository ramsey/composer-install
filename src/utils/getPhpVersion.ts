import {exec} from '@actions/exec'
import {info} from '@actions/core'

export async function getPhpVersion(): Promise<string> {
  let phpVersion = ''
  const phpExecOptions = {
    silent: true,
    listeners: {
      stdout: (data: Buffer) => (phpVersion += data.toString())
    }
  }

  await exec('php', ['-r', 'echo phpversion();'], phpExecOptions)

  phpVersion = phpVersion.trim()
  info(`PHP version is ${phpVersion}`)

  return phpVersion
}
