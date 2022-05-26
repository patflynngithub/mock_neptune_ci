#!/bin/bash

# BASH functions used by all the run_ci.sh CI testing scripts

: ${HOST:=sandy}

function build_neptune_fcst {
(
  NEPTUNE_DIR=${1}
  CI_DIR=${2}

  cd ${NEPTUNE_TOP}

#CLEAN: 2 -- deepclean and then make all
#CLEAN: 1 -- clean and then make ${MAKE_TARGET}
#CLEAN: 0 -- do not clean, but link executable.
#CLEAN:-1 -- do not clean, do not link (useful when submit lots of runs).

: ${CLEAN:=1}
: ${MAKE_TARGET:=neptune_fcst}
: ${NEPTUNE_TARGET:=neptune_fcst}
: ${NEPTUNE_MAKEFILE:=Makefile}

  case "${CLEAN}" in
    1) 
      make -f ${NEPTUNE_MAKEFILE} clean ;;
    2) 
      make -f ${NEPTUNE_MAKEFILE} deepclean
      MAKE_TARGET=all
      ;;
  esac

  if [ $CLEAN -ge 0 ] ; then
    make -j8 -f ${NEPTUNE_MAKEFILE} ${MAKE_TARGET} |& tee make.log
    if [ ${PIPESTATUS[0]} -ne "0" ]; then
      echo 'Build error.  Check make.log file'
      exit -1
    fi
  fi

  if [ -e ${NEPTUNE_TOP}/build/bin/${NEPTUNE_TARGET}.exe ]; then
    cp ${NEPTUNE_TOP}/build/bin/${NEPTUNE_TARGET}.exe ${CI_DIR}
  fi
)
}

function setup_test {
(
  CI_DIR=${1}
  CI_RUN=${2}

  rm -rf ${CI_RUN}
  mkdir -p ${CI_RUN}

: ${NEPTUNE_TARGET:=neptune_fcst}

  if [ -e ${CI_DIR}/${NEPTUNE_TARGET}.exe ]; then
    cp ${CI_DIR}/${NEPTUNE_TARGET}.exe ${CI_RUN}
  fi
)
}

function run_test {
  CI_DIR=${1}
  CI_RUN=${2}

: ${SETUP_TEST:=1}
: ${HOST:=sandy}
: ${STRIPE_COUNT:=0}
: ${STRIPE_SIZE:=0}
: ${ACCOUNT:=NRLMR46355YFM}
: ${QUEUE:=frontier}

  #If dealing with lustre file system, set the stripe count and size.
  type lfs &> /dev/null && echo lfs setstripe -c ${STRIPE_COUNT} -S ${STRIPE_SIZE} ${CI_RUN}

  cd ${CI_RUN}

  ./neptune_fcst.exe succeed output_matrix_file_accurate good_timing
}
