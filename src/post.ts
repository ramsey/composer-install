import * as core from '@actions/core'
import * as cache from '@actions/cache'
import {getComposerCacheDir} from './utils/getComposerCacheDir'

async function run(): Promise<void> {
  try {
    const state = core.getState('CACHE_RESULT') || undefined
    const primaryKey = core.getState('CACHE_KEY')

    if (!primaryKey) {
      core.info(`[warning] Error retrieving key from state.`)
      return
    }

    if (primaryKey === state) {
      core.info(
        `Cache hit occurred on the primary key ${primaryKey}, not saving cache.`
      )
      return
    }

    const composerCacheDir = await getComposerCacheDir()

    try {
      await cache.saveCache([composerCacheDir], primaryKey)
    } catch (error) {
      if (error.name === cache.ValidationError.name) {
        throw error
      } else if (error.name === cache.ReserveCacheError.name) {
        core.info(error.message)
      } else {
        core.info(`[warning] ${error.message}`)
      }
    }
  } catch (error) {
    core.info(`[warning] ${error.message}`)
  }
}

run()

export default run
