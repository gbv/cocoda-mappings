BARTOC=http://bartoc.org/en/node/241
include ../Makefile

lcsh-ddc.ndjson:
	catmandu convert marcxml --skip-errors 1 --fix lcsh-ddc.fix to ndjson < lcsh.xml > lcsh-ddc.ndjson
