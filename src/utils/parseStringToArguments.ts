import argsParser, {Arguments} from 'yargs-parser'

export function parseStringToArguments(args: string): Arguments {
  return argsParser(args, {
    configuration: {
      'camel-case-expansion': false
    }
  })
}
