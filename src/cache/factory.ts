import {restoreCache, saveCache} from '@actions/cache'

/* istanbul ignore next */
export function restoreFactory(): (
  paths: string[],
  primaryKey: string,
  restoreKeys: string[]
) => Promise<string | undefined> {
  return restoreCache
}

/* istanbul ignore next */
export function saveFactory(): (
  paths: string[],
  key: string
) => Promise<number> {
  return saveCache
}
