import { getComposerWorkingDir } from '../../src/utils/getComposerWorkingDir';

jest.mock('@actions/core');

describe('getComposerWorkingDir', () => {
  test('with empty options', () => {
    expect(getComposerWorkingDir()).toEqual('');
  });

  test('with --working-dir option', () => {
    expect(getComposerWorkingDir('--working-dir subdirectory')).toEqual('subdirectory');
  });

  test('with -d (alias of --working-dir) option', () => {
    expect(getComposerWorkingDir('-d subdirectory')).toEqual('subdirectory');
  });

  test('with other options AND without --working-dir', () => {
    expect(getComposerWorkingDir('-vv --no-plugins')).toEqual('');
  });

  test('with other options AND with --working-dir', () => {
    expect(getComposerWorkingDir('-vv --working-dir subdirectory --no-plugins')).toEqual('subdirectory');
  });
});
