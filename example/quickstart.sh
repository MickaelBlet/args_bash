#!/bin/bash

set -euo pipefail

source "args.sh"

args_set_description "example" "of" "description"
args_set_epilog "example of epilog"

args_add_argument \
    --help "take the first argument" \
    --dest "ARG1" \
    --required \
    -- "ARG1"
args_add_argument \
    --help="print hello" \
    --action="store_true" \
    --dest="DO_HELLO" \
    -- "-p" "--print-hello"
args_add_argument \
    --help="help of option" \
    --metavar="VALUE" \
    --default="24" \
    -- "--option"

args_parse_arguments "$@"

echo "'ARG1' argument from dest ${ARG1:-}"
echo "'ARG1' argument from map  ${ARGS[ARG1]}"
echo "'--option' option from map ${ARGS[option]}"
if $DO_HELLO; then
    echo "Hello world"
fi