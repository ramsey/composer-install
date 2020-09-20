import {getDependencyVersions} from '../../src/utils'

jest.mock('@actions/core')

describe('dependency versions', () => {
  test('with "HIGHEST" as input', () => {
    expect(getDependencyVersions('HIGHEST')).toEqual('highest')
  })

  test('with "highest" as input', () => {
    expect(getDependencyVersions('highest')).toEqual('highest')
  })

  test('with "LOWEST" as input', () => {
    expect(getDependencyVersions('LOWEST')).toEqual('lowest')
  })

  test('with "lowest" as input', () => {
    expect(getDependencyVersions('lowest')).toEqual('lowest')
  })

  test('with "LOCKED" as input', () => {
    expect(getDependencyVersions('locked')).toEqual('locked')
  })

  test('with "locked" as input', () => {
    expect(getDependencyVersions('locked')).toEqual('locked')
  })

  test('with "foobar" as input', () => {
    expect(getDependencyVersions('foobar')).toEqual('locked')
  })

  test('with nothing (undefined) as input', () => {
    expect(getDependencyVersions()).toEqual('locked')
  })
})
