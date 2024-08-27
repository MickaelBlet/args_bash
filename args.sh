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

# options
__ARGS_USAGE=""
__ARGS_DESCRIPTION=""
__ARGS_EPILOG=""
__ARGS_USAGE_WIDTHS=()

__ARGS_ARGUMENT_NAME=()
__ARGS_ARGUMENT_HELP=()
__ARGS_ARGUMENT_DEFAULT=()
__ARGS_ARGUMENT_DEST=()
__ARGS_ARGUMENT_REQUIRED=()
__ARGS_ARGUMENT_ISEXSISTS=()
__ARGS_ARGUMENT_COUNT=()

__ARGS_OPTION_ACTION=()
__ARGS_OPTION_SHORT_0=()
__ARGS_OPTION_SHORT_1=()
__ARGS_OPTION_SHORT_2=()
__ARGS_OPTION_SHORT_3=()
__ARGS_OPTION_SHORT_4=()
__ARGS_OPTION_SHORT_5=()
__ARGS_OPTION_SHORT_6=()
__ARGS_OPTION_SHORT_7=()
__ARGS_OPTION_SHORT_8=()
__ARGS_OPTION_SHORT_9=()
__ARGS_OPTION_LONG_0=()
__ARGS_OPTION_LONG_1=()
__ARGS_OPTION_LONG_2=()
__ARGS_OPTION_LONG_3=()
__ARGS_OPTION_LONG_4=()
__ARGS_OPTION_LONG_5=()
__ARGS_OPTION_LONG_6=()
__ARGS_OPTION_LONG_7=()
__ARGS_OPTION_LONG_8=()
__ARGS_OPTION_LONG_9=()
__ARGS_OPTION_METAVAR=()
__ARGS_OPTION_HELP=()
__ARGS_OPTION_DEFAULT=()
__ARGS_OPTION_DEST=()
__ARGS_OPTION_REQUIRED=()
__ARGS_OPTION_ISEXSISTS=()
__ARGS_OPTION_COUNT=()

# Clean all map and array for recalled
args_clean() {
    ARGS=()

    __ARGS_USAGE=""
    __ARGS_DESCRIPTION=""
    __ARGS_EPILOG=""
    __ARGS_USAGE_WIDTHS=(2 20 2 56)

    __ARGS_ARGUMENT_NAME=()
    __ARGS_ARGUMENT_HELP=()
    __ARGS_ARGUMENT_DEFAULT=()
    __ARGS_ARGUMENT_DEST=()
    __ARGS_ARGUMENT_REQUIRED=()

    __ARGS_OPTION_ACTION=()
    __ARGS_OPTION_SHORT_0=()
    __ARGS_OPTION_SHORT_2=()
    __ARGS_OPTION_SHORT_3=()
    __ARGS_OPTION_SHORT_4=()
    __ARGS_OPTION_SHORT_5=()
    __ARGS_OPTION_SHORT_6=()
    __ARGS_OPTION_SHORT_7=()
    __ARGS_OPTION_SHORT_8=()
    __ARGS_OPTION_SHORT_9=()
    __ARGS_OPTION_LONG_0=()
    __ARGS_OPTION_LONG_2=()
    __ARGS_OPTION_LONG_3=()
    __ARGS_OPTION_LONG_4=()
    __ARGS_OPTION_LONG_5=()
    __ARGS_OPTION_LONG_6=()
    __ARGS_OPTION_LONG_7=()
    __ARGS_OPTION_LONG_8=()
    __ARGS_OPTION_LONG_9=()
    __ARGS_OPTION_METAVAR=()
    __ARGS_OPTION_HELP=()
    __ARGS_OPTION_DEFAULT=()
    __ARGS_OPTION_DEST=()
    __ARGS_OPTION_REQUIRED=()
    return 0
}

__args_already_exists() {
    local argument_name
    for argument_name in "${__ARGS_ARGUMENT_NAME[@]:-}" \
                         "${__ARGS_OPTION_SHORT_0[@]:-}" \
                         "${__ARGS_OPTION_SHORT_1[@]:-}" \
                         "${__ARGS_OPTION_SHORT_2[@]:-}" \
                         "${__ARGS_OPTION_SHORT_3[@]:-}" \
                         "${__ARGS_OPTION_SHORT_4[@]:-}" \
                         "${__ARGS_OPTION_SHORT_5[@]:-}" \
                         "${__ARGS_OPTION_SHORT_6[@]:-}" \
                         "${__ARGS_OPTION_SHORT_7[@]:-}" \
                         "${__ARGS_OPTION_SHORT_8[@]:-}" \
                         "${__ARGS_OPTION_SHORT_9[@]:-}" \
                         "${__ARGS_OPTION_LONG_0[@]:-}" \
                         "${__ARGS_OPTION_LONG_1[@]:-}" \
                         "${__ARGS_OPTION_LONG_2[@]:-}" \
                         "${__ARGS_OPTION_LONG_3[@]:-}" \
                         "${__ARGS_OPTION_LONG_4[@]:-}" \
                         "${__ARGS_OPTION_LONG_5[@]:-}" \
                         "${__ARGS_OPTION_LONG_6[@]:-}" \
                         "${__ARGS_OPTION_LONG_7[@]:-}" \
                         "${__ARGS_OPTION_LONG_8[@]:-}" \
                         "${__ARGS_OPTION_LONG_9[@]:-}"; do
        if [ "$1" = "$argument_name" ]; then
            return 0;
        fi
    done
    return 1;
}

