BARTOC=http://bartoc.org/en/node/241
include ../Makefile

ddc-lcsh.ndjson:
	catmandu convert marcxml --skip-errors 1 --fix ddc-lcsh.fix to Null < lcsh.xml > ddc-lcsh.ndjson
