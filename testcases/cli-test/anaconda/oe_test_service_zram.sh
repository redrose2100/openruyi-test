#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test zram.service restart
# #############################################
# shellcheck disable=SC1091
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL anaconda-core
    # anaconda-core 33.19版本有zram.service,36.16版本没有zram.service服务
    if [ "$(rpm -q anaconda-core|cut -d '-' -f 3|cut -d '.' -f 1)" -ge  34 ];then
        LOG_INFO "$(rpm -q anaconda-core) do not have zram.service,skip test."
        exit 255
    fi

    memtotal_kb=$(grep MemTotal /proc/meminfo | grep -E --only-matching '[[:digit:]]+')
    sed -i "s/MAX_RAM_ON=2097152/MAX_RAM_ON=${memtotal_kb}/g" /usr/libexec/anaconda/zramswapon
    systemctl restart zram.service
	sleep 2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution zram.service
    test_reload zram.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    [ -e /usr/libexec/anaconda/zramswapon ] && sed -i "s/MAX_RAM_ON=${memtotal_kb}/MAX_RAM_ON=2097152/g" /usr/libexec/anaconda/zramswapon
	systemctl restart zram.service
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
