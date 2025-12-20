#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.
# #############################################
# @Author    :   wangsongsong
# @Contact   :   ss_wang@foxmail.com 
# @Date      :   2022/03/06
# @License   :   Mulan PSL v2
# @Desc      :   Test saved_model_cli 
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    get_tensorflow
    LOG_INFO "End to prepare the test environment."
}
# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    #显示深度学习训练面板
    firewall-cmd --zone=public --add-port=6006/tcp --permanent
    firewall-cmd --reload
    systemctl restart firewalld
    nohup tensorboard --logdir ./tensorboard_log --bind_all >tensorboard.log 2>&1 &
    SLEEP_WAIT 10
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}
# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."
    unset LD_LIBRARY_PATH
    DNF_REMOVE 
    firewall-cmd --zone=public --remove-port=6006/tcp --permanent
    LOG_INFO "End to restore the test environment."
}
main "$@"
