#
# args.sh
#
# Licensed under the MIT License <http://opensource.org/licenses/MIT>.
# Copyright (c) 2024 BLET Mickael.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

declare -A ARGS
declare -A __ARGS

# Clean all map and array for recalled
args_clean() {
    ARGS=()
    __ARGS=()

    __ARGS[PROG_NAME]=""
    __ARGS[USAGE]=""
    __ARGS[DESCRIPTION]=""
    __ARGS[EPILOG]=""
    __ARGS[USAGE_WIDTH_PADDING]=2
    __ARGS[USAGE_WIDTH_ARGUMENT]=20
    __ARGS[USAGE_WIDTH_SEPARATOR]=2
    __ARGS[USAGE_WIDTH_HELP]=56

    # positional argument
    __ARGS[argument.size]=0
    # optional argument
    __ARGS[option.size]=0
    return 0
}

__args_already_exists() {
    local type
    local i=0
    local j=0
    while [ "$i" -lt "${__ARGS[argument.size]}" ]; do
        if [ "$1" = "${__ARGS[argument.${i}.name]}" ]; then
            return 0;
        fi
        i=$((i + 1))
    done
    i=0
    while [ "$i" -lt "${__ARGS[option.size]}" ]; do
        for type in "short" "long"; do
            j=0
            while [ "$j" -lt "${__ARGS[option.${i}.${type}.size]}" ]; do
                if [ "$1" = "${__ARGS[option.${i}.${type}.${j}]}" ]; then
                    return 0;
                fi
                j=$((j + 1))
            done
        done
        i=$((i + 1))
    done
    return 1;
}

# Swap options
__args_swap_options() {
    local i
    local action
    local metavar
    local help
    local default
    local dest
    local required
    local action
    local exists
    local count
    local choices
    local nargs
    local shorts
    local longs
    shorts=()
    longs=()

    # get parameters of option 1
    action="${__ARGS[option.${1}.action]}"
    metavar="${__ARGS[option.${1}.metavar]}"
    help="${__ARGS[option.${1}.help]}"
    default="${__ARGS[option.${1}.default]}"
    dest="${__ARGS[option.${1}.dest]}"
    required="${__ARGS[option.${1}.required]}"
    action="${__ARGS[option.${1}.action]}"
    exists="${__ARGS[option.${1}.exists]}"
    count="${__ARGS[option.${1}.count]}"
    choices="${__ARGS[option.${1}.choices]}"
    nargs="${__ARGS[option.${1}.nargs]}"
    i=0
    while [ "$i" -lt "${__ARGS[option.${1}.short.size]}" ]; do
        shorts+=("${__ARGS[option.${1}.short.${i}]}")
        i=$((i + 1))
    done
    i=0
    while [ "$i" -lt "${__ARGS[option.${1}.long.size]}" ]; do
        longs+=("${__ARGS[option.${1}.long.${i}]}")
        i=$((i + 1))
    done

    __ARGS[option.${1}.action]="${__ARGS[option.${2}.action]}"
    __ARGS[option.${1}.metavar]="${__ARGS[option.${2}.metavar]}"
    __ARGS[option.${1}.help]="${__ARGS[option.${2}.help]}"
    __ARGS[option.${1}.default]="${__ARGS[option.${2}.default]}"
    __ARGS[option.${1}.dest]="${__ARGS[option.${2}.dest]}"
    __ARGS[option.${1}.required]="${__ARGS[option.${2}.required]}"
    __ARGS[option.${1}.action]="${__ARGS[option.${2}.action]}"
    __ARGS[option.${1}.exists]="${__ARGS[option.${2}.exists]}"
    __ARGS[option.${1}.count]="${__ARGS[option.${2}.count]}"
    __ARGS[option.${1}.choices]="${__ARGS[option.${2}.choices]}"
    __ARGS[option.${1}.nargs]="${__ARGS[option.${2}.nargs]}"
    i=0
    while [ "$i" -lt "${__ARGS[option.${2}.short.size]}" ]; do
        __ARGS[option.${1}.short.${i}]="${__ARGS[option.${2}.short.${i}]}"
        i=$((i + 1))
    done
    __ARGS[option.${1}.short.size]="${__ARGS[option.${2}.short.size]}"
    i=0
    while [ "$i" -lt "${__ARGS[option.${2}.long.size]}" ]; do
        __ARGS[option.${1}.long.${i}]="${__ARGS[option.${2}.long.${i}]}"
        i=$((i + 1))
    done
    __ARGS[option.${1}.long.size]="${__ARGS[option.${2}.long.size]}"

    __ARGS[option.${2}.action]="$action"
    __ARGS[option.${2}.metavar]="$metavar"
    __ARGS[option.${2}.help]="$help"
    __ARGS[option.${2}.default]="$default"
    __ARGS[option.${2}.dest]="$dest"
    __ARGS[option.${2}.required]="$required"
    __ARGS[option.${2}.action]="$action"
    __ARGS[option.${2}.exists]="$exists"
    __ARGS[option.${2}.count]="$count"
    __ARGS[option.${2}.choices]="$choices"
    __ARGS[option.${2}.nargs]="$nargs"
    for i in "${!shorts[@]}"; do
        __ARGS[option.${2}.short.${i}]="${shorts[$i]}"
    done
    __ARGS[option.${2}.short.size]="${#shorts[@]}"
    for i in "${!longs[@]}"; do
        __ARGS[option.${2}.long.${i}]="${longs[$i]}"
    done
    __ARGS[option.${2}.long.size]="${#longs[@]}"
    return 0
}

# Sort by asc optional arguments
__args_sort() {
    local max="$((${__ARGS[option.size]} - 1))"
    local i j
    while [ "$max" -gt 0 ]; do
        i=0
        j=1
        while [ "$i" -lt "$max" ]; do
            if [ "${__ARGS[option.${i}.short.size]}" -ne 0 ] && \
               [ "${__ARGS[option.${j}.short.size]}" -ne 0 ]; then
                if [ "${__ARGS[option.${i}.required]}" = "false" ] && \
                   [ "${__ARGS[option.${j}.required]}" = "true" ]; then
                    __args_swap_options "$i" "$j"
                elif [ "${__ARGS[option.${i}.required]}" = "false" ] && \
                     [[ "${__ARGS[option.${i}.short.0]}" > "${__ARGS[option.${j}.short.0]}" ]]; then
                    __args_swap_options "$i" "$j"
                fi
            elif [ "${__ARGS[option.${i}.short.size]}" -eq 0 ]  && \
                 [ "${__ARGS[option.${j}.short.size]}" -eq 0 ]  && \
                 [ "${__ARGS[option.${i}.long.size]}" -ne 0 ] && \
                 [ "${__ARGS[option.${j}.long.size]}" -ne 0 ]; then
                if [ "${__ARGS[option.${i}.required]}" = "false" ] && \
                   [ "${__ARGS[option.${j}.required]}" = "true" ]; then
                    __args_swap_options "$i" "$j"
                elif [ "${__ARGS[option.${i}.required]}" = "false" ] && \
                     [[ "${__ARGS[option.${i}.long.0]}" > "${__ARGS[option.${j}.long.0]}" ]]; then
                    __args_swap_options "$i" "$j"
                fi
            elif [ "${__ARGS[option.${i}.short.size]}" -eq 0 ]; then
                __args_swap_options "$i" "$j"
            fi
            i=$((i + 1))
            j=$((j + 1))
        done
        max=$((max - 1))
    done
    return 0
}

