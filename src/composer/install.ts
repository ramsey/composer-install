import {exec} from '@actions/exec'

export async function install(
  dependencyPreference: string,
  composerOptions = ''
): Promise<void> {
  const args: string[] = []

  switch (dependencyPreference) {
    case 'highest':
      args.push('update')
      break
    case 'lowest':
      args.push('update', '--prefer-lowest')
      break
    case 'locked':
    default:
      args.push('install')
  }

  args.push('--no-interaction', '--no-progress', '--ansi')

  await exec(`composer ${args.join(' ')} ${composerOptions}`.trim())
}
