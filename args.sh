#
# args.sh
#
# Licensed under the MIT License <http://opensource.org/licenses/MIT>.
# Copyright (c) 2024 BLET Mickaël.
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

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    >&2 echo "Please source args.sh file."
    exit 1
fi

declare -A ARGS

# options
__ARGS_USAGE=""
__ARGS_DESCRIPTION=""
__ARGS_EPILOG=""
__ARGS_ALTERNATIVE=false
__ARGS_USAGE_WIDTHS=(2 20 2 56)

__ARGS_ARGUMENT_NAME=()
__ARGS_ARGUMENT_HELP=()
__ARGS_ARGUMENT_DEFAULT=()
__ARGS_ARGUMENT_DEST=()
__ARGS_ARGUMENT_REQUIRED=()

__ARGS_OPTION_TYPE=()
__ARGS_OPTION_SHORT=()
__ARGS_OPTION_LONG=()
__ARGS_OPTION_METAVAR=()
__ARGS_OPTION_HELP=()
__ARGS_OPTION_DEFAULT=()
__ARGS_OPTION_DEST=()
__ARGS_OPTION_REQUIRED=()

# Clean all map and array for recalled
args_clean() {
    ARGS=()

    __ARGS_USAGE=""
    __ARGS_DESCRIPTION=""
    __ARGS_EPILOG=""
    __ARGS_ALTERNATIVE=false
    __ARGS_USAGE_WIDTHS=(2 20 2 56)

    __ARGS_ARGUMENT_NAME=()
    __ARGS_ARGUMENT_HELP=()
    __ARGS_ARGUMENT_DEFAULT=()
    __ARGS_ARGUMENT_DEST=()
    __ARGS_ARGUMENT_REQUIRED=()

    __ARGS_OPTION_TYPE=()
    __ARGS_OPTION_SHORT=()
    __ARGS_OPTION_LONG=()
    __ARGS_OPTION_METAVAR=()
    __ARGS_OPTION_HELP=()
    __ARGS_OPTION_DEFAULT=()
    __ARGS_OPTION_DEST=()
    __ARGS_OPTION_REQUIRED=()
}

__args_get_options() {
    local var_name="$1"
    local result_getopt
    if ! result_getopt="$(getopt --alternative --longoptions "$2" -- "" "${@:3}")"; then
        echo "$var_name=([\"strerror\"]=\"show in previous error message\")"
        return 1
    fi
    local result_str
    result_str=""
    result_str+="$1=("
    eval set -- "$result_getopt"
    while true; do
        case $1 in
            "--")
                shift
                break;;
            "--"*)
                result_str+="[\"${1:2}\"]=\"$2\" "
                shift 2;;
            *)
                echo "$var_name=([\"strerror\"]=\"parse option in __args_get_options\")"
                break;;
        esac
    done
    result_str+=')'
    if [ $# -ne 0 ]; then
        echo "$var_name=([\"strerror\"]=\"has extra argument(s) '$*'\")"
        return 1
    fi
    echo "$result_str"
    return 0
}

__args_already_exists() {
    local argument_name
    for argument_name in "${__ARGS_ARGUMENT_NAME[@]:-}"; do
        if [ "$1" = "$argument_name" ]; then
            return 0;
        fi
    done

    local option_name
    for option_name in "${__ARGS_OPTION_SHORT[@]:-}"; do
        if [ "$1" = "$option_name" ]; then
            return 0;
        fi
    done
    for option_name in "${__ARGS_OPTION_LONG[@]:-}"; do
        if [ "$1" = "$option_name" ]; then
            return 0;
        fi
    done
    return 1;
}

