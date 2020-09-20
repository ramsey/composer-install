import * as fs from 'fs'
import * as os from 'os'
import * as path from 'path'
import {hashFiles} from '../../src/utils'

jest.mock('@actions/core')

describe('hashing files for cache identification', () => {
  const sep = path.sep
  const testsDir = '__tests__'
  const tmpDir = os.tmpdir()
  const expectedSingleFileHash =
    '5df6e0e2761359d30a8275058e299fcc0381534545f55cf43e41983f5d4c9456'
  const expectedMultiFileHash =
    '1a03c02fb531d7e1ce353b2f20711c79af2b66730d6de865fb130734973ccd2c'

  // We use this temporary directory to assert that hashFiles() does not
  // include matches outside of the workspace.
  let createdTmpDir = ''
  fs.mkdtemp(`${tmpDir}${sep}`, (err, directory) => {
    if (err) throw err
    createdTmpDir = directory
    // Write a file to the temporary directory that would match the pattern, if
    // we allow matches outside of the workspace.
    fs.writeFile(
      `${createdTmpDir}${sep}mockFile4.txt`,
      'created from test',
      cbErr => {
        if (cbErr) throw cbErr
      }
    )
  })

  test('returns empty string when no patterns provided', async () => {
    await expect(hashFiles()).resolves.toEqual('')
  })

  test('returns empty string when no matching patterns', async () => {
    const patterns = `
      ${testsDir}/foo/
      ${testsDir}/bar/
    `
    await expect(hashFiles(patterns)).resolves.toEqual('')
  })

  test('returns hash of a single file', async () => {
    const patterns = `
      ${testsDir}/mocks/mockFile2.txt
    `
    await expect(hashFiles(patterns)).resolves.toEqual(expectedSingleFileHash)
  })

  test('returns hash of files', async () => {
    const patterns = `
      ${testsDir}/mocks/**/*.txt
      ${testsDir}/foo/
      ${testsDir}/bar/
    `
    await expect(hashFiles(patterns)).resolves.toEqual(expectedMultiFileHash)
  })

  test('returns same hash of files when directories included in matches', async () => {
    const patterns = `
      ${testsDir}/mocks/**/
      ${testsDir}/bar/
      ${createdTmpDir}
    `
    await expect(hashFiles(patterns)).resolves.toEqual(expectedMultiFileHash)
  })
})
