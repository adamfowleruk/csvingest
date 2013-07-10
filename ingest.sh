#!/bin/sh
export MLCP=/Users/adamfowler/Documents/marklogic/software/marklogic-contentpump-1.0/bin/mlcp.sh
date
$MLCP import -host localhost -input_file_type delimited_text -delimiter , -input_file_path . -input_file_pattern 'gp-pres-data-london-splits-.*' -output_uri_prefix /gp-pres-data/london/ -output_uri_suffix .xml -password admin -port 8056 -thread_count 10 -transaction_size 100 -username admin -xml_repair_level full
date
