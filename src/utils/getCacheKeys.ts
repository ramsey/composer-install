import {hashFiles} from './hashFiles'
import {info} from '@actions/core'
import {getPhpVersion} from './getPhpVersion'

export async function getCacheKeys(
  dependencyVersions = 'locked',
  composerOptions = ''
): Promise<{
  key: string
  restoreKeys: string[]
}> {
  const composerHash = await hashFiles('composer.json\ncomposer.lock')
  const phpVersion = await getPhpVersion()

  const keys = {
    key: `php-${phpVersion}-${dependencyVersions}-${composerHash}-${composerOptions}`,
    restoreKeys: [
      `php-${phpVersion}-${dependencyVersions}-${composerHash}-`,
      `php-${phpVersion}-${dependencyVersions}-`
    ]
  }

  info(`Cache primary key is ${keys.key}`)
  info(`Cache restore keys are: ${keys.restoreKeys.join(', ')}`)

  return keys
}
