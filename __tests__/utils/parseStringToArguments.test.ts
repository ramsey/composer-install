import {parseStringToArguments} from '../../src/utils'

describe('parseStringToArguments', () => {
  test('empty args', () => {
    expect(parseStringToArguments('')).toEqual({
      _: []
    })
  })

  test('only positional argument', () => {
    expect(parseStringToArguments('test')).toEqual({
      _: ['test']
    })
  })

  test('positional argument with lot of options', () => {
    expect(
      parseStringToArguments(
        '--no-plugins --profile --working-dir subdirectory test'
      )
    ).toEqual({
      _: ['test'],
      plugins: false,
      profile: true,
      'working-dir': 'subdirectory'
    })
  })
})
