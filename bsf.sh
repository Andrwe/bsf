#!/bin/bash
#
######################################################################
#
#                  Author: Andrwe Lord Weber
#                  Mail: lord-weber-andrwe <at> andrwe <dot> org
#                  Version: 0.1
#                  URL: http://andrwe.dyndns.org/doku.php/scripting/bash/bsf
#
##################
#
#                  Sumary: 
#                   Framework for bash scripting providing core
#                   function used in many scripts
#
######################################################################

######################################################################
#
#                 TODO:
#                  - implement:
#                     log
#                     debug
#                     wget (auto-nocheck)
#                     module based include
#                     dependency checking
#                     trap (trapstart, trapstop, Parameter: "command","signals")
#                     escaping
#                     comments
#                     usage (-h, -?)
#                     help-module (longhelp, shorthelp)
#                     parameter function (:-seperated list of parameters for module eg. log:syslog:serveraddress:port; - & :: = skip option)
#                     PID-management
#                  - rules:
#                     Knowledge (available functions, parameters, ...) about module has only the module itself
#
######################################################################

COREPATH="$(readlink -f $0)"
CONFIGPATH="${HOME}/.bsfrc"
LOADEDMODULES=()

echo ${COREPATH}
echo $@
echo $0


# load given module and all dependencies
function loadModule()
{
  local module="${1}"
  grep -xFf <(printf '%s\n' ${LOADEDMODULES[@]}) <<<${module} && return 0
  source "${BSFPATH}/${module}.sh" && LOADEDMODULES+="${module}" || return $?
  source "${BSFPATH}/doc/${module}.txt" || return $?
  for depend in $(grep "^m:" <(printf '%s\n' ${DEPENDS[@]}))
  do
    loadModule ${depend//m:/} || return $?
  done
  checkDepends $(grep -v "^m:" <(printf '%s\n' ${DEPENDS[@]})) || return $?
}

while getopts ":h?c:b:" opt
do
  case "${opt}" in
    "c")
      source "${OPTARG}"
      shift 2
    ;;
    "b")
      COREPATH="${OPTARG}"
      shift 2
    ;;
    "h"|"?")
      for module in "${BSFPATH}/"*.sh
      do
        echo $(basename ${module%.sh})
      done
      exit 0
    ;;
  esac
done

BSFPATH="${COREPATH%/*}"

for module in $@
do
  loadModule "${module}" || echo "Couldn't load module ${module}." >&2
done