__args_parse_option_is_value() {
    local index="$1"
    local value="$2"
    local type
    local name
    local i
    for type in "short" "long"; do
        i=0
        while [ "$i" -lt "${__ARGS[option.${index}.${type}.size]}" ]; do
            [ "short" = "$type" ] && name="-"
            [ "long" = "$type" ] && name="--"
            name+="${__ARGS[option.${index}.${type}.${i}]}"
            if [ "$value" = "$name" ]; then
                return 0
            fi
            i=$((i + 1))
        done
    done
    return 1
}

__args_parse_option_is_assign_value() {
    local index="$1"
    local value="$2"
    local type
    local name
    local i
    for type in "short" "long"; do
        i=0
        while [ "$i" -lt "${__ARGS[option.${index}.${type}.size]}" ]; do
            [ "short" = "$type" ] && name="-"
            [ "long" = "$type" ] && name="--"
            name+="${__ARGS[option.${index}.${type}.${i}]}"
            if [[ "$value" = "$name="* ]]; then
                return 0
            fi
            i=$((i + 1))
        done
    done
    return 1
}

__args_parse_option_is_multi_short_value() {
    local index="$1"
    local value="$2"
    local name
    local i
    i=0
    while [ "$i" -lt "${__ARGS[option.${index}.short.size]}" ]; do
        name+="${__ARGS[option.${index}.short.${i}]}"
        if [[ "$value" = "-$name"* ]]; then
            return 0
        fi
        i=$((i + 1))
    done
    return 1
}

__args_parse_option_on_multi_short_value() {
    local index="$1"
    local value="$2"
    local name
    local i
    i=0
    while [ "$i" -lt "${__ARGS[option.${index}.short.size]}" ]; do
        name+="${__ARGS[option.${index}.short.${i}]}"
        if [[ "$value" = "$name"* ]]; then
            return 0
        fi
        i=$((i + 1))
    done
    return 1
}

__args_parse_assign_option_value() {
    local index="$1"
    local value="$2"
    local type
    local name
    local i
    for type in "short" "long"; do
        i=0
        while [ "$i" -lt "${__ARGS[option.${index}.${type}.size]}" ]; do
            name="${__ARGS[option.${index}.${type}.${i}]}"
            ARGS[${name}]="$value"
            i=$((i + 1))
        done
    done
    return 0
}

__args_parse_assign_option_multi_values() {
    local index="$1"
    local index_value="$2"
    local value="$3"
    local i
    local type
    local name
    for type in "short" "long"; do
        i=0
        while [ "$i" -lt "${__ARGS[option.${index}.${type}.size]}" ]; do
            name="${__ARGS[option.${index}.${type}.${i}]}"
            ARGS[${name}.${index_value}]="$value"
            if [ "${ARGS[${name}]+abracadabra}" ]; then
                ARGS[${name}]="${ARGS[${name}]} $value"
            else
                ARGS[${name}]="$value"
            fi
            i=$((i + 1))
        done
    done
    return 0
}

# Set the program name
#   params:
#     $1  Name of program
#   example:
#     args_set_prog_name "my_script"
args_set_prog_name() {
    __ARGS[PROG_NAME]="$1"
}

# Set a usage description
args_set_description() {
    __ARGS[DESCRIPTION]="$*"
}

# Set a epilog description
#   params:
#     $*  Concat all arguments
#   example:
#     args_set_epilog "Your epilog " "message"
args_set_epilog() {
    __ARGS[EPILOG]="$*"
}

# Set a full usage message
#   example:
#     args_set_usage "Your usage " "message"
args_set_usage() {
    __ARGS[USAGE]="$*"
}

# Set the widths of usage message
#   params:
#     $1  Padding
#     $2  Argument
#     $3  Separator
#     $4  Help
args_set_usage_widths() {
    __ARGS[USAGE_WIDTH_PADDING]="$1"
    __ARGS[USAGE_WIDTH_ARGUMENT]="$2"
    __ARGS[USAGE_WIDTH_SEPARATOR]="$3"
    __ARGS[USAGE_WIDTH_HELP]="$4"
}

# Check if argument is exists in argv
#   param:
#     $1  Argument name
args_isexists() {
    local i
    local j
    local type
    local name
    if [[ "$1" == "--"* ]]; then
        name="${1:2}"
    elif [[ "$1" == "-"* ]]; then
        name="${1:1}"
    else
        name="$1"
    fi
    i=0
    while [ "$i" -lt "${__ARGS[argument.size]}" ]; do
        if [ "$name" = "${__ARGS[argument.${i}.name]}" ]; then
            if [ "${__ARGS[argument.${i}.exists]}" = "true" ]; then
                return 0
            else
                return 1
            fi
        fi
        i=$((i + 1))
    done
    for type in "short" "long"; do
        i=0
        while [ "$i" -lt "${__ARGS[option.size]}" ]; do
            j=0
            while [ "$j" -lt "${__ARGS[option.${i}.${type}.size]}" ]; do
                if [ "$name" = "${__ARGS[option.${i}.${type}.${j}]}" ]; then
                    if [ "${__ARGS[option.${i}.exists]}" = "true" ]; then
                        return 0
                    else
                        return 1
                    fi
                fi
                j=$((j + 1))
            done
            i=$((i + 1))
        done
    done
    >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '$1' is not a valid argument name"
    return 1
}

# Check the count of argument in argv
#   param:
#     $1  Argument name
args_count() {
    local name
    if [[ "$1" == "--"* ]]; then
        name="${1:2}"
    elif [[ "$1" == "-"* ]]; then
        name="${1:1}"
    else
        name="$1"
    fi
    local i=0
    while [ "$i" -lt "${__ARGS[argument.size]}" ]; do
        if [ "$name" = "${__ARGS[argument.${i}.name]}" ]; then
            echo "${__ARGS[argument.${i}.count]}"
            return 0
        fi
        i=$((i + 1))
    done
    for type in "short" "long"; do
        i=0
        while [ "$i" -lt "${__ARGS[option.size]}" ]; do
            j=0
            while [ "$j" -lt "${__ARGS[option.${i}.${type}.size]}" ]; do
                if [ "$name" = "${__ARGS[option.${i}.${type}.${j}]}" ]; then
                    echo "${__ARGS[option.${i}.count]}"
                    return 0
                fi
                j=$((j + 1))
            done
            i=$((i + 1))
        done
    done
    >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '$1' is not a valid argument name"
    return 1
}

