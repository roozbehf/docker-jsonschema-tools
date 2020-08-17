#!/bin/bash

# 
# Converts the YAML scheme definition to JSON and validates it using 
# https://github.com/santhosh-tekuri/jsonschema
#
# (c) 2018-2020 Roozbeh Farahbod
#

YAML_SCHEMA="$1"
JSON_OBJ_FILE="$2"

function showUsage() {
    echo "Usage: validate.sh <yaml-schema> [json-file]"
    exit 1
}

if [ -z "${YAML_SCHEMA}" ]
then
    showUsage
fi

cd /pg

FILENAME=`basename "${YAML_SCHEMA}"`
JSON_SCHEMA_FILE="${FILENAME%%.*}.json"

cat "${YAML_SCHEMA}" | yaml2json | sed 's/\.yml/.json/g' | jsonpp > "${JSON_SCHEMA_FILE}"

if [ -z "${JSON_OBJ_FILE}" ]
then 
    jv "${JSON_SCHEMA_FILE}" 
else
    jv "${JSON_SCHEMA_FILE}" "${JSON_OBJ_FILE}"
fi

if [ $? -eq 0 ]
then
    echo "All good."
    exit 0
else
    echo "Validataion failed."
    exit 1
fi
