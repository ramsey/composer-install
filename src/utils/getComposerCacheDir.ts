import {exec} from '@actions/exec'

export async function getComposerCacheDir(): Promise<string> {
  let composerCacheDir = ''
  const composerExecOptions = {
    silent: true,
    listeners: {
      stdout: (data: Buffer) => (composerCacheDir += data.toString())
    }
  }

  await exec('composer', ['config', 'cache-files-dir'], composerExecOptions)

  return composerCacheDir.trim()
}
