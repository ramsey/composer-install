import {exec} from '@actions/exec'
import {info} from '@actions/core'

export async function getComposerCacheDir(workingDir = ''): Promise<string> {
  let composerCacheDir = ''
  const composerExecOptions = {
    silent: true,
    listeners: {
      stdout: (data: Buffer) => (composerCacheDir += data.toString())
    }
  }

  const args = ['config', 'cache-dir']
  if (workingDir !== '') args.push(`--working-dir=${workingDir}`)

  await exec('composer', args, composerExecOptions)

  composerCacheDir = composerCacheDir.trim()
  info(`Composer cache directory found at ${composerCacheDir}`)

  return composerCacheDir
}
