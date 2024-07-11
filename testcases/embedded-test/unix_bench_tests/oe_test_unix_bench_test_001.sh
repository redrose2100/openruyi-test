#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   saarloos
# @Contact   :   9090-90-90-9090@163.com
# @Modify    :   9090-90-90-9090@163.com
# @Date      :   2024/07/08
# @License   :   Mulan PSL v2
# @Desc      :   auto run embedded unix bench test
# #############################################
# shellcheck disable=SC1091,SC1090,SC2034
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    EXECUTE_T="1440m"

    if [ -z "${SDK_PATH}" ]; then
        LOG_WARN "not set sdk path"
    else
        sdk_file=$(find "${SDK_PATH}" -name "environment-*")
        source "${sdk_file}"
    fi

    current_path=$(
    cd "$(dirname "$0")" || exit 1
    pwd)

    rm -rf test-tools
    git clone https://gitee.com/saarloos/test-tools.git -v test-tools -b master
    pushd  test-tools || exit 1
    unzip UnixBench.zip
    pushd  UnixBench || exit 1
    if [ -n "${SDK_PATH}" ]; then
        make clean
        make
    fi
    sed -i "1767d" Run
    sed -i "173d" Run
    popd || exit 1

    zip -r put_unipriton.zip UnixBench

    SFTP put --node 1 --remotedir "/root/" --localdir "${current_path}/test-tools/"  --localfile "make.zip"
    SFTP put --node 1 --remotedir "/root/" --localdir "${current_path}/test-tools/"  --localfile "perl.zip"
    SFTP put --node 1 --remotedir "/root/" --localdir "${current_path}/test-tools/"  --localfile "put_unipriton.zip"

    P_SSH_CMD --node 1 --cmd "\
    cd /root/ && \
    unzip -o perl.zip && \
    unzip -o make.zip && \
    unzip -o put_unipriton.zip && \
    \cp -rfp /root/perl/* /root/make/* / && \
    cd /root/UnixBench && \
    chmod 777 ./Run && \
    rm -rf /root/logs && \
    mkdir -p /root/logs/"
    CHECK_RESULT $? 0 0 "pre test fail"

    popd || exit 1

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    P_SSH_CMD --node 1 --cmd "\
    cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq > /root/logs/cur_freq_1.txt"
    CHECK_RESULT $? 0 0 "get 0.6 ub freq fail"
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "cur_freq_1.txt" --localdir "${current_path}/"
    cat cur_freq_1.txt || grep 600000
    CHECK_RESULT $? 0 0 "run ub freq not 600000"

    P_SSH_CMD --node 1 --cmd "\
    cd /root/UnixBench && \
    ./Run -c 1 -c \`nproc\` -i 3 > /root/logs/test_1_1.log && \
    ./Run -c 1 -c \`nproc\` -i 3 > /root/logs/test_1_2.log && \
    ./Run -c 1 -c \`nproc\` -i 3 > /root/logs/test_1_3.log"
    CHECK_RESULT $? 0 0 "run 0.6 ub fail"
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "test_1_1.log" --localdir "${current_path}/"
    echo "==================== test_1_1.log ===================="
    cat test_1_1.log
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "test_1_2.log" --localdir "${current_path}/"
    echo "==================== test_1_2.log ===================="
    cat test_1_2.log
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "test_1_3.log" --localdir "${current_path}/"
    echo "==================== test_1_3.log ===================="
    cat test_1_3.log

    P_SSH_CMD --node 1 --cmd "\
    cd /root/UnixBench && \
    echo \"performance\" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor && \
    cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq > /root/logs/cur_freq_2.txt"
    CHECK_RESULT $? 0 0 "get 1.5 ub freq fail"
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "cur_freq_2.txt" --localdir "${current_path}/"
    cat cur_freq_2.txt || grep 1500000
    CHECK_RESULT $? 0 0 "run ub freq not 1500000"

    P_SSH_CMD --node 1 --cmd "\
    cd /root/UnixBench && \
    ./Run -c 1 -c \`nproc\` -i 3 > /root/logs/test_2_1.log && \
    ./Run -c 1 -c \`nproc\` -i 3 > /root/logs/test_2_2.log && \
    ./Run -c 1 -c \`nproc\` -i 3 > /root/logs/test_2_3.log"
    CHECK_RESULT $? 0 0 "run 1.5 ub fail"
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "test_2_1.log" --localdir "${current_path}/"
    echo "==================== test_2_1.log ===================="
    cat test_2_1.log
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "test_2_2.log" --localdir "${current_path}/"
    echo "==================== test_2_2.log ===================="
    cat test_2_2.log
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "test_2_3.log" --localdir "${current_path}/"
    echo "==================== test_2_3.log ===================="
    cat test_2_3.log

    P_SSH_CMD --node 1 --cmd "\
    mkdir -p /root/boot && \
    mount /dev/mmcblk0p1 /root/boot && \
    cp /root/boot/config.txt /root/config.txt.bak && \
    echo \"\"  >> /root/boot/config.txt && \
    echo \"over_voltage=3\"  >> /root/boot/config.txt && \
    echo \"\"  >> /root/boot/config.txt && \
    echo \"arm_freq=1800\"  >> /root/boot/config.txt && \
    echo \"\" >> /root/boot/config.txt"
    CHECK_RESULT $? 0 0 "set 1.8 ub fail"

    P_SSH_CMD --node 1 --cmd "reboot"
    SLEEP_WAIT 15

    P_SSH_CMD --node 1 --cmd "\
    cd /root/UnixBench && \
    echo \"performance\" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor && \
    cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq > /root/logs/cur_freq_3.txt"
    CHECK_RESULT $? 0 0 "get 1.8 ub freq fail"
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "cur_freq_3.txt" --localdir "${current_path}/"
    cat cur_freq_3.txt || grep 1800000
    CHECK_RESULT $? 0 0 "run ub freq not 1800000"

    P_SSH_CMD --node 1 --cmd "\
    cd /root/UnixBench && \
    ./Run -c 1 -c \`nproc\` -i 3 > /root/logs/test_3_1.log && \
    ./Run -c 1 -c \`nproc\` -i 3 > /root/logs/test_3_2.log && \
    ./Run -c 1 -c \`nproc\` -i 3 > /root/logs/test_3_3.log"
    CHECK_RESULT $? 0 0 "run 1.8 ub fail"
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "test_3_1.log" --localdir "${current_path}/"
    echo "==================== test_3_1.log ===================="
    cat test_3_1.log
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "test_3_2.log" --localdir "${current_path}/"
    echo "==================== test_3_2.log ===================="
    cat test_3_2.log
    SFTP get --node 1 --remotedir "/root/logs" --remotefile "test_3_3.log" --localdir "${current_path}/"
    echo "==================== test_3_3.log ===================="
    cat test_3_3.log

    echo "========================================================================="
    python3 ana_ub_score.py -f test_1_1.log test_1_2.log test_1_3.log
    python3 ana_ub_score.py -f test_2_1.log test_2_2.log test_2_3.log
    python3 ana_ub_score.py -f test_3_1.log test_3_2.log test_3_3.log
    echo "========================================================================="

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf "${current_path}"/test-tools
    rm -rf "${current_path}"/*.log
    rm -rf "${current_path}"/*.txt

    P_SSH_CMD --node 1 --cmd "\
    mount /dev/mmcblk0p1 /root/boot && \
    cp /root/config.txt.bak /root/boot/config.txt && \
    umount /root/boot && \
    rm -rf /root/perl /root/make /root/UnixBench /root/make.zip /root/perl.zip /root/put_unipriton.zip"
    P_SSH_CMD --node 1 --cmd "reboot"
    SLEEP_WAIT 15

    LOG_INFO "End to restore the test environment."
}

main "$@"