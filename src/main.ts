import {debug, getInput, setFailed} from '@actions/core'
import {restoreCache} from '@actions/cache'
import {getCacheKeys} from './utils/getCacheKeys'
import {getComposerCacheDir} from './utils/getComposerCacheDir'
import {getDependencyVersions} from './utils/getDependencyVersions'
import * as composer from './composer'

async function run(): Promise<void> {
  try {
    const composerCacheKeys = await getCacheKeys()
    const composerCacheDir = await getComposerCacheDir()
    const composerOptions = getInput('composer-options')
    const dependencyVersions = getDependencyVersions()

    debug(`composerCacheKeys.key = ${composerCacheKeys.key}`)
    debug(`composerCacheKeys.restoreKeys = [${composerCacheKeys.restoreKeys}]`)
    debug(`composerCacheDir = ${composerCacheDir}`)
    debug(`composerOptions = ${composerOptions}`)
    debug(`dependencyVersions = ${dependencyVersions}`)

    const cacheKey = await restoreCache(
      [composerCacheDir],
      composerCacheKeys.key,
      composerCacheKeys.restoreKeys
    )

    debug(`cacheKey = ${cacheKey}`)

    await composer.install(dependencyVersions, composerOptions)
  } catch (error) {
    setFailed(error.message)
  }
}

run()

export default run
