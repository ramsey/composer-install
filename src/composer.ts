import {debug} from '@actions/core'
import {exec} from '@actions/exec'

export async function install(
  dependencyPreference: string,
  composerOptions: string = ''
): Promise<void> {
  const args: string[] = []
  const options: string[] = composerOptions.split(' ')

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

  args.push('--no-interaction', '--no-progress')
  args.push(...options)

  const filteredArgs = args.filter(Boolean)

  debug(`Composer command args = [${filteredArgs}]`)

  await exec('composer', filteredArgs, {silent: true})
}
