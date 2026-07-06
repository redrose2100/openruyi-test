#! /usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhanglu
# @Contact   :   m18409319968@163.com
# @Date      :   2023-07-12
# @License   :   Mulan PSL v2
# @Desc      :   Direct upgrade
# ############################################
# shellcheck disable=SC1090,SC1091,SC2034,SC2154

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/libs/locallibs/configure_repo.sh
source ./common/common.sh
source ./common/pkg.conf
Default_LANG=$LANG
export LANG=en_US.UTF-8


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="720m"
    cp /etc/yum.repos.d/openEuler.repo /tmp/openEuler.repo.bak
    rm -rf /home/{pkg_manager_folder,src,src_epol} /root/rpmbuild
    sed -i 's/\r$//' ./common/escape.pkg
    yum clean all
    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "Start to run test."
    # Configure repo sour
    test -z "${test_repo}" || official_repo=${test_repo}
    rm -rf /etc/yum.repos.d/*
    if [ ! "${target_branch}" ]; then
        cfg_openEuler_repo
        cfg_openEuler_update_test_repo
    else
        version_info=${openeulerversion}
        cfg_openEuler_repo "${openeulerversion}"
        version_info=${target_branch}
        cfg_openEuler_repo "${version_info}"
        cfg_openEuler_update_test_repo "${version_info}"
    fi

    CHECK_RESULT $? 0 0 "Failed to configure the repo source !"
    # Get the package lists
    yum makecache
    get_related_lists
    SSH_CMD "rm -rf /etc/yum.repos.d/* " "${NODE2_IPV4}"
    SSH_SCP /etc/yum.repos.d "${NODE2_USER}"@"${NODE2_IPV4}":/etc/ "${NODE2_PASSWORD}" 22
    SSH_CMD "test -d /home/pkg_manager_folder && rm -rf /home/pkg_manager_folder/ " "${NODE2_IPV4}"
    SSH_SCP /home/pkg_manager_folder "${NODE2_USER}"@"${NODE2_IPV4}":/home/ "${NODE2_PASSWORD}" 22
    CHECK_RESULT $? 0 0 "Failed to get lists !"
    # Upgrade packages
    upgrade_test_pkg
    test -s /home/pkg_manager_folder/upgrade_fail_list
    CHECK_RESULT $? 1 0 "Packages upgrade error !"
    test -s /home/pkg_manager_folder/EPOL_upgrade_fail_list
    CHECK_RESULT $? 1 0 "EPOL packages upgrade error !"
    REMOTE_REBOOT 2 300
    CHECK_RESULT $? 0 1 "NODE2 reboot timeout, failed to establish SSH connection"
    # Downgrade packages
    downgrade_test_pkg
    test -s /home/pkg_manager_folder/downgrade_fail_list
    CHECK_RESULT $? 1 0 "Downgrade packages error !"
    test -s /home/pkg_manager_folder/EPOL_downgrade_fail_list
    CHECK_RESULT $? 1 0 "Downgrade epol packages error !"
    # Remove packages
    uninstall_pkg
    test -s /home/pkg_manager_folder/remove_fail_list
    CHECK_RESULT $? 1 0 "Remove packages error !"
    test -s /home/pkg_manager_folder/EPOL_remove_fail_list
    CHECK_RESULT $? 1 0 "Remove epol packages error !"
    REMOTE_REBOOT 2 300
    CHECK_RESULT $? 0 1 "NODE2 reboot timeout, failed to establish SSH connection"
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /etc/yum.repos.d/*
    mv /tmp/openEuler.repo.bak /etc/yum.repos.d/openEuler.repo
    export LANG=$Default_LANG
    LOG_INFO "End to restore the test environment."
}


main "$@"
