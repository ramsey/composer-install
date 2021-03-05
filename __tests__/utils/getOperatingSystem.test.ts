import {getOperatingSystem} from '../../src/utils'

jest.mock('@actions/core')

describe('getOperatingSystem using SUT', () => {
  test('returns the real operating system', () => {
    const localOperatingSystem = process.platform
    const operatingSystem = getOperatingSystem()

    expect(operatingSystem).toEqual(expect.stringMatching(/^aix|android|darwin|freebsd|linux|openbsd|sunos|win32|cygwin|netbsd$/))
    expect(operatingSystem).toEqual(localOperatingSystem)
  })
})