# Sort by asc optional arguments
__args_swap_options() {
    local type="${__ARGS_OPTION_TYPE[$1]}"
    local short="${__ARGS_OPTION_SHORT[$1]}"
    local long="${__ARGS_OPTION_LONG[$1]}"
    local metavar="${__ARGS_OPTION_METAVAR[$1]}"
    local help="${__ARGS_OPTION_HELP[$1]}"
    local default="${__ARGS_OPTION_DEFAULT[$1]}"
    local dest="${__ARGS_OPTION_DEST[$1]}"
    local required="${__ARGS_OPTION_REQUIRED[$1]}"
    __ARGS_OPTION_TYPE[$1]="${__ARGS_OPTION_TYPE[$2]}"
    __ARGS_OPTION_SHORT[$1]="${__ARGS_OPTION_SHORT[$2]}"
    __ARGS_OPTION_LONG[$1]="${__ARGS_OPTION_LONG[$2]}"
    __ARGS_OPTION_METAVAR[$1]="${__ARGS_OPTION_METAVAR[$2]}"
    __ARGS_OPTION_HELP[$1]="${__ARGS_OPTION_HELP[$2]}"
    __ARGS_OPTION_DEFAULT[$1]="${__ARGS_OPTION_DEFAULT[$2]}"
    __ARGS_OPTION_DEST[$1]="${__ARGS_OPTION_DEST[$2]}"
    __ARGS_OPTION_REQUIRED[$1]="${__ARGS_OPTION_REQUIRED[$2]}"
    __ARGS_OPTION_TYPE[$2]="$type"
    __ARGS_OPTION_SHORT[$2]="$short"
    __ARGS_OPTION_LONG[$2]="$long"
    __ARGS_OPTION_METAVAR[$2]="$metavar"
    __ARGS_OPTION_HELP[$2]="$help"
    __ARGS_OPTION_DEFAULT[$2]="$default"
    __ARGS_OPTION_DEST[$2]="$dest"
    __ARGS_OPTION_REQUIRED[$2]="$required"
}

# Sort by asc optional arguments
__args_sort() {
    local max="$((${#__ARGS_OPTION_TYPE[@]} - 1))"
    local i j
    while [ "$max" -gt 0 ]; do
        i=0
        j=1
        while [ "$i" -lt "$max" ]; do
            if [ -n "${__ARGS_OPTION_SHORT[$i]}" ] && [ -n "${__ARGS_OPTION_SHORT[$j]}" ]; then
                if ! ${__ARGS_OPTION_REQUIRED[$i]} && ${__ARGS_OPTION_REQUIRED[$j]}; then
                    __args_swap_options "$i" "$j"
                elif ! ${__ARGS_OPTION_REQUIRED[$i]} && [ "${__ARGS_OPTION_SHORT[$i]}" \> "${__ARGS_OPTION_SHORT[$j]}" ]; then
                    __args_swap_options "$i" "$j"
                fi
            elif [ -z "${__ARGS_OPTION_SHORT[$i]}" ] && [ -z "${__ARGS_OPTION_SHORT[$j]}" ] && [ -n "${__ARGS_OPTION_LONG[$i]}" ] && [ -n "${__ARGS_OPTION_LONG[$((i + 1))]}" ]; then
                if ! ${__ARGS_OPTION_REQUIRED[$i]} && ${__ARGS_OPTION_REQUIRED[$j]}; then
                    __args_swap_options "$i" "$j"
                elif ! ${__ARGS_OPTION_REQUIRED[$i]} && [ "${__ARGS_OPTION_LONG[$i]}" \> "${__ARGS_OPTION_LONG[$j]}" ]; then
                    __args_swap_options "$i" "$j"
                fi
            elif [ -z "${__ARGS_OPTION_SHORT[$i]}" ]; then
                __args_swap_options "$i" "$j"
            fi
            i=$((i + 1))
            j=$((i + 1))
        done
        max=$((max - 1))
    done
}

# Set a usage description
#   params:
#     $*  Concat all arguments
#   example:
#     args_set_description "Your description " "message"
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

# Set alternative mode for getopt
args_set_alternative() {
    __ARGS_ALTERNATIVE="$1"
}

