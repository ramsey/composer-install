import * as glob from '@actions/glob'
import * as stream from 'stream'
import * as util from 'util'
import * as path from 'path'
import {createHash} from 'crypto'
import {statSync, createReadStream} from 'fs'

export async function hashFiles(
  matchPatterns = '',
  followSymbolicLinks = false
): Promise<string> {
  let hasMatch = false
  const workspace = process.cwd()
  const result = createHash('sha256')

  const globber = await glob.create(matchPatterns, {followSymbolicLinks})

  for await (const file of globber.globGenerator()) {
    if (!file.startsWith(`${workspace}${path.sep}`)) {
      continue
    }

    if (statSync(file).isDirectory()) {
      continue
    }

    const hash = createHash('sha256')
    const pipeline = util.promisify(stream.pipeline)
    await pipeline(createReadStream(file), hash)

    result.write(hash.digest())

    if (!hasMatch) {
      hasMatch = true
    }
  }

  result.end()

  if (hasMatch) {
    return result.digest('hex')
  }

  return ''
}
