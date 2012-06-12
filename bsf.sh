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
BSFPATH="${COREPATH%/*}"
CONFIGPATH="${BSFPATH}/bsf.config"
MODULEPATH="${BSFPATH}/module/"

while getopts ":h?" opt
do
  case "${opt}" in
    "h"|"?")
      for module in "${MODULEPATH}/"*
      do
        echo $(basename ${module%.sh})
      done
      exit 0
    ;;
  esac
done


for module in $@
do
  source "${MODULEPATH}/${module}.sh"
done

# vim:et:ai:ts=2
