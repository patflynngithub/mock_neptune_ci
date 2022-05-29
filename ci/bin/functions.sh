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
(
  CI_DIR=${1}
  CI_RUN=${2}
  CI_SUCCESS=${3}
  CI_DATA_ACCURACY=${4}
  CI_TIMING=${5}

  cd ${CI_RUN}

  ./neptune_fcst.exe ${CI_SUCCESS} ${CI_DATA_ACCURACY} ${CI_TIMING}
)
}

function compare_test {
(
  CI_DATA1=${1}
  CI_DATA2=${2}
  log_file=${3-compare.log}

  python ${BIN_DIR}/compare_fields.py ${CI_DATA1} ${CI_DATA2} >> ${log_file}
)
}

function assess_test_data_diffs {(

  diff_result_file=${1-compare.log}

  if $(grep -q "data is accurate" $diff_result_file) ; then
    echo "Data is accurate: " $diff_result_file
    return 0
  elif $(grep -q "data is inaccurate" $diff_result_file) ; then
    echo "Data is inaccurate: " $diff_result_file
    return 1
  else
    echo "No \"no data is ...\" line in $diff_result_file to indicate"
    echo " data accuracy" 
    return 1
  fi 
)}

function assess_test_timing {
(
  # NOTE: before calling this function, if one has multiple runs of a test to
  #       assess the timing of and want to assess all these runs regardless of
  #       whether one of the runs fails their timing assessment, do a "set +e"
  #       to turn off automatically stopping bash script execution when a
  #       nonzero exit code is returned. "set -e" can be used to turn back on
  #       the automatic stopping of execution if needed.

  TIMING_FILE=${1-undefined}
  TIMING_CELING=${2--1}

  python ${BIN_DIR}/assess_timing.py ${TIMING_FILE} ${TIMING_CEILING}
)
}

