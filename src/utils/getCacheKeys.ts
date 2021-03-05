import {hashFiles} from './hashFiles'
import {info} from '@actions/core'
import {getOperatingSystem} from './getOperatingSystem'
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
  const keyOs = getOperatingSystem()
  const keyWorkingDirectory = workingDirectory ? `-${workingDirectory}` : ''

  const keys = {
    key: `${keyOs}-php-${phpVersion}${keyWorkingDirectory}-${dependencyVersions}-${composerHash}-${composerOptions}`,
    restoreKeys: [
      `${keyOs}-php-${phpVersion}${keyWorkingDirectory}-${dependencyVersions}-${composerHash}-`,
      `${keyOs}-php-${phpVersion}${keyWorkingDirectory}-${dependencyVersions}-`
    ]
  }

  info(`Cache primary key is ${keys.key}`)
  info(`Cache restore keys are: ${keys.restoreKeys.join(', ')}`)

  return keys
}