# Sort by asc optional arguments
__args_swap_options() {
    local type="${__ARGS_OPTION_ACTION[$1]}"
    local short_0="${__ARGS_OPTION_SHORT_0[$1]}"
    local short_1="${__ARGS_OPTION_SHORT_1[$1]}"
    local short_2="${__ARGS_OPTION_SHORT_2[$1]}"
    local short_3="${__ARGS_OPTION_SHORT_3[$1]}"
    local short_4="${__ARGS_OPTION_SHORT_4[$1]}"
    local short_5="${__ARGS_OPTION_SHORT_5[$1]}"
    local short_6="${__ARGS_OPTION_SHORT_6[$1]}"
    local short_7="${__ARGS_OPTION_SHORT_7[$1]}"
    local short_8="${__ARGS_OPTION_SHORT_8[$1]}"
    local short_9="${__ARGS_OPTION_SHORT_9[$1]}"
    local long_0="${__ARGS_OPTION_LONG_0[$1]}"
    local long_1="${__ARGS_OPTION_LONG_1[$1]}"
    local long_2="${__ARGS_OPTION_LONG_2[$1]}"
    local long_3="${__ARGS_OPTION_LONG_3[$1]}"
    local long_4="${__ARGS_OPTION_LONG_4[$1]}"
    local long_5="${__ARGS_OPTION_LONG_5[$1]}"
    local long_6="${__ARGS_OPTION_LONG_6[$1]}"
    local long_7="${__ARGS_OPTION_LONG_7[$1]}"
    local long_8="${__ARGS_OPTION_LONG_8[$1]}"
    local long_9="${__ARGS_OPTION_LONG_9[$1]}"
    local metavar="${__ARGS_OPTION_METAVAR[$1]}"
    local help="${__ARGS_OPTION_HELP[$1]}"
    local default="${__ARGS_OPTION_DEFAULT[$1]}"
    local dest="${__ARGS_OPTION_DEST[$1]}"
    local required="${__ARGS_OPTION_REQUIRED[$1]}"
    __ARGS_OPTION_ACTION[$1]="${__ARGS_OPTION_ACTION[$2]}"
    __ARGS_OPTION_SHORT_0[$1]="${__ARGS_OPTION_SHORT_0[$2]}"
    __ARGS_OPTION_SHORT_1[$1]="${__ARGS_OPTION_SHORT_1[$2]}"
    __ARGS_OPTION_SHORT_2[$1]="${__ARGS_OPTION_SHORT_2[$2]}"
    __ARGS_OPTION_SHORT_3[$1]="${__ARGS_OPTION_SHORT_3[$2]}"
    __ARGS_OPTION_SHORT_4[$1]="${__ARGS_OPTION_SHORT_4[$2]}"
    __ARGS_OPTION_SHORT_5[$1]="${__ARGS_OPTION_SHORT_5[$2]}"
    __ARGS_OPTION_SHORT_6[$1]="${__ARGS_OPTION_SHORT_6[$2]}"
    __ARGS_OPTION_SHORT_7[$1]="${__ARGS_OPTION_SHORT_7[$2]}"
    __ARGS_OPTION_SHORT_8[$1]="${__ARGS_OPTION_SHORT_8[$2]}"
    __ARGS_OPTION_SHORT_9[$1]="${__ARGS_OPTION_SHORT_9[$2]}"
    __ARGS_OPTION_LONG_0[$1]="${__ARGS_OPTION_LONG_0[$2]}"
    __ARGS_OPTION_LONG_1[$1]="${__ARGS_OPTION_LONG_1[$2]}"
    __ARGS_OPTION_LONG_2[$1]="${__ARGS_OPTION_LONG_2[$2]}"
    __ARGS_OPTION_LONG_3[$1]="${__ARGS_OPTION_LONG_3[$2]}"
    __ARGS_OPTION_LONG_4[$1]="${__ARGS_OPTION_LONG_4[$2]}"
    __ARGS_OPTION_LONG_5[$1]="${__ARGS_OPTION_LONG_5[$2]}"
    __ARGS_OPTION_LONG_6[$1]="${__ARGS_OPTION_LONG_6[$2]}"
    __ARGS_OPTION_LONG_7[$1]="${__ARGS_OPTION_LONG_7[$2]}"
    __ARGS_OPTION_LONG_8[$1]="${__ARGS_OPTION_LONG_8[$2]}"
    __ARGS_OPTION_LONG_9[$1]="${__ARGS_OPTION_LONG_9[$2]}"
    __ARGS_OPTION_METAVAR[$1]="${__ARGS_OPTION_METAVAR[$2]}"
    __ARGS_OPTION_HELP[$1]="${__ARGS_OPTION_HELP[$2]}"
    __ARGS_OPTION_DEFAULT[$1]="${__ARGS_OPTION_DEFAULT[$2]}"
    __ARGS_OPTION_DEST[$1]="${__ARGS_OPTION_DEST[$2]}"
    __ARGS_OPTION_REQUIRED[$1]="${__ARGS_OPTION_REQUIRED[$2]}"
    __ARGS_OPTION_ACTION[$2]="$type"
    __ARGS_OPTION_SHORT_0[$2]="$short_0"
    __ARGS_OPTION_SHORT_2[$2]="$short_1"
    __ARGS_OPTION_SHORT_2[$2]="$short_2"
    __ARGS_OPTION_SHORT_3[$2]="$short_3"
    __ARGS_OPTION_SHORT_4[$2]="$short_4"
    __ARGS_OPTION_SHORT_5[$2]="$short_5"
    __ARGS_OPTION_SHORT_6[$2]="$short_6"
    __ARGS_OPTION_SHORT_7[$2]="$short_7"
    __ARGS_OPTION_SHORT_8[$2]="$short_8"
    __ARGS_OPTION_SHORT_9[$2]="$short_9"
    __ARGS_OPTION_LONG_0[$2]="$long_0"
    __ARGS_OPTION_LONG_1[$2]="$long_1"
    __ARGS_OPTION_LONG_2[$2]="$long_2"
    __ARGS_OPTION_LONG_3[$2]="$long_3"
    __ARGS_OPTION_LONG_4[$2]="$long_4"
    __ARGS_OPTION_LONG_5[$2]="$long_5"
    __ARGS_OPTION_LONG_6[$2]="$long_6"
    __ARGS_OPTION_LONG_7[$2]="$long_7"
    __ARGS_OPTION_LONG_8[$2]="$long_8"
    __ARGS_OPTION_LONG_9[$2]="$long_9"
    __ARGS_OPTION_METAVAR[$2]="$metavar"
    __ARGS_OPTION_HELP[$2]="$help"
    __ARGS_OPTION_DEFAULT[$2]="$default"
    __ARGS_OPTION_DEST[$2]="$dest"
    __ARGS_OPTION_REQUIRED[$2]="$required"
    return 0
}

# Sort by asc optional arguments
__args_sort() {
    local max
    max="$((${#__ARGS_OPTION_ACTION[@]} - 1))"
    local i j
    while [ "$max" -gt 0 ]; do
        i=0
        j=1
        while [ "$i" -lt "$max" ]; do
            if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ] && [ -n "${__ARGS_OPTION_SHORT_0[$j]}" ]; then
                if ! ${__ARGS_OPTION_REQUIRED[$i]} && ${__ARGS_OPTION_REQUIRED[$j]}; then
                    __args_swap_options "$i" "$j"
                elif ! ${__ARGS_OPTION_REQUIRED[$i]} && [[ "${__ARGS_OPTION_SHORT_0[$i]}" > "${__ARGS_OPTION_SHORT_0[$j]}" ]]; then
                    __args_swap_options "$i" "$j"
                fi
            elif [ -z "${__ARGS_OPTION_SHORT_0[$i]}" ] && [ -z "${__ARGS_OPTION_SHORT_0[$j]}" ] && [ -n "${__ARGS_OPTION_LONG_0[$i]}" ] && [ -n "${__ARGS_OPTION_LONG_0[$((i + 1))]}" ]; then
                if ! ${__ARGS_OPTION_REQUIRED[$i]} && ${__ARGS_OPTION_REQUIRED[$j]}; then
                    __args_swap_options "$i" "$j"
                elif ! ${__ARGS_OPTION_REQUIRED[$i]} && [[ "${__ARGS_OPTION_LONG_0[$i]}" > "${__ARGS_OPTION_LONG_0[$j]}" ]]; then
                    __args_swap_options "$i" "$j"
                fi
            elif [ -z "${__ARGS_OPTION_SHORT_0[$i]}" ]; then
                __args_swap_options "$i" "$j"
            fi
            i=$((i + 1))
            j=$((j + 1))
        done
        max=$((max - 1))
    done
    return 0
}

