/**
 * Simple script to convert GND to DDC mappings from ntriples to JSKOS
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
  toScheme: { uri: "http://bartoc.org/en/node/241" },
  type: [null],
  creator: [
    {
      prefLabel: {
        de: "DNB"
      }
    }
  ],
}

const typeMap = {
  "https://d-nb.info/standards/elementset/gnd#relatedDdcWithDegreeOfDeterminacy1": "http://www.w3.org/2004/02/skos/core#relatedMatch",
  "https://d-nb.info/standards/elementset/gnd#relatedDdcWithDegreeOfDeterminacy2": "http://www.w3.org/2004/02/skos/core#narrowMatch",
  "https://d-nb.info/standards/elementset/gnd#relatedDdcWithDegreeOfDeterminacy3": "http://www.w3.org/2004/02/skos/core#closeMatch",
  "https://d-nb.info/standards/elementset/gnd#relatedDdcWithDegreeOfDeterminacy4": "http://www.w3.org/2004/02/skos/core#exactMatch",
}

const hashes = new Set()

const rl = readline.createInterface({
  input: process.stdin,
})

for await (const line of rl) {
  const [, gnd, type, ddc] = line.match(/<(.*)> <(.*)> <(.*)> \./)
  if (!gnd) {
    console.error(`No GND URI for line: ${line}`)
    process.exit(1)
  }
  if (!type || !typeMap[type]) {
    console.error(`Unknown type for line: ${line}`)
    process.exit(1)
  }
  if (!ddc) {
    console.error(`No DDC URI for line: ${line}`)
    process.exit(1)
  }
  mapping.from.memberSet[0].uri = gnd
  mapping.to.memberSet[0].uri = `${ddc}e23/`
  mapping.type[0] = typeMap[type]
  const mappingString = JSON.stringify(mapping)
  const hash = getHash(mappingString)
  if (!hashes.has(hash)) {
    console.log(mappingString)
    hashes.add(hash)
  }
}
