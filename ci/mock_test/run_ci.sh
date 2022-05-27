#!/bin/bash -xe

#
# Mock NEPTUNE CI test
#

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

EXPER01=${CI_RUN}

# run_test ${CI_DIR} ${CI_RUN} succeed output_matrix_file_accurate good_timing
# run_test ${CI_DIR} ${CI_RUN} fail output_matrix_file_accurate good_timing
run_test ${CI_DIR} ${CI_RUN} succeed output_matrix_file_inaccurate good_timing

set +x
echo
echo "*********************************************************"
echo "*                                                       *"
echo "*   Execution of mock neptune_fcst test successful      *"
echo "*                                                       *"
echo "*********************************************************"
set -x

#------------------------------------------------------------------
# Test data results
#------------------------------------------------------------------
set +x
echo
echo "***********************************************************"
echo "*                                                         *"
echo "*                  Test data results                      *"
echo "*                                                         *"
echo "*                      STARTED                            *"
echo "*                                                         *"
echo "***********************************************************"
set -x

python ${BIN_DIR}/check_data_result.py ${CI_RUN}/matrix.txt

set +x
echo
echo "***********************************************************"
echo "*                                                         *"
echo "*                  Test data results                      *"
echo "*                                                         *"
echo "*                     SUCCESSFUL                          *"
echo "*                                                         *"
echo "***********************************************************"
set -x


