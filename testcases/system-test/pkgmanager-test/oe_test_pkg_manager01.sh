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
# @Desc      :   Install software packages directly
# ############################################
# shellcheck disable=SC1090,SC1091,SC2034

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/libs/locallibs/configure_repo.sh
source ./common/common.sh
source ./common/pkg.conf
Default_LANG=$LANG
export LANG=en_US.UTF-8


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="720m"
    rm -rf /home/{pkg_manager_folder,src,src_epol} /root/rpmbuild
    yum clean all
    # clean the dos \r ending.
    sed -i 's/\r$//' ./common/escape.pkg
    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "Start to run test."
    # Configure repo source
    test -z "${test_repo}" || official_repo=${test_repo}
    rm -rf /etc/yum.repos.d/*
    cfg_openEuler_repo
    cfg_openEuler_update_test_repo
    CHECK_RESULT $? 0 0 "Failed to configure the repo source !"
    # Get the package lists
    get_related_lists
    SSH_CMD "rm -rf /etc/yum.repos.d/* " "${NODE2_IPV4}"
    SSH_SCP /etc/yum.repos.d "${NODE2_USER}"@"${NODE2_IPV4}":/etc/ "${NODE2_PASSWORD}" 22
    SSH_CMD "test -d /home/pkg_manager_folder && rm -rf /home/pkg_manager_folder/ " "${NODE2_IPV4}"
    SSH_SCP /home/pkg_manager_folder "${NODE2_USER}"@"${NODE2_IPV4}":/home/ "${NODE2_PASSWORD}" 22
    CHECK_RESULT $? 0 0 "Failed to get lists !"
    # Check package suffix
    check_pkg_suffix
    test -s /home/pkg_manager_folder/error_suffix_name_pkgs_list
    CHECK_RESULT $? 1 0 "Check suffix fail"
    # Check package number
    check_pkg_num
    grep "Check update_list packages number fail" /home/pkg_manager_folder/check_pkg_num.log
    CHECK_RESULT $? 1 0 "Check repo number fail"
    grep "Check update_list EPOL packages number fail" /home/pkg_manager_folder/check_pkg_num.log
    CHECK_RESULT $? 1 0 "Check EPOL repo number fail"

    arm_pkgs_num=$(grep -ci ".rpm" repo_packages_arm)
    x86_pkgs_num=$(grep -ci ".rpm" repo_packages_x86)
    if [[ "${arm_pkgs_num}" -eq "${x86_pkgs_num}" ]]; then
        echo "The update two architectures are equal in number" >>/home/pkg_manager_folder/check_pkg_num.log
    else
        echo "The update two architectures are not equal in number" >>/home/pkg_manager_folder/check_pkg_num.log
    fi
    grep "The update two architectures are not equal in number" /home/pkg_manager_folder/check_pkg_num.log
    CHECK_RESULT $? 1 0 "The two architectures are not equal in number"
    if [ -s EPOL_update_list ]; then
        arm_epol_pkgs_num=$(grep -ci ".rpm" epol_repo_packages_arm)
        x86_epol_pkgs_num=$(grep -ci ".rpm" epol_repo_packages_x86)
        if [[ "${arm_epol_pkgs_num}" -eq "${x86_epol_pkgs_num}" ]]; then
            echo "The epol two architectures are equal in number" >>/home/pkg_manager_folder/check_pkg_num.log
        else
            echo "The epol two architectures are not equal in number" >>/home/pkg_manager_folder/check_pkg_num.log
        fi
        grep "The epol two architectures are not equal in number" /home/pkg_manager_folder/check_pkg_num.log
        CHECK_RESULT $? 1 0 "The epol two architectures are not equal in number"
    else
        echo "EPOL repo is not exit"
    fi
    # Install packages and ko verification
    install_test_pkg
    test -s /home/pkg_manager_folder/install_fail_list
    CHECK_RESULT $? 1 0 "install package error !"
    test -s /home/pkg_manager_folder/EPOL_install_fail_list
    CHECK_RESULT $? 1 0 "EPOL packages install error !"
    test -s /home/pkg_manager_folder/ko_fail_list
    CHECK_RESULT $? 1 0 "Check ko insmod fail !"
    SSH_CMD "reboot" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 600 22
    SLEEP_WAIT 600
    # Remove packages
    uninstall_pkg
    test -s /home/pkg_manager_folder/remove_fail_list
    CHECK_RESULT $? 1 0 "Remove packages error !"
    test -s /home/pkg_manager_folder/EPOL_remove_fail_list
    CHECK_RESULT $? 1 0 "Remove epol packages error !"
    SSH_CMD "reboot" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 600 22
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$Default_LANG
    LOG_INFO "End to restore the test environment."
}


main "$@"
