import {getInput} from '@actions/core'

export function getDependencyVersions(): string {
  const dependencyVersions = getInput('dependency-versions')

  switch (dependencyVersions.toLowerCase()) {
    case 'highest':
    case 'lowest':
    case 'locked':
      return dependencyVersions.toLowerCase()
    default:
      return 'locked'
  }
}
