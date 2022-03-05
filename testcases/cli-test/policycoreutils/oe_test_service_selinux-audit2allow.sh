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
# @Date      :   2022/02/25
# @License   :   Mulan PSL v2
# @Desc      :   Test restorecond.service restart
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
# 需要预加载的数据、参数配置
function config_params() {
    LOG_INFO "Start to config params of the case."
    LOG_INFO "No params need to config."
    LOG_INFO "End to config params of the case."
}
# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "No pkgs need to install."
    LOG_INFO "End to prepare the test environment."
}
# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    #查看允许被拒绝的类型强制规则
    audit2allow -a
    CHECK_RESULT $?
    #创建一个自定义模块,其中 -M 选项将创建一个特定名称的强制类型文件（.te），并编译这个规则到一个策略包（.pp）中：mypolicy.pp mypolicy.te
    audit2allow -a -M mypolicy
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}
# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "Nothing to do."
    LOG_INFO "End to restore the test environment."
}
main "$@"
