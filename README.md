# JSON Tools CI Build Image

This is an image for validating JSON object against a JSON schema definition. 

## Examples

To validate a JSON Schema file in YAML:
```
json-validate.sh schema.yaml
```

To validate a JSON object agains a schema:
```
json-validate.sh schema.yaml object.json
```

## Build Image
You can build the image locally by running `make package`. 

Please refer to the Makefile for the details. 

