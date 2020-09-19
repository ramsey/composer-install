import * as cache from './cache'
import * as utils from './utils'
import {info} from '@actions/core'

async function run(): Promise<void> {
  try {
    const composerCacheKeys = await utils.getCacheKeys()
    const composerCacheDir = await utils.getComposerCacheDir()

    await cache.save(
      [composerCacheDir],
      composerCacheKeys.key,
      composerCacheKeys.restoreKeys
    )
  } catch (error) {
    info(`[warning] ${error.message}`)
  }
}

run()

export default run
