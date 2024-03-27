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