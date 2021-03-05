import {info} from '@actions/core'

export function getOperatingSystem(): string {
  const os = process.platform

  info(`Operating system is ${os}`)

  return os
}
