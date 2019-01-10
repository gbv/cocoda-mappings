Convert VIAF link dumps to multiple CSV files with mappings.

~~~
DUMP = viaf-20181104-links.txt.gz
cat $DUMP | ./viaf2csv.pl 2> viaf.err
~~~
