# yaml-directory

Load YAML from files in a directory structure.

Based on [json-directory](https://github.com/luke-clifton/json-directory).

## yamldir

The `yamldir` executable uses the `yaml-directory` library to convert a
directory of YAML files into a YAML or JSON value.

### Usage

```
Usage: yamldir DIR [-j|--json]

Available options:
  DIR                      Directory to decode
  -j,--json                Set output format to JSON
  -h,--help                Show this help text
```

### Example

Running `yamldir` on the [example](./example) directory yields the following
result:

```bash
$ yamldir example
```
```yaml
file:
  key: value
directory:
  a:
    string: foo
  b:
    number: 1
```
