#!/bin/bash


INPUT_FILE="file.csv"
OLDIFS=$IFS
IFS=,

[ ! -f $INPUT_FILE ] && { echo "$INPUT_FILE does not exist! ...Exiting"; exit 47; }
# as many fields as you want
while read -r Field1 Field2 Field3
do
  echo "$Field1 $Field2 $Field3 ..etc"
# stripping out # starting comment lines with sed because
#   self contained single use scripts
done < <(sed '/^[[:blank:]]*#/d;/^$/d' ./"${INPUT_FILE}")

IFS=$OLDIFS

