/**
 * Simple script to convert GND to LCSH mappings from ntriples to JSKOS
 */

import * as readline from "node:readline/promises"
import crypto from "node:crypto"

function getHash(text) {
  return crypto.createHash("md5").update(text).digest("hex")
}

const mapping = {
  from: {
    memberSet: [{ uri: null }]
  },
  fromScheme: { uri: "http://bartoc.org/en/node/430" },
  to: { memberSet: [{ uri: null }] },
  toScheme: { uri: "http://bartoc.org/en/node/454" },
  type: [null],
  creator: [
    {
      prefLabel: {
        de: "DNB"
      }
    }
  ],
}

const hashes = new Set()

const rl = readline.createInterface({
  input: process.stdin,
})

for await (const line of rl) {
  const match = line.match(/<(https\:\/\/d-nb\.info\/gnd\/.*)> <(.*Match)> <(https?:\/\/id\.loc\.gov\/authorities\/subjects\/.*)> \./)
  if (!match) {
    continue
  }
  const [, gnd, type, lcsh] = match
  if (!gnd) {
    console.error(`No GND URI for line: ${line}`)
    process.exit(1)
  }
  if (!type) {
    console.error(`Unknown type for line: ${line}`)
    process.exit(1)
  }
  if (!lcsh) {
    console.error(`No DDC URI for line: ${line}`)
    process.exit(1)
  }
  mapping.from.memberSet[0].uri = gnd
  mapping.to.memberSet[0].uri = lcsh
  mapping.type[0] = type
  const mappingString = JSON.stringify(mapping)
  const hash = getHash(mappingString)
  if (!hashes.has(hash)) {
    console.log(mappingString)
    hashes.add(hash)
  }
}
