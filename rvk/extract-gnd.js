import marc4js from "npm:marc4js"
import process from "node:process"

// Parse incoming XML stream from standard input via marc4js
const parser = marc4js.parse({ format: "marcxml" })
const stream = process.stdin.pipe(parser)

// All MarcXML fields that could contain a GND reference
const gndFields = ["700", "710", "711", "730", "750", "751"]

// Convenience methods to get fields from a record and subfields from a field
function getFieldsFromRecord(record, fields) {
  if (!Array.isArray(fields)) {
    fields = [fields]
  }
  return [].concat(...fields.map(field => record._dataFields.filter(( { _tag } ) => _tag === field)))
}
function getSubfieldFromField(field, subfield) {
  return field._subfields.filter(({ _code }) => _code === subfield).map(({ _data }) => _data)
}

function getRvkFromField(field) {
  const $a = getSubfieldFromField(field, "a")[0]
  const $c = getSubfieldFromField(field, "c")[0]
  if (!$c) {
    return $a
  }
  return `${$a} - ${$c}`
}

// Mapping skeleton
const mapping = {
  // from and to will be filled by loop below
  from: {
    memberSet: []
  },
  to: { memberSet: [] },
  // Everything else is the same for all mappings
  fromScheme: { uri: "http://bartoc.org/en/node/533" },
  toScheme: { uri: "http://bartoc.org/en/node/430" },
  type: ["http://www.w3.org/2004/02/skos/core#mappingRelation"],
  creator: [
    {
      prefLabel: { de: "UB Regensburg" },
      url: "https://rvk.uni-regensburg.de",
    }
  ],
}

let count = 0

for await (const record of stream) {
  count += 1

  // Get RVK notation from record
  const rvkData = getFieldsFromRecord(record, "153")[0]
  const rvk = getRvkFromField(rvkData)
  
  // Find GND IDs
  const gndData = getFieldsFromRecord(record, gndFields).filter(field => getSubfieldFromField(field, "2")[0] === "gnd")
  gndData.forEach(field => {
    const gnd = getSubfieldFromField(field, "0")[0]?.match(/\(.+\)(.+)/)?.[1]
    if (gnd) {
      // Create a mapping and print to console
      mapping.from.memberSet[0] = { uri: `http://rvk.uni-regensburg.de/nt/${encodeURIComponent(rvk)}` }
      mapping.to.memberSet[0] = { uri: `https://d-nb.info/gnd/${encodeURIComponent(gnd)}` }
      console.log(JSON.stringify(mapping))
    }
  })
}
