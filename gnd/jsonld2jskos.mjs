#!/usr/bin/env node
import anystream from "json-anystream"
import { readFileSync, existsSync } from "fs"

const [voc, ...args] = process.argv.slice(2)

const concordanceFile = `gnd-${voc}-concordance.json`
if (!existsSync(concordanceFile)) {
  console.error(`missing ${concordanceFile}`)
  process.exit(1)
}

const concordance = JSON.parse(readFileSync(concordanceFile))

const fromScheme = {
        uri: "http://bartoc.org/en/node/430",
        namespace: "https://d-nb.info/gnd/",
    }

const toScheme = concordance.toScheme

// FIXME: DNB data uses wrong URIs for AGROVOC
if (toScheme.namespace.startsWith("https")) {
  toScheme.urifix = uri => uri.replace(/^http:/,"https:")
} else {
  toScheme.urifix = uri => uri.replace(/^https:/,"http:")
}

const asArray = a => Array.isArray(a) ? a : [a]

async function readJSONLD(source) {
  const graph = {}
  const stream = await anystream.make(source, "json")
  return new Promise((resolve, reject) => {
    stream.on("error", e => reject(e))
    stream.on("end", () => resolve(graph))
    stream.on("data", data => {
      asArray(data).flat().forEach(obj => {
        if ("@id" in obj) {
          graph[obj["@id"]] = obj
        } else {
          reject("missing @id")
        }
      })
    })
  })
}

const graph = await readJSONLD(args[0] || process.stdin)

for (let from in graph) {
  if (!from.startsWith(fromScheme.namespace)) continue
  const rdf = graph[from]

  var type
  for (var t of ['exact','close','broad','narrow']) {
    var mappingType = `http://www.w3.org/2004/02/skos/core#${t}Match`
    if (mappingType in rdf) {
      type = mappingType
    }
  }

  if (!type || !rdf[type]) continue
  for (let to of asArray(rdf[type])) {
    to = to["@id"]
    if (to.startsWith("_:")) {
      to = graph[to]['http://www.loc.gov/mads/rdf/v1#componentList'].map(x=>({uri:x["@id"]}))
    } else {
      to = [ { uri: to } ]
    }
    // check/extend to.memberSet
    to = to.map(({uri}) => ({uri: toScheme.urifix(uri), inScheme: [ { uri: toScheme.uri } ] }))

    // TODO: allow null-mappings
    to = to.filter(({uri}) => {
      if (!uri.startsWith(toScheme.namespace)) {
        console.error(`URI ${uri} does not match ${toScheme.namespace}`)
        return false
      }
      return true
    })

    if (to.length) {
      const jskos = {
        from: { memberSet: [ { uri: from, inScheme: [ { uri: fromScheme.uri } ] } ] },
        to: { memberSet: to },
        type: [type], 
        partOf: [ { uri: concordance.uri } ]
      }
      console.log(JSON.stringify(jskos))
    }
  }
}
