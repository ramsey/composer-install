export async function restore(
  factory: (
    p: string[],
    k: string,
    rK: string[]
  ) => Promise<string | undefined>,
  paths: string[],
  key: string,
  restoreKeys: string[]
): Promise<void> {
  await factory(paths, key, restoreKeys)
}

export async function save(
  factory: (p: string[], k: string) => Promise<number>,
  paths: string[],
  key: string
): Promise<void> {
  await factory(paths, key)
}
