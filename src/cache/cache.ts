export async function cache(
  factory: Function,
  paths: string[],
  key: string,
  restoreKeys: string[]
): Promise<void> {
  process.env['INPUT_PATH'] = paths.join(`\n`)
  process.env['INPUT_KEY'] = key
  process.env['INPUT_RESTORE-KEYS'] = restoreKeys.join(`\n`)

  await factory()
}
