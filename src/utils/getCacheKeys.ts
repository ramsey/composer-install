import {hashFiles} from './hashFiles'
import {getInput} from '@actions/core'
import {getDependencyVersions} from './getDependencyVersions'
import {getPhpVersion} from './getPhpVersion'

export async function getCacheKeys(): Promise<{
  key: string
  restoreKeys: string[]
}> {
  const composerHash = await hashFiles('composer.json\ncomposer.lock')
  const composerOptions = getInput('composer-options')
  const dependencyVersions = getDependencyVersions()
  const phpVersion = await getPhpVersion()

  return {
    key: `php-${phpVersion}-${dependencyVersions}-${composerHash}-${composerOptions}`,
    restoreKeys: [
      `php-${phpVersion}-${dependencyVersions}-${composerHash}-`,
      `php-${phpVersion}-${dependencyVersions}-`
    ]
  }
}
