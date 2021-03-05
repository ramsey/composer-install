import {hashFiles} from './hashFiles'
import {info} from '@actions/core'
import {getPhpVersion} from './getPhpVersion'

export async function getCacheKeys(
  dependencyVersions = 'locked',
  composerOptions = '',
  workingDirectory = ''
): Promise<{
  key: string
  restoreKeys: string[]
}> {
  const composerHash = await hashFiles('composer.json\ncomposer.lock')
  const phpVersion = await getPhpVersion()

  const keyWorkingDirectory = workingDirectory ? `-${workingDirectory}` : ''
  const keys = {
    key: `php-${phpVersion}${keyWorkingDirectory}-${dependencyVersions}-${composerHash}-${composerOptions}`,
    restoreKeys: [
      `php-${phpVersion}${keyWorkingDirectory}-${dependencyVersions}-${composerHash}-`,
      `php-${phpVersion}${keyWorkingDirectory}-${dependencyVersions}-`
    ]
  }

  info(`Cache primary key is ${keys.key}`)
  info(`Cache restore keys are: ${keys.restoreKeys.join(', ')}`)

  return keys
}
