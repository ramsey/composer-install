import {info} from '@actions/core'

export function getDependencyVersions(
  dependencyVersions?: string | undefined
): string {
  let versionsDetermined = 'locked'

  if (dependencyVersions === undefined) {
    return versionsDetermined
  }

  switch (dependencyVersions.toLowerCase()) {
    case 'highest':
    case 'lowest':
    case 'locked':
      versionsDetermined = dependencyVersions.toLowerCase()
  }

  info(`Using ${versionsDetermined} versions of dependencies`)

  return versionsDetermined
}
