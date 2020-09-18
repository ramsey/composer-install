import {debug, setFailed} from '@actions/core'
import {saveCache} from '@actions/cache'
import {getCacheKeys} from './utils/getCacheKeys'
import {getComposerCacheDir} from './utils/getComposerCacheDir'

async function run(): Promise<void> {
  try {
    const composerCacheKeys = await getCacheKeys()
    const composerCacheDir = await getComposerCacheDir()

    debug(`composerCacheKeys.key = ${composerCacheKeys.key}`)
    debug(`composerCacheDir = ${composerCacheDir}`)

    const cacheId = await saveCache([composerCacheDir], composerCacheKeys.key)

    debug(`cacheId = ${cacheId}`)
  } catch (error) {
    setFailed(error.message)
  }
}

run()

export default run