__args_parse_assign_option_value() {
    local index="$1"
    local value="$2"
    [ -n "${__ARGS_OPTION_SHORT_0[$index]}" ] && ARGS[${__ARGS_OPTION_SHORT_0[$index]}]="$value"
    [ -n "${__ARGS_OPTION_SHORT_1[$index]}" ] && ARGS[${__ARGS_OPTION_SHORT_1[$index]}]="$value"
    [ -n "${__ARGS_OPTION_SHORT_2[$index]}" ] && ARGS[${__ARGS_OPTION_SHORT_2[$index]}]="$value"
    [ -n "${__ARGS_OPTION_SHORT_3[$index]}" ] && ARGS[${__ARGS_OPTION_SHORT_3[$index]}]="$value"
    [ -n "${__ARGS_OPTION_SHORT_4[$index]}" ] && ARGS[${__ARGS_OPTION_SHORT_4[$index]}]="$value"
    [ -n "${__ARGS_OPTION_SHORT_5[$index]}" ] && ARGS[${__ARGS_OPTION_SHORT_5[$index]}]="$value"
    [ -n "${__ARGS_OPTION_SHORT_6[$index]}" ] && ARGS[${__ARGS_OPTION_SHORT_6[$index]}]="$value"
    [ -n "${__ARGS_OPTION_SHORT_7[$index]}" ] && ARGS[${__ARGS_OPTION_SHORT_7[$index]}]="$value"
    [ -n "${__ARGS_OPTION_SHORT_8[$index]}" ] && ARGS[${__ARGS_OPTION_SHORT_8[$index]}]="$value"
    [ -n "${__ARGS_OPTION_SHORT_9[$index]}" ] && ARGS[${__ARGS_OPTION_SHORT_9[$index]}]="$value"
    [ -n "${__ARGS_OPTION_LONG_0[$index]}" ] && ARGS[${__ARGS_OPTION_LONG_0[$index]}]="$value"
    [ -n "${__ARGS_OPTION_LONG_1[$index]}" ] && ARGS[${__ARGS_OPTION_LONG_1[$index]}]="$value"
    [ -n "${__ARGS_OPTION_LONG_2[$index]}" ] && ARGS[${__ARGS_OPTION_LONG_2[$index]}]="$value"
    [ -n "${__ARGS_OPTION_LONG_3[$index]}" ] && ARGS[${__ARGS_OPTION_LONG_3[$index]}]="$value"
    [ -n "${__ARGS_OPTION_LONG_4[$index]}" ] && ARGS[${__ARGS_OPTION_LONG_4[$index]}]="$value"
    [ -n "${__ARGS_OPTION_LONG_5[$index]}" ] && ARGS[${__ARGS_OPTION_LONG_5[$index]}]="$value"
    [ -n "${__ARGS_OPTION_LONG_6[$index]}" ] && ARGS[${__ARGS_OPTION_LONG_6[$index]}]="$value"
    [ -n "${__ARGS_OPTION_LONG_7[$index]}" ] && ARGS[${__ARGS_OPTION_LONG_7[$index]}]="$value"
    [ -n "${__ARGS_OPTION_LONG_8[$index]}" ] && ARGS[${__ARGS_OPTION_LONG_8[$index]}]="$value"
    [ -n "${__ARGS_OPTION_LONG_9[$index]}" ] && ARGS[${__ARGS_OPTION_LONG_9[$index]}]="$value"
    return 0
}

# Set a usage description
args_set_description() {
    __ARGS_DESCRIPTION="$*"
}

# Set a epilog description
#   params:
#     $*  Concat all arguments
#   example:
#     args_set_epilog "Your epilog " "message"
args_set_epilog() {
    __ARGS_EPILOG="$*"
}

# Set a full usage message
#   example:
#     args_set_usage "Your usage " "message"
args_set_usage() {
    __ARGS_USAGE="$*"
}

# Set the widths of usage message
#   params:
#     $1  Padding
#     $2  Argument
#     $3  Separator
#     $4  Help
args_set_usage_widths() {
    __ARGS_USAGE_WIDTHS=("$1" "$2" "$3" "$4")
}

# Check if argument is exists in argv
#   param:
#     $1  Argument name
args_isexists() {
    local name
    if [[ "$1" == "--"* ]]; then
        name="${1:2}"
    elif [[ "$1" == "-"* ]]; then
        name="${1:1}"
    else
        name="$1"
    fi
    local i
    for i in "${!__ARGS_ARGUMENT_NAME[@]}"; do
        if [ "$name" = "${__ARGS_ARGUMENT_NAME[$i]}" ]; then
            if [ "${__ARGS_ARGUMENT_ISEXSISTS[$i]}" = "true" ]; then
                return 0
            else
                return 1
            fi
        fi
    done
    for i in "${!__ARGS_OPTION_ACTION[@]}"; do
        if [ "$name" = "${__ARGS_OPTION_SHORT_0[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_1[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_2[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_3[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_4[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_5[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_6[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_7[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_8[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_9[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_0[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_1[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_2[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_3[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_4[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_5[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_6[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_7[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_8[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_9[$i]}" ]; then
            if [ "${__ARGS_OPTION_ISEXSISTS[$i]}" = "true" ]; then
                return 0
            else
                return 1
            fi
        fi
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
    local i
    for i in "${!__ARGS_ARGUMENT_NAME[@]}"; do
        if [ "$name" = "${__ARGS_ARGUMENT_NAME[$i]}" ]; then
            echo "${__ARGS_ARGUMENT_COUNT[$i]}"
            return 0
        fi
    done
    for i in "${!__ARGS_OPTION_ACTION[@]}"; do
        if [ "$name" = "${__ARGS_OPTION_SHORT_0[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_1[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_2[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_3[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_4[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_5[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_6[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_7[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_8[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_SHORT_9[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_0[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_1[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_2[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_3[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_4[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_5[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_6[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_7[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_8[$i]}" ] || \
           [ "$name" = "${__ARGS_OPTION_LONG_9[$i]}" ]; then
            echo "${__ARGS_OPTION_COUNT[$i]}"
            return 0
        fi
    done
    >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '$1' is not a valid argument name"
    return 1
}

