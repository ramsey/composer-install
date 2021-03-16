import * as exec from '@actions/exec'
import * as composer from '../../src/composer'

jest.mock('@actions/exec')

describe('composer.install with mocked exec', () => {
  beforeEach(() => {
    jest.resetModules()
  })

  test('executes command to install composer with locked dependencies', async () => {
    const execMock = jest.spyOn(exec, 'exec')

    await composer.install('locked')

    expect(execMock).toHaveBeenCalledTimes(1)
    expect(execMock).toHaveBeenCalledWith('composer install --no-interaction --no-progress --ansi')
  })

  test('executes command to install composer with highest dependencies', async () => {
    const execMock = jest.spyOn(exec, 'exec')

    await composer.install('highest')

    expect(execMock).toHaveBeenCalledTimes(1)
    expect(execMock).toHaveBeenCalledWith('composer update --no-interaction --no-progress --ansi')
  })

  test('executes command to install composer with lowest dependencies', async () => {
    const execMock = jest.spyOn(exec, 'exec')

    await composer.install('lowest')

    expect(execMock).toHaveBeenCalledTimes(1)
    expect(execMock).toHaveBeenCalledWith('composer update --prefer-lowest --no-interaction --no-progress --ansi')
  })

  test('executes command to install composer with locked dependencies when provided invalid dependencyPreference', async () => {
    const execMock = jest.spyOn(exec, 'exec')

    await composer.install('foobar')

    expect(execMock).toHaveBeenCalledTimes(1)
    expect(execMock).toHaveBeenCalledWith('composer install --no-interaction --no-progress --ansi')
  })

  test('executes command to install composer with locked dependencies and options', async () => {
    const execMock = jest.spyOn(exec, 'exec')

    await composer.install('locked', '--profile --no-plugins --working-dir subdirectory')

    expect(execMock).toHaveBeenCalledTimes(1)
    expect(execMock).toHaveBeenCalledWith('composer install --no-interaction --no-progress --ansi --profile --no-plugins --working-dir subdirectory')
  })
})
