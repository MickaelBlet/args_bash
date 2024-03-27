# Args

Parse and stock arguments/options from `argv`.  
Inspired by the Python library [argparse](https://python.readthedocs.io/en/latest/library/argparse.html).  
Documentations available at [documentations](#documentations).

Use [getopt](https://www.man7.org/linux/man-pages/man1/getopt.1.html) for parse arguments/options.

## Quikstart

```bash
#!/bin/bash

set -euo pipefail

source "args.sh"

args_set_description "example of description"
args_set_epilog "example of epilog"

args_add_argument \
    --name="ARG1" \
    --help="take the first argument" \
    --dest="ARG1" \
    --required="true"
args_add_bool_option \
    --short="c" \
    --long="clear" \
    --help="clear the test directory" \
    --dest="OPT_CLEAR"
args_add_option \
    --long="option" \
    --help="help of option" \
    --metavar="VALUE" \
    --default="24"

args_parse_arguments "$@"

echo "'ARG1' argument from dest $ARG1"
echo "'ARG1' argument from map  ${ARGS[ARG1]}"
echo "'-c/--clear' option from dest $OPT_CLEAR"
echo "'-c/--clear' option from map  ${ARGS[c]}/${ARGS[clear]}"
echo "'--option' option from map ${ARGS[option]}"
```

```
$ ./example/quickstart.sh
./example/quickstart.sh: argument 'ARG1' is required
$ ./example/quickstart.sh -h
usage: quickstart.sh [-c] [-h] [--option VALUE] -- ARG1

example of description

positional arguments:
  ARG1                  take the first argument

optional arguments:
  -c, --clear           clear the test directory
  -h, --help            print this help message
  --option VALUE        help of option

example of epilog
$ ./example/quickstart.sh 42
'ARG1' argument from dest 42
'ARG1' argument from map  42
'-c/--clear' option from dest false
'-c/--clear' option from map  false/false
'--option' option from map 24
```

## Functions

### args_add_argument

Add a positional argument

|option|description|
|---|---|
|--default|Default value|
|--dest|Destination variable|
|--help|Usage helper|
|--name|Name of argument|
|--required|Is required if true|

#### Example

```bash
args_add_argument --name="FOO" --help="help of FOO" --dest="FOO" --required="true"
```

### args_add_bool_option

Add a boolean option

|option|description|
|---|---|
|--dest|Destination variable|
|--help|Usage helper|
|--long|Long option name|
|--short|Short option name|

#### Example

```bash
args_add_bool_option --short="f" --long="foo" --help="help of foo" --dest="FOO"
```

### args_add_reverse_bool_option

Add a reverse boolean option

|option|description|
|---|---|
|--dest|Destination variable|
|--help|Usage helper|
|--long|Long option name|
|--short|Short option name|

#### Example

```bash
args_add_reverse_bool_option --short="f" --long="foo" --help="help of foo" --dest="FOO"
```

### args_add_option

Add a option who take a argument

|option|description|
|---|---|
|--default|Default value of option|
|--dest|Destination variable|
|--help|Usage helper|
|--long|Long option name|
|--metavar|Usage argument name (if not set use long/short name)|
|--required|Is required if true|
|--short|Short option name|

#### Example

```bash
args_add_option --short="f" --long="foo" --help="help of foo" --dest="FOO"
```

### args_parse_arguments

Use after args_add_* functions  
Convert argument strings to objects and assign them as attributes on the ARGS map  
Previous calls to args_add_argument/args_add_bool_option/args_add_reverse_bool_option/args_add_option  
determine exactly what objects are created and how they are assigned  
Execute this with "$@" parameters

#### Example

```bash
args_parse_arguments "$@"
```

## Documentations

[docs/global.md](docs/global.md)  
[docs/setter.md](docs/setter.md)