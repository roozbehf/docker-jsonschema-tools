## JSON Schema Examples

### Files

* [`schema.yml`](schema.yml): a simple schema definition
* [`valid-object.json`](valid-object.json): a valid JSON object according to the schema
* [`invalid-object.json`](invalid-object.json): an invalid JSON object according to the schema

### Validation Example

Validate the schema:
```
$ json-validate.sh schema.yml
```

Validate the object against the schema:
```
$ json-validate.sh schema.yml valid-object.json 
```
