#!/bin/sh
# get london addresses
grep ",LONDON" gp-addresses-T201207ADDR\ BNFT.CSV > gp-addresses-london.csv

# Get list of london GP surgery codes
sed -n  's/^[0-9]*[,]\([A-Z0-9]*\)[,].*$/\1/p' gp-addresses-london.csv > stopwords.txt 

# Filter prescription data using these codes
cat  gp-data-T201207PDPI+BNFT.CSV | grep -w -f stopwords.txt > gp-pres-data-london.csv

