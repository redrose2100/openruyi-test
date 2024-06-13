#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   linqian
#@Contact       :   1179362010@qq.com
#@Date          :   2024-06-06
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    LOG_INFO "安装oeAware-manager"
    DNF_INSTALL "oeAware-manager"

    LOG_INFO "启动服务"
    systemctl daemon-reload
    systemctl start oeaware
    systemctl status oeaware | grep "active (running)"
    CHECK_RESULT $? 0 0 "start oeaware failed"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    LOG_INFO "操作步骤１、重复加载插件"
    oeawarectl -r libthread_scenario.so | grep "Plugin remove successfully"
    oeawarectl -l libthread_scenario.so -t scenario | grep "Plugin loaded successfully"
    CHECK_RESULT $? 0 0 "Failed command: oeawarectl -l|--load"
    oeawarectl -l libthread_scenario.so -t scenario | grep "Plugin loaded failed, because plugin already loaded"
    CHECK_RESULT $? 0 0 "Plugin loaded error"
    LOG_INFO "预期结果１、加载失败"
    

    LOG_INFO "操作步骤２、加载不存在的插件"
    oeawarectl -l test.so -t collector | grep "Plugin loaded failed, because plugin file does not exist"
    CHECK_RESULT $? 0 0 "Plugin loaded error"
    LOG_INFO "预期结果２、加载失败"
   
    LOG_INFO "操作步骤３、查询不存在的插件实例"
    oeawarectl --query test.so | grep "Plugin query failed, because plugin does not exist"
    CHECK_RESULT $? 0 0 "Plugin query error"
    LOG_INFO "预期结果3、查询失败"
    
    LOG_INFO "操作步骤４、使能不存在的插件"
    oeawarectl -e test | grep "Instance enabled failed, because instance is not loaded"
    CHECK_RESULT $? 0 0 "Instance enabled error"
    LOG_INFO "预期结果4、使能失败"
    
    LOG_INFO "操作步骤５、禁用不存在的插件"
    oeawarectl -d test | grep "Instance disabled failed, because instance is not loaded"
    CHECK_RESULT $? 0 0 "Instance disabled error"
    LOG_INFO "预期结果5、禁用失败"
    
    LOG_INFO "操作步骤6、安装不存在的插件"
    oeawarectl -i test | grep "Download failed, because unable to find a match: test"
    CHECK_RESULT $? 0 0 "Instance Download error"
    LOG_INFO "预期结果6、安装失败"
    
    LOG_INFO "操作步骤7、执行oeawarectl"
    oeawarectl 2>&1 | grep "option error"
    CHECK_RESULT $? 0 0 "command error"
    LOG_INFO "预期结果7、命令未知"
    
    LOG_INFO "操作步骤8、执行oeawarectl -m oeawarectl -?"
    oeawarectl -m 2>&1 | grep "unknown option"
    CHECK_RESULT $? 0 0 "command error"
    oeawarectl -? 2>&1 | grep "unknown option"
    CHECK_RESULT $? 0 0 "command error"
    LOG_INFO "预期结果8、命令未知"
    
    LOG_INFO "End to run test."
    }

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
