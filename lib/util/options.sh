#!/bin/bash
set -euo pipefail

## Adapted from https://github.com/nk412/optparse

options_usage=""
options_contractions=""
options_defaults=""
options_process=""
options_arguments_string=""

invalid_options() {
  echo "OPTPARSE: ERROR: ${1}" && exit 1
}

define_option() {
  if [ $# -lt 3 ]; then invalid_options "define_option <short> <long> <variable> [<desc>] [<default>] [<value>]"; fi

  for arg in $(seq 1 $#) ; do
    local option="$(eval "echo \$${arg}")"
    local key="$(echo ${option} | awk -F "=" '{print $1}')";
    local value="$(echo ${option} | awk -F "=" '{print $2}')";

    #essentials: shortname, longname, description
    if [ "$key" = "desc" ]; then local desc="$value"
    elif [ "$key" = "default" ]; then local default="$value"
    elif [ "$key" = "variable" ]; then local variable="$value"
    elif [ "$key" = "value" ]; then local val="$value"
    elif [ "$key" = "short" ]; then
      local shortname="$value"
      local short="-${shortname}"
      if [ ${#shortname} -ne 1 ]; then invalid_options "short name expected to be one character long"; fi
    elif [ "$key" = "long" ]; then
      local longname="$value"
      local long="--${longname}"
      if [ ${#longname} -lt 2 ]; then invalid_options "long name expected to be atleast one character long"; fi
    fi
  done

  local default="${default:-}"
  local val="${val:-}"

  if [ -z "${variable}" ]; then invalid_options "You must give a variable for option: ($short/$long)"; fi
  if [ -z "${val}" ]; then local val="\$OPTARG"; fi

  # build OPTIONS and help
  options_usage="${options_usage}#NL ${short},$(printf "%-25s %s" "${long}" "${desc}")"
  if [ -n "${default}" ]; then options_usage="${options_usage} [default:$default]"; fi

  options_contractions="${options_contractions}#NL#TB#TB${long})#NL#TB#TB#TBparams=\"\$params ${short}\";;"
  if [ -n "${default}" ]; then options_defaults="${options_defaults}#NL${variable}=${default}"; fi

  options_arguments_string="${options_arguments_string}${shortname}"
  if [ "${val}" = "\$OPTARG" ]; then options_arguments_string="${options_arguments_string}:"; fi

  options_process="${options_process}#NL  ${shortname}) ${variable}=\"$val\";;"
}

build_options() {
  local build_file="$(mktemp -u)"

  # Building getopts header here

  # Function usage
  cat << EOF > $build_file
  function usage(){
    cat << XXX
usage: \$0 [OPTIONS]

OPTIONS:
$options_usage

-? --help                    Display this message
XXX
  }

  # Contract long options into short options
  params=""
  while [ \$# -ne 0 ]; do
    param="\$1"
    shift

    case "\$param" in
      $options_contractions
      "-?"|--help)
      usage
      exit 0;;
    *)
      if [[ "\$param" == --* ]]; then
        echo -e "Unrecognized long option: \$param"
        usage
        exit 1
      fi
      params="\$params \"\$param\"";;
  esac
done

eval set -- "\$params"

# Set default variable values
$options_defaults

# Process using getopts
while getopts "$options_arguments_string" option; do
  case \$option in
    $options_process
    :) echo "Option - \$OPTARG requires an argument"; exit 1;;
    *) usage; exit 1;;
  esac
done

# Clean up after self
rm $build_file

EOF

  if osx; then
    sed -i "" 's/#NL/\'$'\n/g' $build_file
    sed -i "" 's/#TB/\'$'\t/g' $build_file
  else
    local -A o=( ['#NL']='\n' ['#TB']='\t' )
    for i in "${!o[@]}"; do sed -i "s/${i}/${o[$i]}/g" $build_file; done
  fi

  # Unset global variables
  unset options_usage
  unset options_process
  unset options_arguments_string
  unset options_defaults
  unset options_contractions

  # Return file name to parent
  echo "${build_file}"
}
