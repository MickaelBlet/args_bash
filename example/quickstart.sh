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
    --help "take the second argument" \
    --dest "ARG2" \
    --default="42" \
    -- "ARG2"
args_add_argument \
    --help="print hello" \
    --action="store_true" \
    --dest="DO_HELLO" \
    -- "-p" "--print-hello"
args_add_argument \
    --help="help of option" \
    --metavar="VALUE" \
    --default="24" \
    -- "--option" "-o"
args_add_argument \
    --help="help of count" \
    --action="count" \
    -- "--count" "-c"

args_parse_arguments "$@"

if args_isexists "-o"; then
    echo "coucou"
fi

args_count "-c"
echo "${ARGS[c]}"

echo "'ARG1' argument from dest ${ARG1:-}"
echo "'ARG2' argument from dest ${ARG2:-}"
echo "'ARG1' argument from map  ${ARGS[ARG1]}"
echo "'--option' option from map ${ARGS[option]}"
if $DO_HELLO; then
    echo "Hello world"
fi