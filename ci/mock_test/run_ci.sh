#!/bin/bash -xe

# note that, because of above bash setting, that the shell script
# will automatically stop on nonzero exit code

#
# Mock NEPTUNE CI test
#

# ================================================================

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
echo "*                BUILD mock neptune_fcst                *"
echo "*                                                       *"
echo "*                     STARTED                           *"
echo "*                                                       *"
echo "*********************************************************"
set -x

build_neptune_fcst ${NEPTUNE_TOP} ${CI_DIR}

set +x
echo
echo "#########################################################"
echo "#                                                       #"
echo "#                  BUILD mock neptune_fcst              #"
echo "#                                                       #"
echo "#                     SUCCESSFUL                        #"
echo "#                                                       #"
echo "#########################################################"
set -x

# ------

cd ${CI_DIR}
rm -rf ${COMPARE_LOG}
touch ${COMPARE_LOG}

#------------------------------------------------------------------
# Execute mock neptune_fcst test
#------------------------------------------------------------------
set +x
echo
echo "*********************************************************"
echo "*                                                       *"
echo "*          Execute mock neptune_fcst test               *"
echo "*                                                       *"
echo "*********************************************************"
set -x

test_dir=mock_neptune_fcst_test
CI_RUN=${WORKDIR}/$(basename ${CI_DIR})/${test_dir}
rm -f ${CI_DIR}/${test_dir}
ln -sf ${CI_RUN} ${CI_DIR}/${test_dir}

setup_test ${CI_DIR} ${CI_RUN}

# save CI_RUN is case there are ever multiple test runs
EXPER=${CI_RUN}

# run_test ${CI_DIR} ${CI_RUN} succeed output_matrix_file_accurate good_timing
# run_test ${CI_DIR} ${CI_RUN} fail output_matrix_file_accurate good_timing
# run_test ${CI_DIR} ${CI_RUN} succeed output_matrix_file_inaccurate good_timing
run_test ${CI_DIR} ${CI_RUN} succeed output_matrix_file_accurate bad_timing

set +x
echo
echo "*********************************************************"
echo "*                                                       *"
echo "*   Execution of mock neptune_fcst test successful      *"
echo "*                                                       *"
echo "*********************************************************"
set -x

#------------------------------------------------------------------
# Generate data differences between 1 and 2 threads tests data results
#------------------------------------------------------------------

set +x
echo
echo "**************************************************************"
echo "*                                                            *"
echo "* Generate data differences between baseline and data result *"
echo "*                                                            *"
echo "*                      STARTED                               *"
echo "*                                                            *"
echo "**************************************************************"
set -x

compare_test ${EXPER}/baseline_matrix.txt ${EXPER}/data_result_matrix.txt ${COMPARE_LOG}

set +x
echo
echo "**************************************************************"
echo "*                                                            *"
echo "* Generate data differences between baseline and data result *"
echo "*                                                            *"
echo "*                     FINISHED                               *"
echo "*                                                            *"
echo "**************************************************************"
set -x

#------------------------------------------------------------------
# Assess data differences between baseline and data result
#------------------------------------------------------------------

set +x
echo
echo "************************************************************"
echo "*                                                          *"
echo "* Assess data differences between baseline and data result *"
echo "*                                                          *"
echo "*                      STARTED                             *"
echo "*                                                          *"
echo "************************************************************"
set -x

assess_test_data_diffs ${COMPARE_LOG}

set +x
echo
echo "************************************************************"
echo "*                                                          *"
echo "* Assess data differences between baseline and data result *"
echo "*                                                          *"
echo "*                     SUCCESSFUL                           *"
echo "*                                                          *"
echo "************************************************************"
set -x

#------------------------------------------------------------------
# Assess test execution timing(s)
#------------------------------------------------------------------
 
set +x
echo
echo "*********************************************************"
echo "*                                                       *"
echo "*           Assess test execution timings               *"
echo "*                                                       *"
echo "*                     STARTED                           *"
echo "*                                                       *"
echo "*********************************************************"
set -x

overall_timing_success=0

set +e  # allows all timing assessments to be done despite failure
        # in one of them

# ------------

# Mock Test Execution Timing Assessment

set +x
echo
echo "*********************************************************"
echo "*                                                       *"
echo "*         Assess mock test execution timing             *"
echo "*                                                       *"
echo "*                     STARTED                           *"
echo "*                                                       *"
echo "*********************************************************"
set -x

TIMING_CEILING=100
assess_test_timing ${EXPER}/nep.error.000000 ${TIMING_CEILING}
timing_success=$?

if [ $timing_success -ne 0 ]; then
  overall_timing_success=$timing_success
  echo "Timing assessment exit code: $timing_success"
  echo "Timing ceiling exceeded in ${EXPER}."
  set +x
  echo
  echo "#########################################################"
  echo "#                                                       #"
  echo "#        Assess mock test execution timing              #"
  echo "#                                                       #"
  echo "#                     FAILURE                           #"
  echo "#                                                       #"
  echo "#########################################################"
  set -x
else
  set +x
  echo
  echo "#########################################################"
  echo "#                                                       #"
  echo "#        Assess mock test execution timing              #"
  echo "#                                                       #"
  echo "#                     SUCCESS                           #"
  echo "#                                                       #"
  echo "#########################################################"
  set -x
fi

# -----------

if [ $overall_timing_success -eq 0 ]; then
   set +x
   echo
   echo "#########################################################"
   echo "#                                                       #"
   echo "#           Assess all test executions timings          #"
   echo "#                                                       #"
   echo "#                     SUCCESS                           #"
   echo "#                                                       #"
   echo "#########################################################"
   set -x
else
   set +x
   echo
   echo "#########################################################"
   echo "#                                                       #"
   echo "#           Assess all test executions timings          #"
   echo "#                                                       #"
   echo "#             FAILURE (at least one timing test failed) #"
   echo "#                                                       #"
   echo "#########################################################"
   set -x
   exit 1 
fi

#------------------------------------------------------------------
# Successfull Build and Testing!!!
#------------------------------------------------------------------
 
set +x
echo
echo "#########################################################"
echo "#                                                       #"
echo "#             Successful Build and Testing              #"
echo "#                                                       #"
echo "#########################################################"
echo
set -x

