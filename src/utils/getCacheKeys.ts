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
  const composerHash = await hashFiles(
    [
      `${workingDirectory ? `${workingDirectory}/` : ''}composer.json`,
      `${workingDirectory ? `${workingDirectory}/` : ''}composer.lock`
    ].join('\n')
  )
  const phpVersion = await getPhpVersion()
  const keyOs = getOperatingSystem()

  const keys = {
    key: `${keyOs}-php-${phpVersion}-${dependencyVersions}-${composerHash}-${composerOptions}`,
    restoreKeys: [
      `${keyOs}-php-${phpVersion}-${dependencyVersions}-${composerHash}-`,
      `${keyOs}-php-${phpVersion}-${dependencyVersions}-`
    ]
  }

  info(`Cache primary key is ${keys.key}`)
  info(`Cache restore keys are: ${keys.restoreKeys.join(', ')}`)

  return keys
}
