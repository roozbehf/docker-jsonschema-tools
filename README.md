# JSON Schema Tools

This repository provides a docker image for:
- converting jsonschema files written in YAML to JSON
- validating the correctness of jsonschema files (in YAML)
- validating a JSON object file against a JSON schema definition (in YAML) 

## Examples

See the [`examples`](examples) directory for examples. 

To validate a JSON Schema file in YAML:
```
./validate-json.sh examples/schema.yml
```

To validate a JSON object agains a schema:
```
./validate-json.sh examples/schema.yml examples/valid-object.json 
```

## Docker Image
A publicly available built image is available on Dockerhub at [theroozbeh/jsonschema-tools](https://hub.docker.com/repository/docker/theroozbeh/jsonschema-tools/general)

### Build Image
You can build the image locally by running `make build`. 

Please refer to the [`Makefile`](Makefile) for the details. 