# Add a argument
#   option params:
#     --action    Action (append, count, store, store_false, store_true)
#     --choices   List of valid values (separate by spaces)
#     --default   Default value
#     --dest      Destination variable
#     --help      Usage helper
#     --metavar   Usage argument name (if not set use long/short name)
#     --nargs     The number of arguments that should be consumed
#     --required  Is required if exists
#   example:
#     args_add_argument --help="help of FOO" --dest="FOO" -- "FOO"
args_add_argument() {
    local action="store"
    local choices=""
    local default=""
    local dest=""
    local help=""
    local metavar=""
    local nargs=1
    local required=false
    while true; do
        if [ $# -eq 0 ]; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: end of options is required '--'"
            return 1
        fi
        case $1 in
            "--")
                shift
                break;;
            "--action")
                if [ $# -le 1 ]; then
                    >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--action' option require a argument"
                    return 1
                fi
                action="${2,,}"
                shift 2;;
            "--action="*)
                action="${1#*=}"
                action="${action,,}"
                shift;;
            "--choices")
                if [ $# -le 1 ]; then
                    >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--choices' option require a argument"
                    return 1
                fi
                choices="$2"
                shift 2;;
            "--choices="*)
                choices="${1#*=}"
                shift;;
            "--default")
                if [ $# -le 1 ]; then
                    >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--default' option require a argument"
                    return 1
                fi
                default="$2"
                shift 2;;
            "--default="*)
                default="${1#*=}"
                shift;;
            "--dest")
                if [ $# -le 1 ]; then
                    >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--dest' option require a argument"
                    return 1
                fi
                dest="$2"
                shift 2;;
            "--dest="*)
                dest="${1#*=}"
                shift;;
            "--help")
                if [ $# -le 1 ]; then
                    >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--help' option require a argument"
                    return 1
                fi
                help="$2"
                shift 2;;
            "--help="*)
                help="${1#*=}"
                shift;;
            "--metavar")
                if [ $# -le 1 ]; then
                    >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--metavar' option require a argument"
                    return 1
                fi
                metavar="$2"
                shift 2;;
            "--metavar="*)
                metavar="${1#*=}"
                shift;;
            "--nargs")
                if [ $# -le 1 ]; then
                    >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--nargs' option require a argument"
                    return 1
                fi
                nargs="$2"
                shift 2;;
            "--nargs="*)
                nargs="${1#*=}"
                shift;;
            "--required")
                required=true
                shift;;
            *)
                >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: unrecognized option '$1'"
                return 1;;
        esac
    done

    # bad format of action
    if [[ "$action" != "append" ]] && \
       [[ "$action" != "count" ]] && \
       [[ "$action" != "store" ]] && \
       [[ "$action" != "store_false" ]] && \
       [[ "$action" != "store_true" ]]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: unknown action '$action'"
        return 1
    fi

    # default and required
    if [ -n "$default" ] && [ "$required" = "true" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--default' used with '--required'"
        return 1
    fi

    # store_true or store_false
    if [[ "$action" == "store_true" ]] || [[ "$action" == "store_false" ]]; then
        # default
        if [ -n "$default" ]; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--default' used with action '$action'"
            return 1
        fi
        # metavar
        if [ -n "$metavar" ]; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--metavar' used with action '$action'"
            return 1
        fi
    fi

    # choises and not store
    if [[ "$action" != "store" ]] && [ -n "$choices" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--choices' used without action 'store'"
        return 1
    fi

    # infinite mode
    if [ "$nargs" = "+" ]; then
        nargs=1
        action="infinite"
    fi

    if [ "$nargs" -gt 1 ]; then
        # default
        if [ -n "$default" ]; then
            # get number of word
            local word
            local word_nb=0
            for word in ${default}; do
                word+=""
                word_nb=$((word_nb + 1))
            done
            if [ "$word_nb" -ne "$nargs" ]; then
                >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: number word of '--default' ($word_nb) is not the same of '--nargs' ($nargs)"
                return 1
            fi
        fi
        # choices
        if [ -n "$choices" ]; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--choices' can't used with '--nargs'"
            return 1
        fi
    fi

    # not name or flags
    if [ $# -eq 0 ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: need a flag or argument name"
        return 1
    fi

    local is_argument=false
    local is_flag=false
    local short_flags=()
    local long_flags=()
    local argument_name=""
    # check format of argument
    while [ $# -ne 0 ]; do
        if [[ "$1" == "--"* ]]; then
            # already exists
            if __args_already_exists "${1:2}"; then
                >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: option name '${1}' already exists"
                return 1
            fi
            is_flag="true"
            [[ ! "${long_flags[*]:-}" =~ (^|[[:space:]])"${1:2}"($|[[:space:]]) ]] && long_flags+=("${1:2}")
        elif [[ "$1" == "-"* ]]; then
            # size or digit of short
            if [ "${#1}" -ne 2 ] || [[ "$1" =~ ^"-"[[:digit:]]$ ]]; then
                >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: short option name '$1' not valid"
                return 1
            fi
            # already exists
            if __args_already_exists "${1:1}"; then
                >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: option name '${1}' already exists"
                return 1
            fi
            is_flag="true"
            [[ ! "${short_flags[*]:-}" =~ (^|[[:space:]])"${1:1}"($|[[:space:]]) ]] && short_flags+=("${1:1}")
        else
            # multi argument name
            if [ "$is_argument" = "true" ]; then
                >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: you can't have multi argument name"
                return 1
            fi
            # empty argument name
            if [ -z "$1" ]; then
                >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: name of argument is empty"
                return 1
            fi
            # already exists
            if __args_already_exists "$1"; then
                >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: argument name '${1}' already exists"
                return 1
            fi
            is_argument="true"
            argument_name="$1"
        fi
        if [ "$is_argument" = "true" ] && [ "$is_flag" = "true" ]; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: you can't mixte argument and flag(s)"
            return 1
        fi
        shift
    done

    # sort flags
    local max
    max="$((${#long_flags[@]} - 1))"
    local i j tmp
    while [ "$max" -gt 0 ]; do
        i=0
        j=1
        while [ "$i" -lt "$max" ]; do
            if [ -n "${long_flags[$i]}" ] && [ -n "${long_flags[$j]}" ]; then
                if [[ "${long_flags[$i]}" > "${long_flags[$j]}" ]]; then
                    tmp="${long_flags[$i]}"
                    long_flags[$i]="${long_flags[$j]}"
                    long_flags[$j]="$tmp"
                fi
            fi
            i=$((i + 1))
            j=$((j + 1))
        done
        max=$((max - 1))
    done
    max="$((${#short_flags[@]} - 1))"
    while [ "$max" -gt 0 ]; do
        i=0
        j=1
        while [ "$i" -lt "$max" ]; do
            if [ -n "${short_flags[$i]}" ] && [ -n "${short_flags[$j]}" ]; then
                if [[ "${short_flags[$i]}" > "${short_flags[$j]}" ]]; then
                    tmp="${short_flags[$i]}"
                    short_flags[$i]="${short_flags[$j]}"
                    short_flags[$j]="$tmp"
                fi
            fi
            i=$((i + 1))
            j=$((j + 1))
        done
        max=$((max - 1))
    done

    if [ "$is_argument" = "true" ]; then
        __ARGS[argument.${__ARGS[argument.size]}.name]="$argument_name"
        __ARGS[argument.${__ARGS[argument.size]}.help]="$help"
        __ARGS[argument.${__ARGS[argument.size]}.default]="$default"
        __ARGS[argument.${__ARGS[argument.size]}.dest]="$dest"
        __ARGS[argument.${__ARGS[argument.size]}.required]="$required"
        __ARGS[argument.${__ARGS[argument.size]}.exists]="false"
        __ARGS[argument.${__ARGS[argument.size]}.count]=0
        __ARGS[argument.${__ARGS[argument.size]}.choices]="$choices"
        __ARGS[argument.size]=$((${__ARGS[argument.size]} + 1))
    else
        for i in "${!short_flags[@]}"; do
            __ARGS[option.${__ARGS[option.size]}.short.${i}]="${short_flags[$i]}"
        done
        __ARGS[option.${__ARGS[option.size]}.short.size]="${#short_flags[@]}"

        for i in "${!long_flags[@]}"; do
            __ARGS[option.${__ARGS[option.size]}.long.${i}]="${long_flags[$i]}"
        done
        __ARGS[option.${__ARGS[option.size]}.long.size]="${#long_flags[@]}"

        if [ "$action" = "store_false" ]; then
            __ARGS[option.${__ARGS[option.size]}.default]="true"
        elif [ "$action" = "store_true" ]; then
            __ARGS[option.${__ARGS[option.size]}.default]="false"
        else
            __ARGS[option.${__ARGS[option.size]}.default]="$default"
        fi
        __ARGS[option.${__ARGS[option.size]}.action]="$action"
        __ARGS[option.${__ARGS[option.size]}.metavar]="$metavar"
        __ARGS[option.${__ARGS[option.size]}.help]="$help"
        __ARGS[option.${__ARGS[option.size]}.dest]="$dest"
        __ARGS[option.${__ARGS[option.size]}.required]="$required"
        __ARGS[option.${__ARGS[option.size]}.exists]="false"
        __ARGS[option.${__ARGS[option.size]}.count]=0
        __ARGS[option.${__ARGS[option.size]}.choices]="$choices"
        __ARGS[option.${__ARGS[option.size]}.nargs]="$nargs"
        __ARGS[option.size]=$((${__ARGS[option.size]} + 1))
    fi
    return 0
}

# Show all values of arguments and options
args_debug_values() {
    # get column max of options
    local max_col=0
    local key
    local value
    local i
    local j
    local count
    local type
    i=0
    while [ "$i" -lt "${__ARGS[argument.size]}" ]; do
        count="${#__ARGS[argument.${i}.name]}"
        if [ $count -gt $max_col ]; then
            max_col=$count
        fi
        i=$((i + 1))
    done
    i=0
    while [ "$i" -lt "${__ARGS[option.size]}" ]; do
        key=""
        for type in "short" "long"; do
            j=0
            while [ "$j" -lt "${__ARGS[option.${i}.${type}.size]}" ]; do
                [ -n "$key" ] && key+=", "
                [ "$type" = "short" ] && key+="-"
                [ "$type" = "long" ] && key+="--"
                key+="${__ARGS[option.${i}.${type}.${j}]}"
                j=$((j + 1))
            done
        done
        count=$((${#key}))
        if [ $count -gt $max_col ]; then
            max_col=$count
        fi
        i=$((i + 1))
    done

    i=0
    while [ "$i" -lt "${__ARGS[argument.size]}" ]; do
        printf -- "%-*s : %s (count: %s, exists: %s)\n" \
            "$max_col" \
            "${__ARGS[argument.${i}.name]}" \
            "${ARGS[${__ARGS[argument.${i}.name]}]:-}" \
            "${__ARGS[argument.${i}.count]}" \
            "${__ARGS[argument.${i}.exists]}"
        i=$((i + 1))
    done
    i=0
    while [ "$i" -lt "${__ARGS[option.size]}" ]; do
        key=""
        for type in "short" "long"; do
            j=0
            while [ "$j" -lt "${__ARGS[option.${i}.${type}.size]}" ]; do
                [ -n "$key" ] && key+=", "
                [ "$type" = "short" ] && key+="-"
                [ "$type" = "long" ] && key+="--"
                key+="${__ARGS[option.${i}.${type}.${j}]}"
                j=$((j + 1))
            done
        done
        local name=""
        [ "${__ARGS[option.${i}.long.size]}" -ne 0 ] && name="${__ARGS[option.${i}.long.0]}"
        [ "${__ARGS[option.${i}.short.size]}" -ne 0 ] && name="${__ARGS[option.${i}.short.0]}"
        printf -- "%-*s : %s (count: %s, exists: %s)\n" \
            "$max_col" \
            "$key" \
            "${ARGS[$name]:-}" \
            "${__ARGS[option.${i}.count]}" \
            "${__ARGS[option.${i}.exists]}"
        i=$((i + 1))
    done
    return 0
}

# Show/Generate usage message
#   params:
#     $1  Name/Path of script
args_usage() {
    if [ -n "${__ARGS[USAGE]}" ]; then
        echo "${__ARGS[USAGE]}"
    else
        __args_sort
        local i
        local j
        local str
        local max_col="$((__ARGS[USAGE_WIDTH_PADDING] + __ARGS[USAGE_WIDTH_ARGUMENT] + __ARGS[USAGE_WIDTH_SEPARATOR] + __ARGS[USAGE_WIDTH_HELP]))"
        local current_col=0
        local has_max_col=false
        # generate usage message
        if [ -n "${__ARGS[PROG_NAME]}" ]; then
            str="usage: ${__ARGS[PROG_NAME]##*/}"
        else
            str="usage: ${1##*/}"
        fi
        local usage_basename_length="${#str}"
        current_col="$usage_basename_length"
        i=0
        while [ "$i" -lt "${__ARGS[option.size]}" ]; do
            local option=""
            option+=" "
            if [ "false" = "${__ARGS[option.${i}.required]}" ]; then
                option+="["
            fi
            if [ "${__ARGS[option.${i}.short.size]}" -ne 0 ]; then
                option+="-${__ARGS[option.${i}.short.0]}"
            elif [ "${__ARGS[option.${i}.long.size]}" -ne 0 ]; then
                option+="--${__ARGS[option.${i}.long.0]}"
            fi
            if [ "store" = "${__ARGS[option.${i}.action]}" ] || \
               [ "append" = "${__ARGS[option.${i}.action]}" ] || \
               [ "infinite" = "${__ARGS[option.${i}.action]}" ]; then
                option+=" "
                if [ -n "${__ARGS[option.${i}.metavar]}" ]; then
                    option+="${__ARGS[option.${i}.metavar]}"
                else
                    if [ "${__ARGS[option.${i}.long.size]}" -ne 0 ]; then
                        local option_argument="${__ARGS[option.${i}.long.0]^^}"
                        option+="${option_argument//-/_}"
                    else
                        option+="${__ARGS[option.${i}.short.0]^^}"
                    fi
                    if [ "infinite" = "${__ARGS[option.${i}.action]}" ]; then
                        option+="..."
                    fi
                fi
            fi
            if [ "false" = "${__ARGS[option.${i}.required]}" ]; then
                option+="]"
            fi
            if [ "$((current_col + ${#option}))" -gt "$max_col" ]; then
                has_max_col=true
                str+=$'\n'
                j=0
                while [ "$j" -lt "${usage_basename_length}" ]; do
                    str+=" "
                    j=$((j + 1))
                done
                current_col="$usage_basename_length"
            fi
            str+="$option"
            current_col="$((current_col + ${#option}))"
            i=$((i + 1))
        done
        if [ "${__ARGS[argument.size]}" -ne 0 ]; then
            if $has_max_col || [ "$((current_col + 3))" -gt "$max_col" ]; then
                str+=$'\n'
                j=0
                while [ "$j" -lt "${usage_basename_length}" ]; do
                    str+=" "
                    j=$((j + 1))
                done
                str+=" --"
                str+=$'\n'
                j=0
                while [ "$j" -lt "${usage_basename_length}" ]; do
                    str+=" "
                    j=$((j + 1))
                done
                current_col="$usage_basename_length"
            else
                str+=" --"
                current_col="$((current_col + 3))"
            fi
        fi
        i=0
        while [ "$i" -lt "${__ARGS[argument.size]}" ]; do
            local option=""
            option+=" "
            if [ "${__ARGS[argument.${i}.required]}" = "true" ]; then
                option+="${__ARGS[argument.${i}.name]}"
            else
                option+="[${__ARGS[argument.${i}.name]}]"
            fi
            if [ "$((current_col + ${#option}))" -gt "$max_col" ]; then
                has_max_col=true
                str+=$'\n'
                j=0
                while [ "$j" -lt "${usage_basename_length}" ]; do
                    str+=" "
                    j=$((j + 1))
                done
                current_col="$usage_basename_length"
            fi
            str+="$option"
            current_col="$((current_col + ${#option}))"
            i=$((i + 1))
        done
        str+=$'\n'
        if [ -n "${__ARGS[DESCRIPTION]}" ]; then
            str+=$'\n'
            str+="${__ARGS[DESCRIPTION]}"
            str+=$'\n'
        fi
        if [ "${__ARGS[argument.size]}" -ne 0 ]; then
            str+=$'\n'
            str+="positional arguments:"
            str+=$'\n'
        fi
        i=0
        while [ "$i" -lt "${__ARGS[argument.size]}" ]; do
            j=0
            while [ "$j" -lt "${__ARGS[USAGE_WIDTH_PADDING]}" ]; do
                str+=" "
                j=$((j + 1))
            done
            local option=""
            option+="${__ARGS[argument.${i}.name]}"
            str+="$option"
            if [ -n "${__ARGS[argument.${i}.help]}" ]; then
                if [ "${#option}" -gt "${__ARGS[USAGE_WIDTH_ARGUMENT]}" ]; then
                    str+=$'\n'
                    j=0
                    while [ "$j" -lt "$((__ARGS[USAGE_WIDTH_PADDING] + __ARGS[USAGE_WIDTH_ARGUMENT] + __ARGS[USAGE_WIDTH_SEPARATOR] - 1))" ]; do
                        str+=" "
                        j=$((j + 1))
                    done
                else
                    j=0
                    while [ "$j" -lt "$((__ARGS[USAGE_WIDTH_ARGUMENT] - ${#option} + __ARGS[USAGE_WIDTH_SEPARATOR] - 1))" ]; do
                        str+=" "
                        j=$((j + 1))
                    done
                fi
                current_col="$((__ARGS[USAGE_WIDTH_PADDING] + __ARGS[USAGE_WIDTH_ARGUMENT] + __ARGS[USAGE_WIDTH_SEPARATOR] - 1))"
                local word=""
                for word in ${__ARGS[argument.${i}.help]}; do
                    if [ "$((current_col + ${#word} + 1))" -gt "$((__ARGS[USAGE_WIDTH_PADDING] + __ARGS[USAGE_WIDTH_ARGUMENT] + __ARGS[USAGE_WIDTH_SEPARATOR] + __ARGS[USAGE_WIDTH_HELP]))" ]; then
                        str+=$'\n'
                        j=0
                        while [ "$j" -lt "$((__ARGS[USAGE_WIDTH_PADDING] + __ARGS[USAGE_WIDTH_ARGUMENT] + __ARGS[USAGE_WIDTH_SEPARATOR] - 1))" ]; do
                            str+=" "
                            j=$((j + 1))
                        done
                        current_col="$((__ARGS[USAGE_WIDTH_PADDING] + __ARGS[USAGE_WIDTH_ARGUMENT] + __ARGS[USAGE_WIDTH_SEPARATOR] - 1))"
                    fi
                    str+=" $word"
                    current_col="$((current_col + ${#word} + 1))"
                done
            fi
            str+=$'\n'
            i=$((i + 1))
        done
        if [ "${__ARGS[option.size]}" -ne 0 ]; then
            str+=$'\n'
            str+="optional arguments:"
            str+=$'\n'
        fi
        i=0
        while [ "$i" -lt "${__ARGS[option.size]}" ]; do
            j=0
            while [ "$j" -lt "${__ARGS[USAGE_WIDTH_PADDING]}" ]; do
                str+=" "
                j=$((j + 1))
            done
            local option=""
            local type
            for type in "short" "long"; do
                j=0
                while [ "$j" -lt "${__ARGS[option.${i}.${type}.size]}" ]; do
                    [ -n "$option" ] && option+=", "
                    [ "$type" = "short" ] && option+="-"
                    [ "$type" = "long" ] && option+="--"
                    option+="${__ARGS[option.${i}.${type}.${j}]}"
                    j=$((j + 1))
                done
            done

            if [ "store" = "${__ARGS[option.${i}.action]}" ] || \
               [ "append" = "${__ARGS[option.${i}.action]}" ] || \
               [ "infinite" = "${__ARGS[option.${i}.action]}" ]; then
                option+=" "
                if [ -n "${__ARGS[option.${i}.metavar]}" ]; then
                    option+="${__ARGS[option.${i}.metavar]}"
                else
                    if [ "${__ARGS[option.${i}.long.size]}" -ne 0 ]; then
                        local option_argument="${__ARGS[option.${i}.long.0]^^}"
                        option+="${option_argument//-/_}"
                    else
                        option+="${__ARGS[option.${i}.short.0]^^}"
                    fi
                    if [ "infinite" = "${__ARGS[option.${i}.action]}" ]; then
                        option+="..."
                    fi
                fi
            fi
            str+="$option"

            if [ -n "${__ARGS[option.${i}.help]}" ]; then
                if [ "${#option}" -gt "${__ARGS[USAGE_WIDTH_ARGUMENT]}" ]; then
                    str+=$'\n'
                    j=0
                    while [ "$j" -lt "$((__ARGS[USAGE_WIDTH_PADDING] + __ARGS[USAGE_WIDTH_ARGUMENT] + __ARGS[USAGE_WIDTH_SEPARATOR] - 1))" ]; do
                        str+=" "
                        j=$((j + 1))
                    done
                else
                    j=0
                    while [ "$j" -lt "$((__ARGS[USAGE_WIDTH_ARGUMENT] - ${#option} + __ARGS[USAGE_WIDTH_SEPARATOR] - 1))" ]; do
                        str+=" "
                        j=$((j + 1))
                    done
                fi
                current_col="$((__ARGS[USAGE_WIDTH_PADDING] + __ARGS[USAGE_WIDTH_ARGUMENT] + __ARGS[USAGE_WIDTH_SEPARATOR] - 1))"
                local word=""
                for word in ${__ARGS[option.${i}.help]}; do
                    if [ "$((current_col + ${#word} + 1))" -gt "$((__ARGS[USAGE_WIDTH_PADDING] + __ARGS[USAGE_WIDTH_ARGUMENT] + __ARGS[USAGE_WIDTH_SEPARATOR] + __ARGS[USAGE_WIDTH_HELP]))" ]; then
                        str+=$'\n'
                        j=0
                        while [ "$j" -lt "$((__ARGS[USAGE_WIDTH_PADDING] + __ARGS[USAGE_WIDTH_ARGUMENT] + __ARGS[USAGE_WIDTH_SEPARATOR] - 1))" ]; do
                            str+=" "
                            j=$((j + 1))
                        done
                        current_col="$((__ARGS[USAGE_WIDTH_PADDING] + __ARGS[USAGE_WIDTH_ARGUMENT] + __ARGS[USAGE_WIDTH_SEPARATOR] - 1))"
                    fi
                    str+=" $word"
                    current_col="$((current_col + ${#word} + 1))"
                done
            fi
            str+=$'\n'
            i=$((i + 1))
        done
        if [ -n "${__ARGS[EPILOG]}" ]; then
            str+=$'\n'
            str+="${__ARGS[EPILOG]}"
            str+=$'\n'
        fi
        echo -n "$str"
    fi
    return 0
}

# Use after args_add_argument functions
# Convert argument strings to objects and assign them as attributes on the ARGS map
# Previous calls to args_add_argument
# determine exactly what objects are created and how they are assigned
# Execute this with "$@" parameters
args_parse_arguments() {
    local binary_name="$0"
    local help_options=()
    if ! __args_already_exists "h" && ! __args_already_exists "help"; then
        help_options+=("-h")
        help_options+=("--help")
        args_add_argument --action="store_true" --help="print this help message" -- "-h" "--help"
    elif ! __args_already_exists "h"; then
        help_options+=("-h")
        args_add_argument --action="store_true" --help="print this help message" -- "-h"
    elif ! __args_already_exists "help"; then
        help_options+=("--help")
        args_add_argument --action="store_true" --help="print this help message" -- "--help"
    fi
    local i
    local j
    local positional_index=0
    while true; do
        if [ $# -eq 0 ]; then
            break
        fi
        if [ "$1" = "--" ]; then
            shift
            break
        fi
        for i in "${!help_options[@]}"; do
            if [ "$1" = "${help_options[i]}" ]; then
                args_usage "$binary_name"
                return 64
            fi
        done
        local is_option="false"
        # Get options
        i=0
        while [ "$i" -lt "${__ARGS[option.size]}" ]; do
            if __args_parse_option_is_value "$i" "$1"; then
                if [ "${__ARGS[option.${i}.nargs]}" -gt 1 ]; then
                    local option_name="$1"
                    local nargs=0
                    while [ "$nargs" -lt "${__ARGS[option.${i}.nargs]}" ]; do
                        if [ $# -le 1 ] || [ "--" = "$2" ]; then
                            >&2 echo "$binary_name: option '$option_name' require '${__ARGS[option.${i}.nargs]}' arguments"
                            return 1
                        fi
                        __args_parse_assign_option_multi_values "$i" "$nargs" "$2"
                        nargs=$((nargs + 1))
                        shift
                    done
                    __ARGS[option.${i}.count]=$((${__ARGS[option.${i}.count]} + 1))
                    __ARGS[option.${i}.exists]="true"
                    shift
                elif [ "infinite" = "${__ARGS[option.${i}.action]}" ]; then
                    local option_name="$1"
                    while true; do
                        if [ $# -le 1 ] || [ "--" = "$2" ] || [[ "$2" =~ ^"-"[[:alpha:]] ]] || [[ "$2" =~ ^"--"[[:alpha:]] ]]; then
                            break
                        fi
                        __args_parse_assign_option_multi_values "$i" "${__ARGS[option.${i}.count]}" "$2"
                        __ARGS[option.${i}.count]=$((${__ARGS[option.${i}.count]} + 1))
                        shift
                    done
                    __ARGS[option.${i}.exists]="true"
                    shift
                elif [ "append" = "${__ARGS[option.${i}.action]}" ]; then
                    local value=""
                    if [ $# -le 1 ] || [ "--" = "$2" ]; then
                        >&2 echo "$binary_name: option '$1' require a argument"
                        return 1
                    fi
                    value="$2"
                    if [ -n "${__ARGS[option.${i}.choices]}" ] && [[ ! "${__ARGS[option.${i}.choices]}" =~ (^|[[:space:]])"$value"($|[[:space:]]) ]]; then
                        >&2 echo "$binary_name: option '$value' is not a valid choise (${__ARGS[option.${i}.choices]// /, })"
                        return 1
                    fi
                    shift
                    __args_parse_assign_option_multi_values "$i" "${__ARGS[option.${i}.count]}" "$2"
                    __ARGS[option.${i}.count]=$((${__ARGS[option.${i}.count]} + 1))
                    __ARGS[option.${i}.exists]="true"
                    shift
                else
                    local value=""
                    if [ "store" = "${__ARGS[option.${i}.action]}" ]; then
                        if [ $# -le 1 ] || [ "--" = "$2" ]; then
                            >&2 echo "$binary_name: option '$1' require a argument"
                            return 1
                        fi
                        value="$2"
                        if [ -n "${__ARGS[option.${i}.choices]}" ] && [[ ! "${__ARGS[option.${i}.choices]}" =~ (^|[[:space:]])"$value"($|[[:space:]]) ]]; then
                            >&2 echo "$binary_name: option '$value' is not a valid choise (${__ARGS[option.${i}.choices]// /, })"
                            return 1
                        fi
                        shift
                    elif [ "store_true" = "${__ARGS[option.${i}.action]}" ]; then
                        value="true"
                    elif [ "store_false" = "${__ARGS[option.${i}.action]}" ]; then
                        value="false"
                    elif [ "count" = "${__ARGS[option.${i}.action]}" ]; then
                        value=$((${__ARGS[option.${i}.count]} + 1))
                    fi
                    __args_parse_assign_option_value "$i" "$value"
                    __ARGS[option.${i}.count]=$((${__ARGS[option.${i}.count]} + 1))
                    __ARGS[option.${i}.exists]="true"
                    shift
                fi
                is_option="true"
                break
            elif __args_parse_option_is_assign_value "$i" "$1"; then
                if [ "store" = "${__ARGS[option.${i}.action]}" ] || [ "append" = "${__ARGS[option.${i}.action]}" ]; then
                    local value=""
                    value="${1#*=}"
                    if [ -n "${__ARGS[option.${i}.choices]}" ] && [[ ! "${__ARGS[option.${i}.choices]}" =~ (^|[[:space:]])"$value"($|[[:space:]]) ]]; then
                        >&2 echo "$binary_name: option '$value' is not a valid choise (${__ARGS[option.${i}.choices]// /, })"
                        return 1
                    fi
                    if [ "append" = "${__ARGS[option.${i}.action]}" ]; then
                        __args_parse_assign_option_multi_values "$i" "${__ARGS[option.${i}.count]}" "$value"
                    else
                        __args_parse_assign_option_value "$i" "$value"
                    fi
                    __ARGS[option.${i}.count]=$((${__ARGS[option.${i}.count]} + 1))
                    __ARGS[option.${i}.exists]="true"
                    shift
                else
                    >&2 echo "$binary_name: option '$1' don't take a argument"
                    return 1
                fi
                is_option="true"
                break
            elif __args_parse_option_is_multi_short_value "$i" "$1"; then
                local value=""
                if [ "store" = "${__ARGS[option.${i}.action]}" ] || [ "append" = "${__ARGS[option.${i}.action]}" ]; then
                    value="${1:2}"
                    if [ -n "${__ARGS[option.${i}.choices]}" ] && [[ ! "${__ARGS[option.${i}.choices]}" =~ (^|[[:space:]])"$value"($|[[:space:]]) ]]; then
                        >&2 echo "$binary_name: option '$value' is not a valid choise (${__ARGS[option.${i}.choices]// /, })"
                        return 1
                    fi
                    if [ "append" = "${__ARGS[option.${i}.action]}" ]; then
                        __args_parse_assign_option_multi_values "$i" "${__ARGS[option.${i}.count]}" "$value"
                    else
                        __args_parse_assign_option_value "$i" "$value"
                    fi
                    __ARGS[option.${i}.count]=$((${__ARGS[option.${i}.count]} + 1))
                    __ARGS[option.${i}.exists]="true"
                else
                    value="$1"
                    local i_short
                    local value_short
                    while [ ${#value} -ge 1 ]; do
                        value="${value:1}"
                        value_short="${value:0:1}"
                        # Get options
                        i_short=0
                        while [ "$i_short" -lt "${__ARGS[option.size]}" ]; do
                            if __args_parse_option_on_multi_short_value "$i_short" "$value_short"; then
                                if [ "store_true" = "${__ARGS[option.${i_short}.action]}" ]; then
                                    value_short="true"
                                elif [ "store_false" = "${__ARGS[option.${i_short}.action]}" ]; then
                                    value_short="false"
                                elif [ "count" = "${__ARGS[option.${i_short}.action]}" ]; then
                                    value_short=$((${__ARGS[option.${i_short}.count]} + 1))
                                else
                                    if [ ${#value} -gt 1 ]; then
                                        value_short="${value:1}"
                                        value=""
                                        if [ -n "${__ARGS[option.${i_short}.choices]}" ] && [[ ! "${__ARGS[option.${i_short}.choices]}" =~ (^|[[:space:]])"$value_short"($|[[:space:]]) ]]; then
                                            >&2 echo "$binary_name: option '-$value_short' is not a valid choise (${__ARGS[option.${i_short}.choices]// /, })"
                                            return 1
                                        fi
                                    elif [ $# -gt 1 ] && [[ "$2" != "--" ]]; then
                                        value_short="$2"
                                        value=""
                                        if [ -n "${__ARGS[option.${i_short}.choices]}" ] && [[ ! "${__ARGS[option.${i_short}.choices]}" =~ (^|[[:space:]])"$value_short"($|[[:space:]]) ]]; then
                                            >&2 echo "$binary_name: option '-$value_short' is not a valid choise (${__ARGS[option.${i_short}.choices]// /, })"
                                            return 1
                                        fi
                                        shift
                                    else
                                        >&2 echo "$binary_name: option '-$value_short' require a argument"
                                        return 1
                                    fi
                                fi
                                if [ "append" = "${__ARGS[option.${i_short}.action]}" ]; then
                                    __args_parse_assign_option_multi_values "$i_short" "${__ARGS[option.${i_short}.count]}" "$value_short"
                                else
                                    __args_parse_assign_option_value "$i_short" "$value_short"
                                fi
                                __ARGS[option.${i_short}.count]=$((${__ARGS[option.${i_short}.count]} + 1))
                                __ARGS[option.${i_short}.exists]="true"
                                break
                            fi
                            i_short=$((i_short + 1))
                        done
                    done
                fi
                shift
                is_option="true"
                break
            fi
            i=$((i + 1))
        done
        if [ "$is_option" = "false" ]; then
            if [[ "$1" = "--"* ]]; then
                >&2 echo "$binary_name: invalid option -- '$1'"
                return 1
            elif [[ "$1" = "-"* ]]; then
                >&2 echo "$binary_name: invalid option -- '${1:0:2}'"
                return 1
            fi
            if [ "$positional_index" -lt "${__ARGS[argument.size]}" ]; then
                if [ -n "${__ARGS[argument.$positional_index.choices]}" ] && [[ ! "${__ARGS[argument.$positional_index.choices]}" =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
                    >&2 echo "$binary_name: argument '$1' is not a valid choise (${__ARGS[argument.$positional_index.choices]// /, })"
                    return 1
                fi
                ARGS[${__ARGS[argument.$positional_index.name]}]="$1"
                __ARGS[argument.$positional_index.count]=$((${__ARGS[argument.$positional_index.count]} + 1))
                __ARGS[argument.$positional_index.exists]="true"
                positional_index=$((positional_index + 1))
                shift
            else
                >&2 echo "$binary_name: extra argument(s) '$*'"
                return 1
            fi
        fi
    done
    # Get arguments
    if [ $# -gt 0 ]; then
        while [ "$positional_index" -lt "${__ARGS[argument.size]}" ]; do
            if [ -n "${__ARGS[argument.$positional_index.choices]}" ] && [[ ! "${__ARGS[argument.$positional_index.choices]}" =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
                >&2 echo "$binary_name: argument '$1' is not a valid choise (${__ARGS[argument.${j}.choices]// /, })"
                return 1
            fi
            ARGS[${__ARGS[argument.$positional_index.name]}]="$1"
            __ARGS[argument.$positional_index.count]=$((${__ARGS[argument.$positional_index.count]} + 1))
            __ARGS[argument.$positional_index.exists]="true"
            positional_index=$((positional_index + 1))
            shift
            if [ $# -eq 0 ]; then
                break
            fi
        done
    fi
    if [ $# -ne 0 ]; then
        >&2 echo "$binary_name: extra argument(s) '$*'"
        return 1
    fi
    # Required
    i=0
    while [ "$i" -lt "${__ARGS[option.size]}" ]; do
        if [ "${__ARGS[option.${i}.required]}" = "true" ]; then
            local name=""
            [ "${__ARGS[option.${i}.long.size]}" -ne 0 ] && name="${__ARGS[option.${i}.long.0]}"
            [ "${__ARGS[option.${i}.short.size]}" -ne 0 ] && name="${__ARGS[option.${i}.short.0]}"
            if [ ! "${ARGS[$name]+abracadabra}" ]; then
                [ "${__ARGS[option.${i}.long.size]}" -ne 0 ] && name="--$name"
                [ "${__ARGS[option.${i}.short.size]}" -ne 0 ] && name="-$name"
                >&2 echo "$binary_name: option '$name' is required"
                return 1
            fi
        fi
        i=$((i + 1))
    done
    i=0
    while [ "$i" -lt "${__ARGS[argument.size]}" ]; do
        if [ "${__ARGS[argument.${i}.required]}" = "true" ]; then
            if [ ! "${ARGS[${__ARGS[argument.${i}.name]}]+abracadabra}" ]; then
                >&2 echo "$binary_name: argument '${__ARGS[argument.${i}.name]}' is required"
                return 1
            fi
        fi
        i=$((i + 1))
    done
    # Default
    i=0
    while [ "$i" -lt "${__ARGS[argument.size]}" ]; do
        if [ ! "${ARGS[${__ARGS[argument.${i}.name]}]+abracadabra}" ]; then
            if [ -n "${__ARGS[argument.${i}.default]}" ]; then
                local name=""
                name="${__ARGS[argument.${i}.name]}"
                ARGS[$name]="${__ARGS[argument.${i}.default]}"
            fi
        fi
        i=$((i + 1))
    done
    i=0
    while [ "$i" -lt "${__ARGS[option.size]}" ]; do
        local name=""
        [ "${__ARGS[option.${i}.long.size]}" -ne 0 ] && name="${__ARGS[option.${i}.long.0]}"
        [ "${__ARGS[option.${i}.short.size]}" -ne 0 ] && name="${__ARGS[option.${i}.short.0]}"
        if [ ! "${ARGS[${name}]+abracadabra}" ] && [ -n "${__ARGS[option.${i}.default]}" ]; then
            if [ "${__ARGS[option.${i}.nargs]}" -gt 1 ] || \
               [ "infinite" = "${__ARGS[option.${i}.action]}" ] || \
               [ "append" = "${__ARGS[option.${i}.action]}" ]; then
                local index_default=0
                local value_default
                for value_default in ${__ARGS[option.${i}.default]}; do
                    __args_parse_assign_option_multi_values "$i" "$index_default" "$value_default"
                    index_default=$((index_default + 1))
                done
                if [ "infinite" = "${__ARGS[option.${i}.action]}" ] || \
                    [ "append" = "${__ARGS[option.${i}.action]}" ]; then
                    __ARGS[option.${i}.count]="$index_default"
                fi
            else
                if [ "count" = "${__ARGS[option.${i}.action]}" ]; then
                    __args_parse_assign_option_value "$i" "0"
                fi
                if [ -n "${__ARGS[option.${i}.default]}" ]; then
                    __args_parse_assign_option_value "$i" "${__ARGS[option.${i}.default]}"
                fi
            fi
        fi
        i=$((i + 1))
    done
    # Dest
    i=0
    while [ "$i" -lt "${__ARGS[option.size]}" ]; do
        if [ -n "${__ARGS[option.${i}.dest]}" ]; then
            if [ "${__ARGS[option.${i}.nargs]}" -gt 1 ] || \
               [ "infinite" = "${__ARGS[option.${i}.action]}" ] || \
               [ "append" = "${__ARGS[option.${i}.action]}" ]; then
                declare -a -g "${__ARGS[option.${i}.dest]}=()"
                local nargs=0
                local nargs_max
                if [ "infinite" = "${__ARGS[option.${i}.action]}" ] || \
                   [ "append" = "${__ARGS[option.${i}.action]}" ]; then
                    nargs_max="${__ARGS[option.${i}.count]}"
                else
                    nargs_max="${__ARGS[option.${i}.nargs]}"
                fi
                while [ "$nargs" -lt "$nargs_max" ]; do
                    local name=""
                    [ "${__ARGS[option.${i}.long.size]}" -ne 0 ] && name="${__ARGS[option.${i}.long.0]}"
                    [ "${__ARGS[option.${i}.short.size]}" -ne 0 ] && name="${__ARGS[option.${i}.short.0]}"
                    declare -a -g "${__ARGS[option.${i}.dest]}+=('${ARGS[${name}.${nargs}]:-}')"
                    nargs=$((nargs + 1))
                done
            else
                local name=""
                [ "${__ARGS[option.${i}.long.size]}" -ne 0 ] && name="${__ARGS[option.${i}.long.0]}"
                [ "${__ARGS[option.${i}.short.size]}" -ne 0 ] && name="${__ARGS[option.${i}.short.0]}"
                declare -a -g "${__ARGS[option.${i}.dest]}+=('${ARGS[${name}]:-}')"
            fi
        fi
        i=$((i + 1))
    done
    i=0
    while [ "$i" -lt "${__ARGS[argument.size]}" ]; do
        if [ -n "${__ARGS[argument.${i}.dest]}" ]; then
            declare -g "${__ARGS[argument.${i}.dest]}=${ARGS[${__ARGS[argument.${i}.name]}]:-}"
        fi
        i=$((i + 1))
    done
    return 0
}

# Clean argparser global vairables at source
args_clean
