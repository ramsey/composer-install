import * as core from '@actions/core'
import * as cache from '@actions/cache'
import {getCacheKeys} from './utils/getCacheKeys'
import {getComposerCacheDir} from './utils/getComposerCacheDir'
import {getDependencyVersions} from './utils/getDependencyVersions'
import * as composer from './composer'

async function run(): Promise<void> {
  try {
    const composerCacheKeys = await getCacheKeys()
    const composerCacheDir = await getComposerCacheDir()
    const composerOptions = core.getInput('composer-options')
    const dependencyVersions = getDependencyVersions()

    core.saveState('CACHE_KEY', composerCacheKeys.key)

    try {
      const cacheKey = await cache.restoreCache(
        [composerCacheDir],
        composerCacheKeys.key,
        composerCacheKeys.restoreKeys
      )

      if (!cacheKey) {
        core.info(
          `Cache not found for input keys: ${[
            composerCacheKeys.key,
            ...composerCacheKeys.restoreKeys
          ].join(', ')}`
        )
      } else {
        core.saveState('CACHE_RESULT', cacheKey)
        core.info(`Cache restored from key: ${cacheKey}`)

        if (composerCacheKeys.key === cacheKey) {
          core.setOutput('cache-hit', 'true')
        } else {
          core.setOutput('cache-hit', 'false')
        }
      }
    } catch (error) {
      if (error.name === cache.ValidationError.name) {
        throw error
      } else {
        core.info(`[warning] ${error.message}`)
        core.setOutput('cache-hit', 'false')
      }
    }

    await composer.install(dependencyVersions, composerOptions)
  } catch (error) {
    core.setFailed(error.message)
  }
}

run()

export default run
