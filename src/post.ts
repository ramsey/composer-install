/* istanbul ignore next */
import {postAction} from './actions'

async function run(): Promise<void> {
  await postAction()
}

run()

export default run
