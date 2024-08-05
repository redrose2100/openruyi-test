#!/bin/bash
# Copyright (c), 2024-2024, Huawei Tech. Co., Ltd.
# Description: pip安装参数extra-index-url风险提示
# Author: xieshouhang <xieshouhang@huawei-partners.com>
# Create: 2024-08-02
# History:

source "${OET_PATH}"/libs/locallibs/common_lib.sh
set +e
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    which pip3 || yum install -y python3-pip
    LOG_INFO "End to prepare the test environment."
}

function do_test() {
    LOG_INFO "Start testing..."
    pip3 install --help | grep "extra-index-url"
    CHECK_RESULT $? 0 0 
    pip3 install --extra-index-url="http://test" > tmp_log 2>&1
    cat tmp_log | grep "WARNING: When the --extra-index-url"
    CHECK_RESULT $? 0 0 
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    id=$(yum history | grep "install -y python3-pip" | head -n1 | awk '{print $1}')
    [ -z "${id}" ] || yum history undo -y "$id"
    rm -fr tmp_log
    LOG_INFO "End to clean the test environment."
}

main "$@"
