#!/bin/bash -xe

NEPTUNE_TOP=$(readlink -f ${NEPTUNE_TOP:=../../})
CI_DIR=$(readlink -f ${CI_TEST:=./})
COMPARE_LOG=compare.log

# directory where each test's execution/results directory is placed
: ${WORKDIR:=${CI_DIR}}

export MAKE_TARGET=all
export NEPTUNE_TARGET=neptune_fcst
export BIN_DIR=${NEPTUNE_TOP}/ci/bin

. ${BIN_DIR}/functions.sh

set +x
echo
echo "*********************************************************"
echo "*                                                       *"
echo "*                BUILD neptune_fcst                     *"
echo "*                                                       *"
echo "*                     STARTED                           *"
echo "*                                                       *"
echo "*********************************************************"
set -x

build_neptune_fcst ${NEPTUNE_TOP} ${CI_DIR}


