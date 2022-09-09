#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2022.9.09
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-timedatectl
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    timedatectl | grep Local
    CHECK_RESULT $? 0 0 "Display an error"

    timedatectl set-ntp no
    CHECK_RESULT $? 0 0 "Failure to shut down NTP"

    timedatectl | grep NTP | grep inactive
    CHECK_RESULT $? 0 0 "The NTP service is displayed incorrectly"

    timedatectl list-timezones | grep Asia
    CHECK_RESULT $? 0 0 "The query fails"

    timedatectl set-time '2019-08-14 15:57:24'
    timedatectl | grep Local | grep -E "2019-08-14 15:57:[0-9]{2}"
    CHECK_RESULT $? 0 0 "Failed to set time"

    timezone=$(timedatectl | grep "Time zone" | awk -F":" '{print $2}' | awk '{print $1}')
    timedatectl set-timezone Asia/Beijing
    timedatectl | grep Asia/Beijing
    CHECK_RESULT $? 0 0 "Failure to set the time zone"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    timedatectl set-ntp yes
    hwclock -w
    hwclock --hctosys
    timedatectl set-timezone ${timezone}
    LOG_INFO "Finish environment cleanup!"
}

main $@
