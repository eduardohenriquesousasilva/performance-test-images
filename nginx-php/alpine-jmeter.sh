
#!/bin/bash
set -e

TEST_FILE_NAME=test.jmx
RESULT_CSV_FILE_NAME=test-result.csv
FOLDER_HTML_DASHBOARD_NAME=html-reports/
BASE_PROJECT_PATH=$(pwd)/../jmeter-tests/nginx-php/alpine

if [ -e "$BASE_PROJECT_PATH/$1/$RESULT_CSV_FILE_NAME" ];
then
    rm "$BASE_PROJECT_PATH/$1/$RESULT_CSV_FILE_NAME";
fi
if [ -e "$BASE_PROJECT_PATH/$1/$FOLDER_HTML_DASHBOARD_NAME" ];
then
    rm -Rf "$BASE_PROJECT_PATH/$1/$FOLDER_HTML_DASHBOARD_NAME";
fi

mkdir "$BASE_PROJECT_PATH/$1/$FOLDER_HTML_DASHBOARD_NAME";

# dk stats >> ../jmeter-tests/nginx-php/alpine/10000/docker-stats.csv

jmeter -n -t "$BASE_PROJECT_PATH/$1/$TEST_FILE_NAME" \
    -l "$BASE_PROJECT_PATH/$1/$RESULT_CSV_FILE_NAME" \
    -e -o "$BASE_PROJECT_PATH/$1/$FOLDER_HTML_DASHBOARD_NAME"
