#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2. 
# You can use it according to the terms and conditions of the Mulan PSL v2. 
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   fanghongsong
# @Contact   :   fanghongsong4@h-partners.com
# @Date      :   2023.06.30
# @License   :   Mulan PSL v2
# @Desc      :   ltp testsuite
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="120m"
    DNF_INSTALL "zlib gcc-c++ bc m4 flex byacc bison keyutils-libs-devel lksctp-tools-devel xfsprogs-devel libacl-devel openssl-devel numactl-devel libaio-devel glibc-devel libcap-devel findutils libtirpc libtirpc-devel kernel-headers glibc-headers hwloc-devel patch numactl tar make automake cmake time psmisc"
    echo 'export LANG=en_US.UTF-8' >> /root/.bashrc
    source /root/.bashrc
    hostnamectl set-hostname localhost
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /opt
    until [ -e "ltp" ]
    do
        git clone -b 20210927 https://github.com/linux-test-project/ltp.git
    done

    cd ltp/testcases/open_posix_testsuite
    make all 
    echo "----start All confromance test ----"
    make conformance-test > /opt/posix_conformance_result.txt
    pcnt=$(grep PASS /opt/posix_conformance_result.txt | awk '{print $2}' | awk '{sum +=$1}; END {print sum}')
    fcnt=$(grep FAIL /opt/posix_conformance_result.txt | awk '{print $2}' | awk '{sum +=$1}; END {print sum}')
    tcnt=$(grep TOTAL /opt/posix_conformance_result.txt | awk '{print $2}' | awk '{sum +=$1}; END {print sum}')
    echo "the success rate is:"
    awk 'BEGIN{printf "%.3f%\n", ('$pcnt'/'$tcnt')*100}'
    rate=`awk 'BEGIN{printf "%.5f\n", ('$pcnt'/'$tcnt')}'`
    if [ `awk -v rate=$rate 'BEGIN{print(rate>0.97)?"0":"1"}'` ];then
        echo "testcases pass rate meets expectation"
    else
        echo "testcases pass rate not meets expectation"
        exit 1
    fi
    echo "---- End All confromance test ----"

    echo "---- start Asynchronous I/O test ----"
    cd bin 
    ./run-all-posix-option-group-tests.sh AIO >/opt/AIO.txt
    pcnt=$(grep PASS /opt/AIO.txt | awk '{print $2}' | awk '{sum +=$1}; END {print sum}')
    fcnt=$(grep FAIL /opt/AIO.txt | awk '{print $2}' | awk '{sum +=$1}; END {print sum}')
    tcnt=$(grep TOTAL /opt/AIO.txt | awk '{print $2}' | awk '{sum +=$1}; END {print sum}')
    echo "the success rate is:"
    awk 'BEGIN{printf "%.3f%\n", ('$pcnt'/'$tcnt')*100}'
    rate=`awk 'BEGIN{printf "%.5f\n", ('$pcnt'/'$tcnt')}'`
    if [ `awk -v rate=$rate 'BEGIN{print(rate>0.97)?"0":"1"}'` ];then
        echo "bin testcases pass rate meets expectation"
    else
        echo "bin testcases pass rate not meets expectation"
        exit 1
    fi
    echo "---- End Asynchronous I/O test ----"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE $@
    LOG_INFO "End to restore the test environment."
}
main $@
