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
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-04-12
# @License   :   Mulan PSL v2
# @Desc      :   AccessControl_私有数据隔离保护
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"


function pre_test(){
    LOG_INFO "Start environment preparation."
    id adm_737709 && userdel -rf adm_737709
    id normal_737709 && userdel -rf normal_737709
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    useradd -G wheel adm_737709
    useradd normal_737709

    su - adm_737709 -c "cd /home/adm_737709"
    CHECK_RESULT $? 0 0 "su - adm_737709 failed !"
    su - normal_737709 -c "cd /home/normal_737709"
    CHECK_RESULT $? 0 0 "su - normal_737709 failed !"

    su - adm_737709 -c "cd /root" 2>&1 |grep "权限不够"
    CHECK_RESULT $? 0 0 "cd root  adm Permission isolation failure"
    su - adm_737709 -c "cd /home/normal_737709" 2>&1 |grep "权限不够"
    CHECK_RESULT $? 0 0 "cd /home/normal_737709 adm Permission isolation failure"

    su - normal_737709 -c "cd /root" 2>&1 |grep "权限不够"
    CHECK_RESULT $? 0 0 "cd /root normal Permission isolation failure"
    su - normal_737709 -c "cd /home/adm_737709" 2>&1 |grep "权限不够"
    CHECK_RESULT $? 0 0 "cd /home/adm_737709 normal Permission isolation failure"
    LOG_INFO "Finish test!"
}
function post_test(){
    LOG_INFO "start environment cleanup."
    userdel -rf adm_737709
    userdel -rf normal_737709
    LOG_INFO "Finish environment cleanup!"
}

main $@
