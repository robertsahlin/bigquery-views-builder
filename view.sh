#!/bin/sh
project_id=$1
sql_file=$2
echo "$sql_file"
query="$(cat $sql_file)"
echo "${query//<project_id>/$project_id}"
bq query --batch --use_legacy_sql=false "${query//<project_id>/$project_id}"