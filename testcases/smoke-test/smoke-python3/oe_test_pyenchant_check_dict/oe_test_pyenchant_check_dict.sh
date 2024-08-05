#!/bin/bash
# Copyright (c), 2024-2024, Huawei Tech. Co., Ltd.
# Description: pyenchant基础功能验证，检查字典
# Author: xieshouhang <xieshouhang@huawei-partners.com>
# Create: 2024-08-02
# History:

source "${OET_PATH}"/libs/locallibs/common_lib.sh
set +e 
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    yum install -y python3-enchant
    LOG_INFO "End to prepare the test environment."
}

function do_test() {
    LOG_INFO "Start testing..."
    python3 -c "import enchant;d=enchant.Dict('en_US');print(d.check('hello'));print(d.check('enchant'))" > tmp_log
    count=$(grep True tmp_log | wc -l)
    CHECK_RESULT "$count" 2
    python3 -c "import enchant;d=enchant.Dict('en_US');print(d.check('helol'));print(d.check('enchnt'))" > tmp_log
    count=$(grep False tmp_log | wc -l)
    CHECK_RESULT "$count" 2
    python3 -c "import enchant;d=enchant.Dict('en_US');print(d.suggest('enchnt'))" > tmp_log
    grep enchant tmp_log
    CHECK_RESULT $? 0 0
    grep entrench tmp_log
    CHECK_RESULT $? 0 0
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    id=$(yum history | grep "install -y python3-enchant" | head -n1 | awk '{print $1}')
    [ -z "${id}" ] || yum history undo -y "$id"
    rm -fr tmp_log
    LOG_INFO "End to clean the test environment."
}

main "$@"

