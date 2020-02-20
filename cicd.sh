#!/bin/sh
#./cicd.sh mathem-ml-datahem-test views
project_id=$1
views_dir=$2
location=${3:-EU}  

bq_safe_mk() {
    dataset=$1
    exists=$(bq ls -d | grep -w $dataset)
    if [ -n "$exists" ]; then
       echo "Not creating $dataset since it already exists"
    else
       echo "Creating dataset $project_id:$dataset with location: $location"
       bq --location=$location mk $project_id:$dataset
    fi
}

for dir_entry in $(find ./$views_dir -mindepth 1 -maxdepth 1 -type d -printf '%f\n')
do
  echo "$dir_entry"
  bq_safe_mk $dir_entry
done

for file_entry in $(find ./$views_dir -type f -follow -print)
do
  echo "$file_entry"
  gcloud builds submit --async --config=cloudbuild.view.yaml --substitutions=_SQL_FILE="$file_entry" . 
done