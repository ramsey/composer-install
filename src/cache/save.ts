/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable @typescript-eslint/no-require-imports */
const saveCache = require('cache/dist/save')

export async function save(
  paths: string[],
  key: string,
  restoreKeys: string[]
): Promise<void> {
  process.env['INPUT_PATH'] = paths.join(`\n`)
  process.env['INPUT_KEY'] = key
  process.env['INPUT_RESTORE-KEYS'] = restoreKeys.join(`\n`)

  await saveCache.run()
}
