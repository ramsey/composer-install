import { getDependencyVersions } from "../../src/utils/getDependencyVersions";

describe('dependency versions', () => {
  const OLD_ENV =  process.env

  beforeEach(() => {
    process.env = { ...OLD_ENV }
  })

  afterAll(() => {
    process.env = OLD_ENV
  })

  test('with "HIGHEST" as input', () => {
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'HIGHEST'
    expect(getDependencyVersions()).toEqual('highest')
  })

  test('with "highest" as input', () => {
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'highest'
    expect(getDependencyVersions()).toEqual('highest')
  })

  test('with "LOWEST" as input', () => {
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'LOWEST'
    expect(getDependencyVersions()).toEqual('lowest')
  })

  test('with "lowest" as input', () => {
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'lowest'
    expect(getDependencyVersions()).toEqual('lowest')
  })

  test('with "LOCKED" as input', () => {
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'LOCKED'
    expect(getDependencyVersions()).toEqual('locked')
  })

  test('with "locked" as input', () => {
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'locked'
    expect(getDependencyVersions()).toEqual('locked')
  })

  test('with "foobar" as input', () => {
    process.env['INPUT_DEPENDENCY-VERSIONS'] = 'foobar'
    expect(getDependencyVersions()).toEqual('locked')
  })

  test('with nothing (undefined) as input', () => {
    expect(getDependencyVersions()).toEqual('locked')
  })
})