# Add a argument
#   option params:
#     --action    Action (store, store_true, store_false)
#     --default   Default value
#     --dest      Destination variable
#     --help      Usage helper
#     --metavar   Usage argument name (if not set use long/short name)
#     --required  Is required if exists
#   example:
#     args_add_argument --help="help of FOO" --dest="FOO" -- "FOO"
args_add_argument() {
    local actions=()
    actions=(
        "store"
        "store_true"
        "store_false"
        "count"
    )

    local action="store"
    local default=""
    local dest=""
    local help=""
    local metavar=""
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
            "--required")
                required=true
                shift;;
            *)
                >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: unrecognized option '$1'"
                return 1;;
        esac
    done

    # bad format of action
    if [[ "$action" != "store" ]] && \
       [[ "$action" != "store_true" ]] && \
       [[ "$action" != "store_false" ]] && \
       [[ "$action" != "count" ]]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: unknown action '$action'"
        return 1
    fi

    # default and required
    if [ -n "$default" ] && [ "$required" = "true" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--default' used with '--required'"
        return 1
    fi

    # store_true or store_false
    if [[ "$action" != "store" ]]; then
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
            # size of short
            if [ "${#1}" -ne 2 ]; then
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
        __ARGS_ARGUMENT_NAME+=("$argument_name")
        __ARGS_ARGUMENT_HELP+=("$help")
        __ARGS_ARGUMENT_DEFAULT+=("$default")
        __ARGS_ARGUMENT_DEST+=("$dest")
        __ARGS_ARGUMENT_REQUIRED+=("$required")
        __ARGS_ARGUMENT_ISEXSISTS+=("false")
        __ARGS_ARGUMENT_COUNT+=(0)
    else
        [ "${#short_flags[@]}" -gt 0 ] && __ARGS_OPTION_SHORT_0+=("${short_flags[0]}") || __ARGS_OPTION_SHORT_0+=("")
        [ "${#short_flags[@]}" -gt 1 ] && __ARGS_OPTION_SHORT_1+=("${short_flags[1]}") || __ARGS_OPTION_SHORT_1+=("")
        [ "${#short_flags[@]}" -gt 2 ] && __ARGS_OPTION_SHORT_2+=("${short_flags[2]}") || __ARGS_OPTION_SHORT_2+=("")
        [ "${#short_flags[@]}" -gt 3 ] && __ARGS_OPTION_SHORT_3+=("${short_flags[3]}") || __ARGS_OPTION_SHORT_3+=("")
        [ "${#short_flags[@]}" -gt 4 ] && __ARGS_OPTION_SHORT_4+=("${short_flags[4]}") || __ARGS_OPTION_SHORT_4+=("")
        [ "${#short_flags[@]}" -gt 5 ] && __ARGS_OPTION_SHORT_5+=("${short_flags[5]}") || __ARGS_OPTION_SHORT_5+=("")
        [ "${#short_flags[@]}" -gt 6 ] && __ARGS_OPTION_SHORT_6+=("${short_flags[6]}") || __ARGS_OPTION_SHORT_6+=("")
        [ "${#short_flags[@]}" -gt 7 ] && __ARGS_OPTION_SHORT_7+=("${short_flags[7]}") || __ARGS_OPTION_SHORT_7+=("")
        [ "${#short_flags[@]}" -gt 8 ] && __ARGS_OPTION_SHORT_8+=("${short_flags[8]}") || __ARGS_OPTION_SHORT_8+=("")
        [ "${#short_flags[@]}" -ge 9 ] && __ARGS_OPTION_SHORT_9+=("${short_flags[9]}") || __ARGS_OPTION_SHORT_9+=("")

        [ "${#long_flags[@]}" -gt 0 ] && __ARGS_OPTION_LONG_0+=("${long_flags[0]}") || __ARGS_OPTION_LONG_0+=("")
        [ "${#long_flags[@]}" -gt 1 ] && __ARGS_OPTION_LONG_1+=("${long_flags[1]}") || __ARGS_OPTION_LONG_1+=("")
        [ "${#long_flags[@]}" -gt 2 ] && __ARGS_OPTION_LONG_2+=("${long_flags[2]}") || __ARGS_OPTION_LONG_2+=("")
        [ "${#long_flags[@]}" -gt 3 ] && __ARGS_OPTION_LONG_3+=("${long_flags[3]}") || __ARGS_OPTION_LONG_3+=("")
        [ "${#long_flags[@]}" -gt 4 ] && __ARGS_OPTION_LONG_4+=("${long_flags[4]}") || __ARGS_OPTION_LONG_4+=("")
        [ "${#long_flags[@]}" -gt 5 ] && __ARGS_OPTION_LONG_5+=("${long_flags[5]}") || __ARGS_OPTION_LONG_5+=("")
        [ "${#long_flags[@]}" -gt 6 ] && __ARGS_OPTION_LONG_6+=("${long_flags[6]}") || __ARGS_OPTION_LONG_6+=("")
        [ "${#long_flags[@]}" -gt 7 ] && __ARGS_OPTION_LONG_7+=("${long_flags[7]}") || __ARGS_OPTION_LONG_7+=("")
        [ "${#long_flags[@]}" -gt 8 ] && __ARGS_OPTION_LONG_8+=("${long_flags[8]}") || __ARGS_OPTION_LONG_8+=("")
        [ "${#long_flags[@]}" -ge 9 ] && __ARGS_OPTION_LONG_9+=("${long_flags[9]}") || __ARGS_OPTION_LONG_9+=("")

        if [ "$action" = "store_false" ]; then
            __ARGS_OPTION_DEFAULT+=("true")
        elif [ "$action" = "store_true" ]; then
            __ARGS_OPTION_DEFAULT+=("false")
        else
            __ARGS_OPTION_DEFAULT+=("$default")
        fi
        __ARGS_OPTION_ACTION+=("$action")
        __ARGS_OPTION_METAVAR+=("$metavar")
        __ARGS_OPTION_HELP+=("$help")
        __ARGS_OPTION_DEST+=("$dest")
        __ARGS_OPTION_REQUIRED+=("$required")
        __ARGS_OPTION_ISEXSISTS+=("false")
        __ARGS_OPTION_COUNT+=(0)
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
    local count
    for key in "${__ARGS_ARGUMENT_NAME[@]:-}"; do
        count=$((${#key}))
        if [ $count -gt $max_col ]; then
            max_col=$count
        fi
    done
    for i in "${!__ARGS_OPTION_SHORT_0[@]}"; do
        key=""
        if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ]; then
            key+="-${__ARGS_OPTION_SHORT_0[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_1[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_1[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_2[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_2[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_3[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_3[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_4[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_4[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_5[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_5[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_6[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_6[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_7[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_7[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_8[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_8[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_9[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_9[$i]}"
        fi
        if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ] && [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
            key+=", "
        fi
        if [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
            key+="--${__ARGS_OPTION_LONG_0[$i]}"
            [ -n "${__ARGS_OPTION_LONG_1[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_1[$i]}"
            [ -n "${__ARGS_OPTION_LONG_2[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_2[$i]}"
            [ -n "${__ARGS_OPTION_LONG_3[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_3[$i]}"
            [ -n "${__ARGS_OPTION_LONG_4[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_4[$i]}"
            [ -n "${__ARGS_OPTION_LONG_5[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_5[$i]}"
            [ -n "${__ARGS_OPTION_LONG_6[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_6[$i]}"
            [ -n "${__ARGS_OPTION_LONG_7[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_7[$i]}"
            [ -n "${__ARGS_OPTION_LONG_8[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_8[$i]}"
            [ -n "${__ARGS_OPTION_LONG_9[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_9[$i]}"
        fi
        count=$((${#key}))
        if [ $count -gt $max_col ]; then
            max_col=$count
        fi
    done
    for key in "${__ARGS_OPTION_SHORT_0[@]:-}" \
               "${__ARGS_OPTION_SHORT_1[@]:-}" \
               "${__ARGS_OPTION_SHORT_2[@]:-}" \
               "${__ARGS_OPTION_SHORT_3[@]:-}" \
               "${__ARGS_OPTION_SHORT_4[@]:-}" \
               "${__ARGS_OPTION_SHORT_5[@]:-}" \
               "${__ARGS_OPTION_SHORT_6[@]:-}" \
               "${__ARGS_OPTION_SHORT_7[@]:-}" \
               "${__ARGS_OPTION_SHORT_8[@]:-}" \
               "${__ARGS_OPTION_SHORT_9[@]:-}" ; do
        # add len of '-'
        count=$((${#key}+1))
        if [ $count -gt $max_col ]; then
            max_col=$count
        fi
    done
    for key in "${__ARGS_OPTION_LONG_0[@]:-}" \
               "${__ARGS_OPTION_LONG_1[@]:-}" \
               "${__ARGS_OPTION_LONG_2[@]:-}" \
               "${__ARGS_OPTION_LONG_3[@]:-}" \
               "${__ARGS_OPTION_LONG_4[@]:-}" \
               "${__ARGS_OPTION_LONG_5[@]:-}" \
               "${__ARGS_OPTION_LONG_6[@]:-}" \
               "${__ARGS_OPTION_LONG_7[@]:-}" \
               "${__ARGS_OPTION_LONG_8[@]:-}" \
               "${__ARGS_OPTION_LONG_9[@]:-}" ; do
        # add len of '--'
        count=$((${#key}+2))
        if [ $count -gt $max_col ]; then
            max_col=$count
        fi
    done

    for key in "${__ARGS_ARGUMENT_NAME[@]:-}"; do
        printf -- "%-*s : %s\n" "$max_col" "$(printf -- "%s" "$key")" "${ARGS["$key"]:-}"
    done
    for i in "${!__ARGS_OPTION_SHORT_0[@]}"; do
        key=""
        if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ]; then
            value="${ARGS["${__ARGS_OPTION_SHORT_0[$i]}"]:-}"
            key+="-${__ARGS_OPTION_SHORT_0[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_1[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_1[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_2[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_2[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_3[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_3[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_4[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_4[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_5[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_5[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_6[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_6[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_7[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_7[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_8[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_8[$i]}"
            [ -n "${__ARGS_OPTION_SHORT_9[$i]}" ] && key+=", -${__ARGS_OPTION_SHORT_9[$i]}"
        fi
        if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ] && [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
            key+=", "
        fi
        if [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
            value="${ARGS["${__ARGS_OPTION_LONG_0[$i]}"]:-}"
            key+="--${__ARGS_OPTION_LONG_0[$i]}"
            [ -n "${__ARGS_OPTION_LONG_1[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_1[$i]}"
            [ -n "${__ARGS_OPTION_LONG_2[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_2[$i]}"
            [ -n "${__ARGS_OPTION_LONG_3[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_3[$i]}"
            [ -n "${__ARGS_OPTION_LONG_4[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_4[$i]}"
            [ -n "${__ARGS_OPTION_LONG_5[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_5[$i]}"
            [ -n "${__ARGS_OPTION_LONG_6[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_6[$i]}"
            [ -n "${__ARGS_OPTION_LONG_7[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_7[$i]}"
            [ -n "${__ARGS_OPTION_LONG_8[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_8[$i]}"
            [ -n "${__ARGS_OPTION_LONG_9[$i]}" ] && key+=", --${__ARGS_OPTION_LONG_9[$i]}"
        fi
        printf -- "%-*s : %s\n" "$max_col" "$key" "$value"
    done
    return 0
}

# Show/Generate usage message
#   params:
#     $1  Name/Path of script
args_usage() {
    if [ -n "$__ARGS_USAGE" ]; then
        echo "$__ARGS_USAGE"
    else
        __args_sort
        local i
        local j
        local str
        local max_col="$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] + __ARGS_USAGE_WIDTHS[3] ))"
        local current_col=0
        local has_max_col=false
        # generate usage message
        str="usage: ${1##*/}"
        local usage_basename_length="${#str}"
        current_col="$usage_basename_length"
        for i in "${!__ARGS_OPTION_ACTION[@]}"; do
            local option=""
            option+=" "
            if ! ${__ARGS_OPTION_REQUIRED[$i]}; then
                option+="["
            fi
            if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ]; then
                option+="-${__ARGS_OPTION_SHORT_0[$i]}"
            elif [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
                option+="--${__ARGS_OPTION_LONG_0[$i]}"
            fi
            if [ "store" = "${__ARGS_OPTION_ACTION[$i]}" ]; then
                option+=" "
                if [ -n "${__ARGS_OPTION_METAVAR[$i]}" ]; then
                    option+="${__ARGS_OPTION_METAVAR[$i]}"
                else
                    if [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
                        local option_argument="${__ARGS_OPTION_LONG_0[$i]^^}"
                        option+="${option_argument//-/_}"
                    else
                        option+="${__ARGS_OPTION_SHORT_0[$i]^^}"
                    fi
                fi
            fi
            if ! ${__ARGS_OPTION_REQUIRED[$i]}; then
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
        done
        if [ "${#__ARGS_ARGUMENT_NAME[@]}" -ne 0 ]; then
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
        for i in "${!__ARGS_ARGUMENT_NAME[@]}"; do
            local option=""
            option+=" "
            if ${__ARGS_ARGUMENT_REQUIRED[$i]}; then
                option+="${__ARGS_ARGUMENT_NAME[$i]}"
            else
                option+="[${__ARGS_ARGUMENT_NAME[$i]}]"
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
        done
        str+=$'\n'
        if [ -n "$__ARGS_DESCRIPTION" ]; then
            str+=$'\n'
            str+="$__ARGS_DESCRIPTION"
            str+=$'\n'
        fi
        if [ "${#__ARGS_ARGUMENT_NAME[@]}" -ne 0 ]; then
            str+=$'\n'
            str+="positional arguments:"
            str+=$'\n'
        fi
        for i in "${!__ARGS_ARGUMENT_NAME[@]}"; do
            j=0
            while [ "$j" -lt "${__ARGS_USAGE_WIDTHS[0]}" ]; do
                str+=" "
                j=$((j + 1))
            done
            local option=""
            option+="${__ARGS_ARGUMENT_NAME[$i]}"
            str+="$option"
            if [ -n "${__ARGS_ARGUMENT_HELP[$i]}" ]; then
                if [ "${#option}" -gt "${__ARGS_USAGE_WIDTHS[1]}" ]; then
                    str+=$'\n'
                    j=0
                    while [ "$j" -lt "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))" ]; do
                        str+=" "
                        j=$((j + 1))
                    done
                else
                    j=0
                    while [ "$j" -lt "$(( __ARGS_USAGE_WIDTHS[1] - ${#option} + __ARGS_USAGE_WIDTHS[2] - 1 ))" ]; do
                        str+=" "
                        j=$((j + 1))
                    done
                fi
                current_col="$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))"
                local word=""
                for word in ${__ARGS_ARGUMENT_HELP[$i]}; do
                    if [ "$(( current_col + ${#word} + 1 ))" -gt "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] + __ARGS_USAGE_WIDTHS[3] ))" ]; then
                        str+=$'\n'
                        j=0
                        while [ "$j" -lt "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))" ]; do
                            str+=" "
                            j=$((j + 1))
                        done
                        current_col="$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))"
                    fi
                    str+=" $word"
                    current_col="$(( current_col + ${#word} + 1 ))"
                done
            fi
            str+=$'\n'
        done
        if [ "${#__ARGS_OPTION_ACTION[@]}" -ne 0 ]; then
            str+=$'\n'
            str+="optional arguments:"
            str+=$'\n'
        fi
        for i in "${!__ARGS_OPTION_ACTION[@]}"; do
            j=0
            while [ "$j" -lt "${__ARGS_USAGE_WIDTHS[0]}" ]; do
                str+=" "
                j=$((j + 1))
            done
            local option=""
            if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ]; then
                option+="-${__ARGS_OPTION_SHORT_0[$i]}"
                [ -n "${__ARGS_OPTION_SHORT_1[$i]}" ] && option+=", -${__ARGS_OPTION_SHORT_1[$i]}"
                [ -n "${__ARGS_OPTION_SHORT_2[$i]}" ] && option+=", -${__ARGS_OPTION_SHORT_2[$i]}"
                [ -n "${__ARGS_OPTION_SHORT_3[$i]}" ] && option+=", -${__ARGS_OPTION_SHORT_3[$i]}"
                [ -n "${__ARGS_OPTION_SHORT_4[$i]}" ] && option+=", -${__ARGS_OPTION_SHORT_4[$i]}"
                [ -n "${__ARGS_OPTION_SHORT_5[$i]}" ] && option+=", -${__ARGS_OPTION_SHORT_5[$i]}"
                [ -n "${__ARGS_OPTION_SHORT_6[$i]}" ] && option+=", -${__ARGS_OPTION_SHORT_6[$i]}"
                [ -n "${__ARGS_OPTION_SHORT_7[$i]}" ] && option+=", -${__ARGS_OPTION_SHORT_7[$i]}"
                [ -n "${__ARGS_OPTION_SHORT_8[$i]}" ] && option+=", -${__ARGS_OPTION_SHORT_8[$i]}"
                [ -n "${__ARGS_OPTION_SHORT_9[$i]}" ] && option+=", -${__ARGS_OPTION_SHORT_9[$i]}"
            fi
            if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ] && [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
                option+=", "
            fi
            if [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
                option+="--${__ARGS_OPTION_LONG_0[$i]}"
                [ -n "${__ARGS_OPTION_LONG_1[$i]}" ] && option+=", --${__ARGS_OPTION_LONG_1[$i]}"
                [ -n "${__ARGS_OPTION_LONG_2[$i]}" ] && option+=", --${__ARGS_OPTION_LONG_2[$i]}"
                [ -n "${__ARGS_OPTION_LONG_3[$i]}" ] && option+=", --${__ARGS_OPTION_LONG_3[$i]}"
                [ -n "${__ARGS_OPTION_LONG_4[$i]}" ] && option+=", --${__ARGS_OPTION_LONG_4[$i]}"
                [ -n "${__ARGS_OPTION_LONG_5[$i]}" ] && option+=", --${__ARGS_OPTION_LONG_5[$i]}"
                [ -n "${__ARGS_OPTION_LONG_6[$i]}" ] && option+=", --${__ARGS_OPTION_LONG_6[$i]}"
                [ -n "${__ARGS_OPTION_LONG_7[$i]}" ] && option+=", --${__ARGS_OPTION_LONG_7[$i]}"
                [ -n "${__ARGS_OPTION_LONG_8[$i]}" ] && option+=", --${__ARGS_OPTION_LONG_8[$i]}"
                [ -n "${__ARGS_OPTION_LONG_9[$i]}" ] && option+=", --${__ARGS_OPTION_LONG_9[$i]}"
            fi

            if [ "store" = "${__ARGS_OPTION_ACTION[$i]}" ]; then
                option+=" "
                if [ -n "${__ARGS_OPTION_METAVAR[$i]}" ]; then
                    option+="${__ARGS_OPTION_METAVAR[$i]}"
                elif [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
                    local option_argument="${__ARGS_OPTION_LONG_0[$i]^^}"
                    option+="${option_argument//-/_}"
                else
                    option+="${__ARGS_OPTION_SHORT_0[$i]^^}"
                fi
            fi
            str+="$option"
            if [ -n "${__ARGS_OPTION_HELP[$i]}" ]; then
                if [ "${#option}" -gt "${__ARGS_USAGE_WIDTHS[1]}" ]; then
                    str+=$'\n'
                    j=0
                    while [ "$j" -lt "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))" ]; do
                        str+=" "
                        j=$((j + 1))
                    done
                else
                    j=0
                    while [ "$j" -lt "$(( __ARGS_USAGE_WIDTHS[1] - ${#option} + __ARGS_USAGE_WIDTHS[2] - 1 ))" ]; do
                        str+=" "
                        j=$((j + 1))
                    done
                fi
                current_col="$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))"
                local word=""
                for word in ${__ARGS_OPTION_HELP[$i]}; do
                    if [ "$(( current_col + ${#word} + 1 ))" -gt "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] + __ARGS_USAGE_WIDTHS[3] ))" ]; then
                        str+=$'\n'
                        j=0
                        while [ "$j" -lt "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))" ]; do
                            str+=" "
                            j=$((j + 1))
                        done
                        current_col="$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))"
                    fi
                    str+=" $word"
                    current_col="$(( current_col + ${#word} + 1 ))"
                done
            fi
            str+=$'\n'
        done
        if [ -n "$__ARGS_EPILOG" ]; then
            str+=$'\n'
            str+="$__ARGS_EPILOG"
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
    local j=0
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
        for i in "${!__ARGS_OPTION_ACTION[@]}"; do
            if [[ -n "${__ARGS_OPTION_SHORT_0[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_0[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_SHORT_1[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_1[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_SHORT_2[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_2[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_SHORT_3[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_3[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_SHORT_4[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_4[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_SHORT_5[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_5[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_SHORT_6[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_6[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_SHORT_7[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_7[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_SHORT_8[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_8[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_SHORT_9[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_9[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_LONG_0[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_0[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_LONG_1[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_1[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_LONG_2[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_2[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_LONG_3[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_3[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_LONG_4[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_4[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_LONG_5[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_5[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_LONG_6[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_6[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_LONG_7[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_7[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_LONG_8[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_8[$i]}" ]] || \
               [[ -n "${__ARGS_OPTION_LONG_9[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_9[$i]}" ]]; then
                local value=""
                if [ "store" = "${__ARGS_OPTION_ACTION[$i]}" ]; then
                    if [ $# -le 1 ] || [ "--" = "$2" ]; then
                        >&2 echo "$binary_name: option '$1' require a argument"
                        return 1
                    fi
                    value="$2"
                    shift
                elif [ "store_true" = "${__ARGS_OPTION_ACTION[$i]}" ]; then
                    value="true"
                elif [ "store_false" = "${__ARGS_OPTION_ACTION[$i]}" ]; then
                    value="false"
                elif [ "count" = "${__ARGS_OPTION_ACTION[$i]}" ]; then
                    value=$((__ARGS_OPTION_COUNT[i] + 1))
                fi
                __ARGS_OPTION_ISEXSISTS[$i]="true"
                __ARGS_OPTION_COUNT[$i]=$((__ARGS_OPTION_COUNT[i] + 1))
                __args_parse_assign_option_value "$i" "$value"
                shift
                is_option="true"
                break
            elif [[ -n "${__ARGS_OPTION_SHORT_0[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_0[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_1[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_1[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_2[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_2[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_3[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_3[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_4[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_4[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_5[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_5[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_6[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_6[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_7[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_7[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_8[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_8[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_9[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_9[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_LONG_0[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_0[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_LONG_1[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_1[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_LONG_2[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_2[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_LONG_3[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_3[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_LONG_4[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_4[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_LONG_5[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_5[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_LONG_6[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_6[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_LONG_7[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_7[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_LONG_8[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_8[$i]}="* ]] || \
                 [[ -n "${__ARGS_OPTION_LONG_9[$i]}" && "$1" = "--${__ARGS_OPTION_LONG_9[$i]}="* ]]; then
                local value=""
                if [ "store" = "${__ARGS_OPTION_ACTION[$i]}" ]; then
                    value="${1#*=}"
                else
                    >&2 echo "$binary_name: option '$1' don't take a argument"
                    return 1
                fi
                __ARGS_OPTION_ISEXSISTS[$i]="true"
                __ARGS_OPTION_COUNT[$i]=$((__ARGS_OPTION_COUNT[i] + 1))
                __args_parse_assign_option_value "$i" "$value"
                shift
                is_option="true"
                break
            elif [[ -n "${__ARGS_OPTION_SHORT_0[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_0[$i]}"* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_1[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_1[$i]}"* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_2[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_2[$i]}"* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_3[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_3[$i]}"* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_4[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_4[$i]}"* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_5[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_5[$i]}"* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_6[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_6[$i]}"* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_7[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_7[$i]}"* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_8[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_8[$i]}"* ]] || \
                 [[ -n "${__ARGS_OPTION_SHORT_9[$i]}" && "$1" = "-${__ARGS_OPTION_SHORT_9[$i]}"* ]]; then
                local value=""
                if [ "store" = "${__ARGS_OPTION_ACTION[$i]}" ]; then
                    value="${1:2}"
                    __ARGS_OPTION_ISEXSISTS[$i]="true"
                    __ARGS_OPTION_COUNT[$i]=$((__ARGS_OPTION_COUNT[i] + 1))
                    __args_parse_assign_option_value "$i" "$value"
                else
                    value="$1"
                    local i_short
                    local value_short
                    while [ ${#value} -ge 1 ]; do
                        value="${value:1}"
                        value_short="${value:0:1}"
                        # Get options
                        for i_short in "${!__ARGS_OPTION_ACTION[@]}"; do
                            if [[ -n "${__ARGS_OPTION_SHORT_0[$i_short]}" && "$value_short" = "${__ARGS_OPTION_SHORT_0[$i_short]}"* ]] || \
                               [[ -n "${__ARGS_OPTION_SHORT_1[$i_short]}" && "$value_short" = "${__ARGS_OPTION_SHORT_1[$i_short]}"* ]] || \
                               [[ -n "${__ARGS_OPTION_SHORT_2[$i_short]}" && "$value_short" = "${__ARGS_OPTION_SHORT_2[$i_short]}"* ]] || \
                               [[ -n "${__ARGS_OPTION_SHORT_3[$i_short]}" && "$value_short" = "${__ARGS_OPTION_SHORT_3[$i_short]}"* ]] || \
                               [[ -n "${__ARGS_OPTION_SHORT_4[$i_short]}" && "$value_short" = "${__ARGS_OPTION_SHORT_4[$i_short]}"* ]] || \
                               [[ -n "${__ARGS_OPTION_SHORT_5[$i_short]}" && "$value_short" = "${__ARGS_OPTION_SHORT_5[$i_short]}"* ]] || \
                               [[ -n "${__ARGS_OPTION_SHORT_6[$i_short]}" && "$value_short" = "${__ARGS_OPTION_SHORT_6[$i_short]}"* ]] || \
                               [[ -n "${__ARGS_OPTION_SHORT_7[$i_short]}" && "$value_short" = "${__ARGS_OPTION_SHORT_7[$i_short]}"* ]] || \
                               [[ -n "${__ARGS_OPTION_SHORT_8[$i_short]}" && "$value_short" = "${__ARGS_OPTION_SHORT_8[$i_short]}"* ]] || \
                               [[ -n "${__ARGS_OPTION_SHORT_9[$i_short]}" && "$value_short" = "${__ARGS_OPTION_SHORT_9[$i_short]}"* ]]; then
                                if [ "store_true" = "${__ARGS_OPTION_ACTION[$i_short]}" ]; then
                                    value_short="true"
                                elif [ "store_false" = "${__ARGS_OPTION_ACTION[$i_short]}" ]; then
                                    value_short="false"
                                elif [ "count" = "${__ARGS_OPTION_ACTION[$i_short]}" ]; then
                                    value_short=$((__ARGS_OPTION_COUNT[i_short] + 1))
                                else
                                    if [ ${#value} -gt 1 ]; then
                                        value_short="${value:1}"
                                        value=""
                                    elif [ $# -gt 1 ] && [[ "$2" != "--" ]]; then
                                        value_short="$2"
                                        value=""
                                        shift
                                    else
                                        >&2 echo "$binary_name: option '-$value_short' require a argument"
                                        return 1
                                    fi
                                fi
                                __ARGS_OPTION_ISEXSISTS[$i_short]="true"
                                __ARGS_OPTION_COUNT[$i_short]=$((__ARGS_OPTION_COUNT[i_short] + 1))
                                __args_parse_assign_option_value "$i_short" "$value_short"
                                break
                            fi
                        done
                    done
                fi
                shift
                is_option="true"
                break
            fi
        done
        if [ "$is_option" = "false" ]; then
            if [[ "$1" = "--"* ]]; then
                >&2 echo "$binary_name: invalid option -- '$1'"
                return 1
            elif [[ "$1" = "-"* ]]; then
                local value
                value="${1:0:2}"
                >&2 echo "$binary_name: invalid option -- '$value'"
                return 1
            fi
            if [ "$j" -lt "${#__ARGS_ARGUMENT_NAME[@]}" ]; then
                __ARGS_ARGUMENT_ISEXSISTS[$j]="true"
                __ARGS_ARGUMENT_COUNT[$j]=$((__ARGS_ARGUMENT_COUNT[j] + 1))
                ARGS[${__ARGS_ARGUMENT_NAME[$j]}]="$1"
                j=$((j+1))
                shift
            else
                >&2 echo "$binary_name: extra argument(s) '$*'"
                return 1
            fi
        fi
    done
    # Get arguments
    if [ $# -gt 0 ]; then
        while [ "$j" -lt "${#__ARGS_ARGUMENT_NAME[@]}" ]; do
            __ARGS_ARGUMENT_ISEXSISTS[$j]="true"
            __ARGS_ARGUMENT_COUNT[$j]=$((__ARGS_ARGUMENT_COUNT[j] + 1))
            ARGS[${__ARGS_ARGUMENT_NAME[$j]}]="$1"
            j=$((j+1))
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
    for i in "${!__ARGS_OPTION_ACTION[@]}"; do
        if [ "${__ARGS_OPTION_REQUIRED[$i]}" = "true" ]; then
            local name=""
            if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ]; then
                name="${__ARGS_OPTION_SHORT_0[$i]}"
            elif [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
                name="${__ARGS_OPTION_LONG_0[$i]}"
            fi
            if [ ! "${ARGS[$name]+abracadabra}" ]; then
                if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ]; then
                    >&2 echo "$binary_name: option '-$name' is required"
                elif [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
                    >&2 echo "$binary_name: option '--$name' is required"
                fi
                return 1
            fi
        fi
    done
    for i in "${!__ARGS_ARGUMENT_NAME[@]}"; do
        if [ "${__ARGS_ARGUMENT_REQUIRED[$i]}" = "true" ]; then
            if [ ! "${ARGS[${__ARGS_ARGUMENT_NAME[$i]}]+abracadabra}" ]; then
                >&2 echo "$binary_name: argument '${__ARGS_ARGUMENT_NAME[$i]}' is required"
                return 1
            fi
        fi
    done
    # Default
    for i in "${!__ARGS_ARGUMENT_NAME[@]}"; do
        if [ ! "${ARGS[${__ARGS_ARGUMENT_NAME[$i]}]+abracadabra}" ]; then
            if [ -n "${__ARGS_ARGUMENT_DEFAULT[$i]}" ]; then
                ARGS[${__ARGS_ARGUMENT_NAME[$i]}]="${__ARGS_ARGUMENT_DEFAULT[$i]}"
            fi
        fi
    done
    local name=""
    for i in "${!__ARGS_OPTION_ACTION[@]}"; do
        if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ]; then
            name="${__ARGS_OPTION_SHORT_0[$i]}"
        elif [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
            name="${__ARGS_OPTION_LONG_0[$i]}"
        fi
        if [ ! "${ARGS[$name]+abracadabra}" ]; then
            if [ "count" = "${__ARGS_OPTION_ACTION[$i]}" ]; then
                __args_parse_assign_option_value "$i" "0"
            fi
            if [ -n "${__ARGS_OPTION_DEFAULT[$i]}" ]; then
                __args_parse_assign_option_value "$i" "${__ARGS_OPTION_DEFAULT[$i]}"
            fi
        fi
    done
    # Dest
    for i in "${!__ARGS_OPTION_ACTION[@]}"; do
        if [ -n "${__ARGS_OPTION_DEST[$i]}" ]; then
            if [ -n "${__ARGS_OPTION_SHORT_0[$i]}" ]; then
                declare -g "${__ARGS_OPTION_DEST[$i]}=${ARGS[${__ARGS_OPTION_SHORT_0[$i]}]:-}"
            elif [ -n "${__ARGS_OPTION_LONG_0[$i]}" ]; then
                declare -g "${__ARGS_OPTION_DEST[$i]}=${ARGS[${__ARGS_OPTION_LONG_0[$i]}]:-}"
            fi
        fi
    done
    for i in "${!__ARGS_ARGUMENT_NAME[@]}"; do
        if [ -n "${__ARGS_ARGUMENT_DEST[$i]}" ]; then
            declare -g "${__ARGS_ARGUMENT_DEST[$i]}=${ARGS[${__ARGS_ARGUMENT_NAME[$i]}]:-}"
        fi
    done
    return 0
}

# Clean argparser global vairables at source
args_clean
