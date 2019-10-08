#!/usr/bin/env bash

# TFHOME can be like, for example, /usr/local/bin
TF=${TFHOME}/terraform

if [ ! -x "${TF}" ]; then
  if [ "${TFHOME}" ]; then
    echo "terraform not found. TFHOME is ${TFHOME}"
    exit 1
  else
    echo "TFHOME is not set."
    exit 1
  fi
fi

modules=(
  vpc
  iam
  harbor
  jenkins
)

do_init() {
  echo ""
  return $?
}

do_apply() {
  echo ""
  return $?
}

do_build() {
  module=$(pwd)
  echo "In module dir, ${module}"
  do_init
  do_apply 
  return $?
}

do_build_stack() {
  for i in "${modules[@]}"
  do
    echo "do_build_stack(): Building stack ${i}..."
    cd "${i}" && 
    do_build "${i}" &&
    cd ..
    err=$?
    if [[ ${err} -ne 0 ]]; then do_error "Error building stack ${i}"; fi
  done
  return ${err}
}

do_clean_stack() {
  echo ""
  return $?
}

do_destroy_stack() {
  echo ""
  return $?
}

do_error() {
  echo ""
  return $?
}

do_help() {
  echo -e "\nUsage: $0 [stack-subcommand]"
  echo -e "\nExamples: "
  echo -e "\n$0 build_stack"
  echo -e "\n$0 clean_stack"
  echo -e "\n$0 destroy_stack"
  echo ""
}

do_show() {
  echo "Output the key variables"
}

homedir=$(pwd)
SUBCOMMAND=$1
shift

if [[ -z ${SUBCOMMAND} ]]; then
  echo "Error: Need to specify SUBCOMMAND"
  echo ""
  do_help
  exit 1
fi

case ${SUBCOMMAND} in
    "" | "-h" | "--help")
        do_help
        ;;
    "show")
         do_show
         exit 0
         ;;
    *_stack)
         #config_access
         "do_${SUBCOMMAND}" "$@" 2>/dev/null
         retv=$?
         cd "${homedir}" || exit 1
         do_error ${retv}
         ;;
esac
