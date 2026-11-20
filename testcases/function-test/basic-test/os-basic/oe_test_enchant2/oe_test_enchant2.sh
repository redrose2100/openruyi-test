#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Elvis-surfing
# @Contact   :   huzheyuan@uniontech.com
# @Date      :   2023-11-14
# @License   :   Mulan PSL v2
# @Desc      :   enchant test
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # enchant 只是抽象层，-d en_US 需要实际的 hunspell 词典，
    # 缺 hunspell-en 时 -a 管道模式没有任何输出。
    DNF_INSTALL "enchant hunspell-en"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    enchant-2 -v |grep Version    
    CHECK_RESULT $? 0 0 "check command fail" 
    enchant-lsmod-2 | grep hunspell    
    CHECK_RESULT $? 0 0 "Language module detection failed"
    enchant-2 -h 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "check command fail"
    echo "there is a testj" > /tmp/test.txt
    # -a 是 ispell 兼容的管道模式，只会把拼错的单词以 "& 单词 ..." 的
    # 形式返回，不会回显原文。断言改为输出中存在该错词。
    enchant_out=$(enchant-2 -d en_US -a /tmp/test.txt 2>&1)
    echo "${enchant_out}" | grep "testj"
    CHECK_RESULT $? 0 0 "check spelling failed: ${enchant_out}"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
