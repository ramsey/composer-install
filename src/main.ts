import * as cache from './cache'
import * as composer from './composer'
import * as utils from './utils'
import {getInput, setFailed} from '@actions/core'

async function run(): Promise<void> {
  try {
    const composerCacheKeys = await utils.getCacheKeys()
    const composerCacheDir = await utils.getComposerCacheDir()
    const composerOptions = getInput('composer-options')
    const dependencyVersions = utils.getDependencyVersions()

    await cache
      .cache(
        cache.restoreFactory(),
        [composerCacheDir],
        composerCacheKeys.key,
        composerCacheKeys.restoreKeys
      )
      .then(async () => {
        await composer.install(dependencyVersions, composerOptions)
      })
  } catch (error) {
    setFailed(error.message)
  }
}

run()

export default run
