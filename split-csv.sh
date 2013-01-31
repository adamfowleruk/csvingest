#!/bin/sh

# take input file name
FILEBASE=$1
FILEBASE=${FILEBASE%.*}

# get first line (column names)
FIRST=`head -n 1 $1`

# TODO extract bit before the CSV to use as temp folder name
TEMP=$FILEBASE-temp
mkdir $TEMP
OUT=$FILEBASE-output
mkdir $OUT

# remove first line
tail -n +2 $1 > $TEMP/$FILEBASE-nofirst.csv

# if in tab mode, replace tabs with commas
if [ "$#" -eq 2 ]; then
  echo "Converting tabs to commas"
  sed 's/  /,/g' < $TEMP/$FILEBASE-nofirst.csv > $TEMP/$FILEBASE-nofirst2.csv ;
  mv $TEMP/$FILEBASE-nofirst2.csv $TEMP/FILEBASE-nofirst.csv
fi

# trim spaces
sed 's/[ ]*,[ ]*/,/g' < $TEMP/$FILEBASE-nofirst.csv > $TEMP/$FILEBASE-nospaces.csv

#remove trailing commas in file but only if column names (first line) are trailing commas too
#sed -i 's/,$//g' gp-pres-data-london.csv
#MATCHES=`echo "$FIRST" | grep "^.*,$" -`
#if [ $MATCHES ]; then
#	echo "  Removing trailing commas"
	sed 's/\(^.*\)[,]$/\1/g' < $TEMP/$FILEBASE-nospaces.csv > $TEMP/$FILEBASE-nocommas.csv ;
#else
#	mv $TEMP/$FILEBASE-nospaces.csv $TEMP/$FILEBASE-nocommas.csv ;
#fi

# now split the file, preserving the first line

cd $OUT
split -l 100 ../$TEMP/$FILEBASE-nocommas.csv $FILEBASE-
cd ..

# loop through output file and prepend all with FIRSTLINE
for OUTFILE in $(ls $OUT/ )
do
	echo $FIRST > $OUT/$OUTFILE-out
	cat $OUT/$OUTFILE >> $OUT/$OUTFILE-out
	rm $OUT/$OUTFILE
done

rm -rf $TEMP

echo "Done. Now use Adam's csv library to ingest everything in $OUT"

