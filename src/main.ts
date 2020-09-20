/* istanbul ignore next */
import {mainAction} from './actions'

async function run(): Promise<void> {
  await mainAction()
}

run()

export default run
