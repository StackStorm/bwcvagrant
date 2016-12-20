#!/bin/bash
#
# Vagrant script to Install the BWC
#
# Author: Mrigesh Priyadarshi

check_error()
{
  if [[ $? -gt 0 ]]; then
    error
  fi
}

error()
{
  echo "FATAL:: Something Went WRONG!!!"
  echo "FATAL:: Please Check Execution Logs...."
  exit 2
}

os_check()
{
    DEBTEST=$(lsb_release -a 2> /dev/null | grep Distributor | awk '{print $3}')
    RHTEST=$(cat /etc/redhat-release 2> /dev/null | sed -e "s~\(.*\)release.*~\1~g")

    if [[ -n "$RHTEST" ]]; then
      echo "INFO:: *** Detected Distro is ${RHTEST} ***"
      hash curl 2>/dev/null || { sudo yum install -y curl; sudo yum install -y nss; }
      sudo yum update -y curl nss
    elif [[ -n "$DEBTEST" ]]; then
      echo "INFO:: *** Detected Distro is ${DEBTEST} ***"
      sudo apt-get update
      sudo apt-get install -y curl
    else
      echo "FATAL:: Unknown Operating System."
      echo "FATAL:: See list of supported OSes: https://github.com/mrigeshpriyadarshi/bwcvagrant/blob/master/README.md."
      exit 2
    fi
}

check_license()
{
    if [[ ${1} != "" ]] || [[ ${1} != "bwc_license_key" ]]; then
      BWC_LICENSE_KEY="$1"
    else
      echo -e "FATAL:: Please pass the license, e.g. set env ENV['BWC_LICENSE']"
      exit 2
    fi
}

bwc_install()
{
  os_check
  curl -sSL https://brocade.com/bwc/install/install.sh | bash -s -- --user=${USER} --password=${PSSWD} --license=${BWC_LICENSE_KEY}
  check_error
}

bwc_install_suite()
{
  bwc_install
  curl -sSL https://brocade.com/bwc/install/install-suite.sh  | bash -s -- --user=${USER} --password=${PSSWD} --license=${BWC_LICENSE_KEY} --suite=dcfabric-suite
  check_error
}

setToken()
{
  export ST2_AUTH_TOKEN=$(st2 auth ${USER} -p ${PSSWD} -t)
}

#### Main Script ####
# Check argument passed and configure BWC accordingly
if [[ $# == 4 ]]; then
    USER=${1}
    PSSWD=${2}
    check_license "$3"
    if [[ $4 == 'false' ]]; then
      bwc_install
    else
      bwc_install_suite
    fi
else
      echo -e "FATAL:: Please pass the params, e.g. set env ENV['BWC_LICENSE'], ENV['ST2PASSWORD'] and ENV['BWC_SUITES']"
      error
fi
