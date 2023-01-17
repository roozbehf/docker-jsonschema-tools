#!/bin/bash

# 
# Converts the YAML scheme definition to JSON and validates it using 
# https://github.com/santhosh-tekuri/jsonschema
#
# (c) 2018-2023 Roozbeh Farahbod
#

YAML_SCHEMA="$1"
JSON_OBJ_FILE="$2"
ROOT_DIR=/pg
OUTPUT_SUB_DIR=json-schema-output
OUTPUT_DIR=${ROOT_DIR}/${OUTPUT_SUB_DIR}

# show usage
function showUsage() {
    echo "Usage: validate.sh <yaml-schema> [json-file]"
    exit 1
}

# convert yaml to json 
function yaml2json() {
    YAML2JSON="yq --prettyPrint --output-format json ."

    if [ -z "${YAML_SCHEMA}" ]
    then
        showUsage
    fi

    cd ${ROOT_DIR}

    FILENAME=`basename "${YAML_SCHEMA}"`
    JSON_SCHEMA_FILE="${OUTPUT_DIR}/${FILENAME%.*}.json"

    echo "Converting '${YAML_SCHEMA}'..."
    cat "${YAML_SCHEMA}" | ${YAML2JSON} | sed 's/\.yml/.json/g' | sed 's/\.yaml/.json/g' > "${JSON_SCHEMA_FILE}"
}

# rm -rf ${OUTPUT_DIR}/*
mkdir -p ${OUTPUT_DIR}
cd ${ROOT_DIR}

# convert all referenced YAML files 
DIR_NAME=`dirname ${YAML_SCHEMA}`
cat ${YAML_SCHEMA}  \
    | grep "\$ref" \
    | grep "ya\?ml" \
    | sed 's/^[\t\ ]*$ref:\ //g' \
    | sed "s/\'//g" \
    | sed 's/"//g' \
    | while read yamlFile; do $0 "${DIR_NAME}/${yamlFile}"; done

yaml2json ${YAML_SCHEMA}

# validate the JSON schema file
jv "${JSON_SCHEMA_FILE}" 
if [ $? -eq 0 ]
then
    echo "✅ '${YAML_SCHEMA}' seems to be valid."
else 
    echo "❌ '${YAML_SCHEMA}' validataion failed."
    exit 1
fi

# validate the JSON object if provided
if [ -n "${JSON_OBJ_FILE}" ]
then 
    jv "${JSON_SCHEMA_FILE}" "${JSON_OBJ_FILE}"
    if [ $? -eq 0 ]
    then
        echo "✅ '${JSON_OBJ_FILE}' seems to be valid with respect to the schema."
    else
        echo "❌ '${JSON_OBJ_FILE}' validataion failed."
        exit 1
    fi
fi

echo "Converted files are stored in '${OUTPUT_SUB_DIR}'."