# Set a full usage message
#   example:
#     args_set_usage "Your usage " "message"
args_set_usage() {
    __ARGS_USAGE="$*"
}

# Set the widths of usage message
#   params:
#     $1  padding
#     $2  argument
#     $3  separator
#     $4  help
args_set_usage_widths() {
    __ARGS_USAGE_WIDTHS=("$1" "$2" "$3" "$4")
}

# Add a positional argument
#   option params:
#     --default   Default value
#     --dest      Destination variable
#     --help      Usage helper
#     --name      Name of argument
#     --required  Is required if not empty
#   example:
#     args_add_argument --name="FOO" --help="help of FOO" --dest="FOO"
args_add_argument() {
    local -A options
    eval "$(__args_get_options "options" "name:,help:,default:,dest:,required:" "$@")"
    local strerror="${options[strerror]:-}"
    local default="${options[default]:-}"
    local dest="${options[dest]:-}"
    local help="${options[help]:-}"
    local name="${options[name]:-}"
    local required="${options[required]:-}"

    # error
    if [ -n "$strerror" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: $strerror"
        return 1
    fi
    # default and required
    if [ -n "$default" ] && [ -n "$required" ] && [ "$required" = "true" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--default' used with '--required'"
        return 1
    fi
    # empty name
    if [ -z "$name" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--name' option is required"
        return 1
    fi
    # already name exists
    if __args_already_exists "$name"; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: argument name '$name' already exists"
        return 1
    fi

    __ARGS_ARGUMENT_NAME+=("$name")
    __ARGS_ARGUMENT_HELP+=("$help")
    __ARGS_ARGUMENT_DEFAULT+=("$default")
    __ARGS_ARGUMENT_DEST+=("$dest")
    if [ -n "$required" ] && [ "$required" = "true" ]; then
        __ARGS_ARGUMENT_REQUIRED+=(true)
    else
        __ARGS_ARGUMENT_REQUIRED+=(false)
    fi
}

# Add a boolean option
#   option params:
#     --dest   Destination variable
#     --help   Usage helper
#     --long   Long option name
#     --short  Short option name
#   example:
#     args_add_bool_option --short="f" --long="foo" --help="help of foo" --dest="FOO"
args_add_bool_option() {
    local -A options
    eval "$(__args_get_options "options" "short:,long:,help:,dest:" "$@")"
    local strerror="${options[strerror]:-}"
    local dest="${options[dest]:-}"
    local help="${options[help]:-}"
    local long="${options[long]:-}"
    local short="${options[short]:-}"

    # error
    if [ -n "$strerror" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: $strerror"
        return 1
    fi
    # oneof short or long
    if [ -z "$short" ] && [ -z "$long" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: oneof '--short/--long' option is required"
        return 1
    fi
    if [ -n "$short" ]; then
        # size of short
        if [ "${#short}" -ne 1 ]; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: short option '$short' length not equal 1"
            return 1
        fi
        # already short exists
        if __args_already_exists "$short"; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: short option '$short' already exists"
            return 1
        fi
    fi
    if [ -n "$long" ]; then
        # already long exists
        if __args_already_exists "$long"; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: long option '$long' already exists"
            return 1
        fi
    fi

    __ARGS_OPTION_TYPE+=("boolean")
    __ARGS_OPTION_SHORT+=("$short")
    __ARGS_OPTION_LONG+=("$long")
    __ARGS_OPTION_METAVAR+=("")
    __ARGS_OPTION_HELP+=("$help")
    __ARGS_OPTION_DEFAULT+=(false)
    __ARGS_OPTION_DEST+=("$dest")
    __ARGS_OPTION_REQUIRED+=(false)
}

# Add a reverse boolean option
#   option params:
#     --dest   Destination variable
#     --help   Usage helper
#     --long   Long option name
#     --short  Short option name
#   example:
#     args_add_reverse_bool_option --short="f" --long="foo" --help="help of foo" --dest="FOO"
args_add_reverse_bool_option() {
    local -A options
    eval "$(__args_get_options "options" "short:,long:,help:,dest:" "$@")"
    local strerror="${options[strerror]:-}"
    local dest="${options[dest]:-}"
    local help="${options[help]:-}"
    local long="${options[long]:-}"
    local short="${options[short]:-}"

    # error
    if [ -n "$strerror" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: $strerror"
        return 1
    fi
    # oneof short or long
    if [ -z "$short" ] && [ -z "$long" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: oneof short/long option is required"
        return 1
    fi
    if [ -n "$short" ]; then
        # size of short
        if [ "${#short}" -ne 1 ]; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: short '$short' length not equal 1"
            return 1
        fi
        # already short exists
        if __args_already_exists "$short"; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: short '$short' already exists"
            return 1
        fi
    fi
    if [ -n "$long" ]; then
        # already long exists
        if __args_already_exists "$long"; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: long '$long' already exists"
            return 1
        fi
    fi

    __ARGS_OPTION_TYPE+=("reverse_boolean")
    __ARGS_OPTION_SHORT+=("$short")
    __ARGS_OPTION_LONG+=("$long")
    __ARGS_OPTION_METAVAR+=("")
    __ARGS_OPTION_HELP+=("$help")
    __ARGS_OPTION_DEFAULT+=(true)
    __ARGS_OPTION_DEST+=("$dest")
    __ARGS_OPTION_REQUIRED+=(false)
}

# Add a option who take a argument
#   option params:
#     --default   Default value of option
#     --dest      Destination variable
#     --help      Usage helper
#     --long      Long option name
#     --metavar   Usage argument name (if not set use long/short name)
#     --required  This option is required
#     --short     Short option name
#   example:
#     args_add_option --short="f" --long="foo" --help="help of foo" --dest="FOO"
args_add_option() {
    local -A options
    eval "$(__args_get_options "options" "short:,long:,help:,metavar:,default:,dest:,required:" "$@")"
    local strerror="${options[strerror]:-}"
    local default="${options[default]:-}"
    local dest="${options[dest]:-}"
    local help="${options[help]:-}"
    local long="${options[long]:-}"
    local metavar="${options[metavar]:-}"
    local required="${options[required]:-}"
    local short="${options[short]:-}"

    # error
    if [ -n "$strerror" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: $strerror"
        return 1
    fi
    # default and required
    if [ -n "$default" ] && [ -n "$required" ] && [ "$required" = "true" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: '--default' used with '--required'"
        return 1
    fi
    # oneof short or long
    if [ -z "$short" ] && [ -z "$long" ]; then
        >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: oneof '--short/--long' option is required"
        return 1
    fi
    if [ -n "$short" ]; then
        # size of short
        if [ "${#short}" -ne 1 ]; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: short option '$short' length not equal 1"
            return 1
        fi
        # already short exists
        if __args_already_exists "$short"; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: short option '$short' already exists"
            return 1
        fi
    fi
    if [ -n "$long" ]; then
        # already long exists
        if __args_already_exists "$long"; then
            >&2 echo "$0: line ${BASH_LINENO[0]}: ${FUNCNAME[0]}: long option '$long' already exists"
            return 1
        fi
    fi

    __ARGS_OPTION_TYPE+=("option")
    __ARGS_OPTION_SHORT+=("$short")
    __ARGS_OPTION_LONG+=("$long")
    __ARGS_OPTION_METAVAR+=("$metavar")
    __ARGS_OPTION_HELP+=("$help")
    __ARGS_OPTION_DEFAULT+=("$default")
    __ARGS_OPTION_DEST+=("$dest")
    if [ -n "$required" ] && [ "$required" = "true" ]; then
        __ARGS_OPTION_REQUIRED+=(true)
    else
        __ARGS_OPTION_REQUIRED+=(false)
    fi
}

# Show all values of arguments and options
args_debug_values() {
    # get column max of options
    local max_col=0
    local key
    local count
    for key in "${__ARGS_ARGUMENT_NAME[@]}"; do
        count=$((${#key}))
        if [ $count -gt $max_col ]; then
            max_col=$count
        fi
    done
    for key in "${__ARGS_OPTION_SHORT[@]}"; do
        # add len of '-'
        count=$((${#key}+1))
        if [ $count -gt $max_col ]; then
            max_col=$count
        fi
    done
    for key in "${__ARGS_OPTION_LONG[@]}"; do
        # add len of '--'
        count=$((${#key}+2))
        if [ $count -gt $max_col ]; then
            max_col=$count
        fi
    done

    for key in "${__ARGS_ARGUMENT_NAME[@]}"; do
        printf -- "%-*s : %s\n" "$max_col" "$(printf -- "%s" "$key")" "${ARGS["$key"]:-}"
    done
    for key in "${__ARGS_OPTION_SHORT[@]}"; do
        if [ -n "$key" ]; then
            printf -- "%-*s : %s\n" "$max_col" "-$key" "${ARGS["$key"]:-}"
        fi
    done
    for key in "${__ARGS_OPTION_LONG[@]}"; do
        if [ -n "$key" ]; then
            printf -- "%-*s : %s\n" "$max_col" "--$key" "${ARGS["$key"]:-}"
        fi
    done
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
        for i in "${!__ARGS_OPTION_TYPE[@]}"; do
            local option=""
            option+=" "
            if ! ${__ARGS_OPTION_REQUIRED[$i]}; then
                option+="["
            fi
            if [ -n "${__ARGS_OPTION_SHORT[$i]}" ]; then
                option+="-${__ARGS_OPTION_SHORT[$i]}"
            elif [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
                option+="--${__ARGS_OPTION_LONG[$i]}"
            fi
            if [ "option" = "${__ARGS_OPTION_TYPE[$i]}" ]; then
                option+=" "
                if [ -n "${__ARGS_OPTION_METAVAR[$i]}" ]; then
                    option+="${__ARGS_OPTION_METAVAR[$i]}"
                else
                    if [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
                        local option_argument="${__ARGS_OPTION_LONG[$i]^^}"
                        option+="${option_argument//-/_}"
                    else
                        option+="${__ARGS_OPTION_SHORT[$i]^^}"
                    fi
                fi
            fi
            if ! ${__ARGS_OPTION_REQUIRED[$i]}; then
                option+="]"
            fi
            if [ "$((current_col + ${#option}))" -gt "$max_col" ]; then
                has_max_col=true
                str+=$'\n'
                for (( j = 0; j < "${usage_basename_length}"; j++ )); do
                    str+=" "
                done
                current_col="$usage_basename_length"
            fi
            str+="$option"
            current_col="$((current_col + ${#option}))"
        done
        if [ "${#__ARGS_ARGUMENT_NAME[@]}" -ne 0 ]; then
            if $has_max_col || [ "$((current_col + 3))" -gt "$max_col" ]; then
                str+=$'\n'
                for (( j = 0; j < "${usage_basename_length}"; j++ )); do
                    str+=" "
                done
                str+=" --"
                str+=$'\n'
                for (( j = 0; j < "${usage_basename_length}"; j++ )); do
                    str+=" "
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
                for (( j = 0; j < "${usage_basename_length}"; j++ )); do
                    str+=" "
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
            for (( j = 0; j < "${__ARGS_USAGE_WIDTHS[0]}"; j++ )); do
                str+=" "
            done
            local option=""
            option+="${__ARGS_ARGUMENT_NAME[$i]}"
            str+="$option"
            if [ -n "${__ARGS_ARGUMENT_HELP[$i]}" ]; then
                if [ "${#option}" -gt "${__ARGS_USAGE_WIDTHS[1]}" ]; then
                    str+=$'\n'
                    for (( j = 0; j < "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))"; j++ )); do
                        str+=" "
                    done
                else
                    for (( j = 0; j < "$(( __ARGS_USAGE_WIDTHS[1] - ${#option} + __ARGS_USAGE_WIDTHS[2] - 1 ))"; j++ )); do
                        str+=" "
                    done
                fi
                current_col="$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))"
                local word=""
                for word in ${__ARGS_ARGUMENT_HELP[$i]}; do
                    if [ "$(( current_col + ${#word} + 1 ))" -gt "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] + __ARGS_USAGE_WIDTHS[3] ))" ]; then
                        str+=$'\n'
                        for (( j = 0; j < "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))"; j++ )); do
                            str+=" "
                        done
                        current_col="$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))"
                    fi
                    str+=" $word"
                    current_col="$(( current_col + ${#word} + 1 ))"
                done
            fi
            str+=$'\n'
        done
        if [ "${#__ARGS_OPTION_TYPE[@]}" -ne 0 ]; then
            str+=$'\n'
            str+="optional arguments:"
            str+=$'\n'
        fi
        for i in "${!__ARGS_OPTION_TYPE[@]}"; do
            for (( j = 0; j < "${__ARGS_USAGE_WIDTHS[0]}"; j++ )); do
                str+=" "
            done
            local option=""
            if [ -n "${__ARGS_OPTION_SHORT[$i]}" ]; then
                option+="-${__ARGS_OPTION_SHORT[$i]}"
            fi
            if [ -n "${__ARGS_OPTION_SHORT[$i]}" ] && [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
                option+=", "
            fi
            if [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
                option+="--${__ARGS_OPTION_LONG[$i]}"
            fi

            if [ "option" = "${__ARGS_OPTION_TYPE[$i]}" ]; then
                option+=" "
                if [ -n "${__ARGS_OPTION_METAVAR[$i]}" ]; then
                    option+="${__ARGS_OPTION_METAVAR[$i]}"
                elif [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
                    local option_argument="${__ARGS_OPTION_LONG[$i]^^}"
                    option+="${option_argument//-/_}"
                else
                    option+="${__ARGS_OPTION_SHORT[$i]^^}"
                fi
            fi
            str+="$option"
            if [ -n "${__ARGS_OPTION_HELP[$i]}" ]; then
                if [ "${#option}" -gt "${__ARGS_USAGE_WIDTHS[1]}" ]; then
                    str+=$'\n'
                    for (( j = 0; j < "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))"; j++ )); do
                        str+=" "
                    done
                else
                    for (( j = 0; j < "$(( __ARGS_USAGE_WIDTHS[1] - ${#option} + __ARGS_USAGE_WIDTHS[2] - 1 ))"; j++ )); do
                        str+=" "
                    done
                fi
                current_col="$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))"
                local word=""
                for word in ${__ARGS_OPTION_HELP[$i]}; do
                    if [ "$(( current_col + ${#word} + 1 ))" -gt "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] + __ARGS_USAGE_WIDTHS[3] ))" ]; then
                        str+=$'\n'
                        for (( j = 0; j < "$(( __ARGS_USAGE_WIDTHS[0] + __ARGS_USAGE_WIDTHS[1] + __ARGS_USAGE_WIDTHS[2] - 1 ))"; j++ )); do
                            str+=" "
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
}

# Use after args_add_* functions
# Convert argument strings to objects and assign them as attributes on the ARGS map
# Previous calls to args_add_argument/args_add_bool_option/args_add_reverse_bool_option/args_add_option
# determine exactly what objects are created and how they are assigned
# Execute this with "$@" parameters
args_parse_arguments() {
    local binary_name="$0"
    local help_options=()
    if ! __args_already_exists "h" && ! __args_already_exists "help"; then
        help_options+=("-h")
        help_options+=("--help")
        args_add_bool_option --short="h" --long="help" --help="print this help message"
    elif ! __args_already_exists "h"; then
        help_options+=("-h")
        args_add_bool_option --short="h" --help="print this help message"
    elif ! __args_already_exists "help"; then
        help_options+=("--help")
        args_add_bool_option --long="help" --help="print this help message"
    fi
    local i
    # create string options
    local short_options_str=""
    local long_options_str=""
    for i in "${!__ARGS_OPTION_TYPE[@]}"; do
        if [ -n "${__ARGS_OPTION_SHORT[$i]}" ]; then
            if [ "option" = "${__ARGS_OPTION_TYPE[$i]}" ]; then
                short_options_str+=",${__ARGS_OPTION_SHORT[$i]}:"
            else # is boolean
                short_options_str+=",${__ARGS_OPTION_SHORT[$i]}"
            fi
        fi
    done
    for i in "${!__ARGS_OPTION_TYPE[@]}"; do
        if [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
            if [ "option" = "${__ARGS_OPTION_TYPE[$i]}" ]; then
                long_options_str+=",${__ARGS_OPTION_LONG[$i]}:"
            else # is boolean
                long_options_str+=",${__ARGS_OPTION_LONG[$i]}"
            fi
        fi
    done

    # check argparser
    local result_getopt=""
    if [ "$__ARGS_ALTERNATIVE" = "true" ]; then
        if ! result_getopt="$(getopt --alternative --options "$short_options_str" --longoptions "$long_options_str" --name "$0" -- "$@")"; then
            return 1
        fi
    else
        if ! result_getopt="$(getopt --options "$short_options_str" --longoptions "$long_options_str" --name "$0" -- "$@")"; then
            return 1
        fi
    fi

    eval set -- "$result_getopt"
    while true; do
        if [ "$1" = "--" ]; then
            shift
            break
        fi
        for i in "${!help_options[@]}"; do
            if [ "$1" = "${help_options[i]}" ]; then
                args_usage "$binary_name"
                return 1
            fi
        done
        # Get options
        for i in "${!__ARGS_OPTION_TYPE[@]}"; do
            # is short
            if [ -n "${__ARGS_OPTION_SHORT[$i]}" ] && [ "$1" = "-${__ARGS_OPTION_SHORT[$i]}" ]; then
                if [ "option" = "${__ARGS_OPTION_TYPE[$i]}" ]; then
                    ARGS[${__ARGS_OPTION_SHORT[$i]}]="$2"
                    shift 2
                elif [ "boolean" = "${__ARGS_OPTION_TYPE[$i]}" ]; then
                    ARGS[${__ARGS_OPTION_SHORT[$i]}]=true
                    shift
                elif [ "reverse_boolean" = "${__ARGS_OPTION_TYPE[$i]}" ]; then
                    ARGS[${__ARGS_OPTION_SHORT[$i]}]=false
                    shift
                fi
                if [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
                    ARGS[${__ARGS_OPTION_LONG[$i]}]="${ARGS[${__ARGS_OPTION_SHORT[$i]}]:-}"
                fi
                break
            elif [ -n "${__ARGS_OPTION_LONG[$i]}" ] && [ "$1" = "--${__ARGS_OPTION_LONG[$i]}" ]; then
                if [ "option" = "${__ARGS_OPTION_TYPE[$i]}" ]; then
                    ARGS[${__ARGS_OPTION_LONG[$i]}]="$2"
                    shift 2
                elif [ "boolean" = "${__ARGS_OPTION_TYPE[$i]}" ]; then
                    ARGS[${__ARGS_OPTION_LONG[$i]}]=true
                    shift
                elif [ "reverse_boolean" = "${__ARGS_OPTION_TYPE[$i]}" ]; then
                    ARGS[${__ARGS_OPTION_LONG[$i]}]=false
                    shift
                fi
                if [ -n "${__ARGS_OPTION_SHORT[$i]}" ]; then
                    ARGS[${__ARGS_OPTION_SHORT[$i]}]="${ARGS[${__ARGS_OPTION_LONG[$i]}]:-}"
                fi
                break
            fi
        done
    done
    # Get arguments
    if [ $# -gt 0 ]; then
        for i in "${!__ARGS_ARGUMENT_NAME[@]}"; do
            ARGS[${__ARGS_ARGUMENT_NAME[$i]}]="$1"
            shift
        done
    fi
    if [ $# -ne 0 ]; then
        >&2 echo "$binary_name: extra argument(s) '$*'"
        return 1
    fi
    # Required
    for i in "${!__ARGS_OPTION_TYPE[@]}"; do
        if ${__ARGS_OPTION_REQUIRED[$i]}; then
            local name=""
            if [ -n "${__ARGS_OPTION_SHORT[$i]}" ]; then
                name="${__ARGS_OPTION_SHORT[$i]}"
            elif [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
                name="${__ARGS_OPTION_LONG[$i]}"
            fi
            if [ -z "${ARGS[$name]:-}" ]; then
                if [ -n "${__ARGS_OPTION_SHORT[$i]}" ]; then
                    >&2 echo "$binary_name: option '-$name' is required"
                elif [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
                    >&2 echo "$binary_name: option '--$name' is required"
                fi
                return 1
            fi
        fi
    done
    for i in "${!__ARGS_ARGUMENT_NAME[@]}"; do
        if ${__ARGS_ARGUMENT_REQUIRED[$i]}; then
            if [ -z "${ARGS[${__ARGS_ARGUMENT_NAME[$i]}]:-}" ]; then
                >&2 echo "$binary_name: argument '${__ARGS_ARGUMENT_NAME[$i]}' is required"
                return 1
            fi
        fi
    done
    # Default
    for i in "${!__ARGS_ARGUMENT_NAME[@]}"; do
        if [ -z "${ARGS[${__ARGS_ARGUMENT_NAME[$i]}]:-}" ]; then
            if [ -n "${__ARGS_ARGUMENT_DEFAULT[$i]}" ]; then
                ARGS[${__ARGS_ARGUMENT_NAME[$i]}]="${__ARGS_ARGUMENT_DEFAULT[$i]}"
            fi
        fi
    done
    local name=""
    for i in "${!__ARGS_OPTION_TYPE[@]}"; do
        if [ -n "${__ARGS_OPTION_SHORT[$i]}" ]; then
            name="${__ARGS_OPTION_SHORT[$i]}"
        elif [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
            name="${__ARGS_OPTION_LONG[$i]}"
        fi
        if [ -z "${ARGS[$name]:-}" ]; then
            if [ -n "${__ARGS_OPTION_DEFAULT[$i]}" ]; then
                if [ -n "${__ARGS_OPTION_SHORT[$i]}" ]; then
                    ARGS[${__ARGS_OPTION_SHORT[$i]}]="${__ARGS_OPTION_DEFAULT[$i]}"
                fi
                if [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
                    ARGS[${__ARGS_OPTION_LONG[$i]}]="${__ARGS_OPTION_DEFAULT[$i]}"
                fi
            fi
        fi
    done
    # Dest
    for i in "${!__ARGS_OPTION_TYPE[@]}"; do
        if [ -n "${__ARGS_OPTION_DEST[$i]}" ]; then
            if [ -n "${__ARGS_OPTION_SHORT[$i]}" ]; then
                declare -g "${__ARGS_OPTION_DEST[$i]}=${ARGS[${__ARGS_OPTION_SHORT[$i]}]:-}"
            elif [ -n "${__ARGS_OPTION_LONG[$i]}" ]; then
                declare -g "${__ARGS_OPTION_DEST[$i]}=${ARGS[${__ARGS_OPTION_LONG[$i]}]:-}"
            fi
        fi
    done
    for i in "${!__ARGS_ARGUMENT_NAME[@]}"; do
        if [ -n "${__ARGS_ARGUMENT_DEST[$i]}" ]; then
            declare -g "${__ARGS_ARGUMENT_DEST[$i]}=${ARGS[${__ARGS_ARGUMENT_NAME[$i]}]:-}"
        fi
    done
}

# Clean argparser global vairables at source
args_clean
