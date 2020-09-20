import {exec} from '@actions/exec'
import {info} from '@actions/core'

export async function getComposerCacheDir(): Promise<string> {
  let composerCacheDir = ''
  const composerExecOptions = {
    silent: true,
    listeners: {
      stdout: (data: Buffer) => (composerCacheDir += data.toString())
    }
  }

  await exec('composer', ['config', 'cache-dir'], composerExecOptions)

  composerCacheDir = composerCacheDir.trim()
  info(`Composer cache directory found at ${composerCacheDir}`)

  return composerCacheDir
}
