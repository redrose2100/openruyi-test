#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2022-7-5
#@License       :   Mulan PSL v2
#@Desc          :   Public class
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function deploy_env() {
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
}

function add_low_repo() {
    touch /etc/yum.repos.d/openEuler_update.repo
    dnf repolist|grep "^LOW_OS"
    result_value=$?
    if ((result_value !="0"));then
        echo "
[LOW_OS]
name=LOW_OS
baseurl=https://repo.huaweicloud.com/openeuler/openEuler-23.09/OS/\$basearch/
enabled=1
gpgcheck=1
gpgkey=https://repo.huaweicloud.com/openeuler/openEuler-23.09/OS/\$basearch/RPM-GPG-KEY-openEuler
" >>/etc/yum.repos.d/openEuler_update.repo
    fi

    dnf repolist|grep "^update"
    result_value=$?
    if ((result_value !="0"));then
        echo "
[update]
name=update
baseurl=https://repo.huaweicloud.com/openeuler/openEuler-24.03-LTS/update/\$basearch/
enabled=1
gpgcheck=1
gpgkey=https://repo.huaweicloud.com/openeuler/openEuler-24.03-LTS/OS/\$basearch/RPM-GPG-KEY-openEuler
" >>/etc/yum.repos.d/openEuler_update.repo
    fi
    dnf repolist|grep "^debuginfo"
    result_value=$?
    if ((result_value !="0"));then
        echo "
[debuginfo]
name=debuginfo
baseurl=https://repo.huaweicloud.com/openeuler/openEuler-23.09/debuginfo/\$basearch/
enabled=1
gpgcheck=1
gpgkey=https://repo.huaweicloud.com/openeuler/openEuler-23.09/debuginfo/\$basearch/RPM-GPG-KEY-openEuler
" >>/etc/yum.repos.d/openEuler_update.repo
    fi
}


function delete_low_repo() {
    rm -rf /etc/yum.repos.d/openEuler_update.repo
}


function clear_env() { 
    export LANG=${OLD_LANG}
}
