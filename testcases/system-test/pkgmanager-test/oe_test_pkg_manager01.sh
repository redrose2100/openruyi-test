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
    cp /etc/yum.repos.d/openEuler.repo /tmp/openEuler.repo.bak
    rm -rf /home/{pkg_manager_folder,src,src_epol} /root/rpmbuild
    yum clean all
    # clean the dos \r ending.
    sed -i 's/\r$//' ./common/escape.pkg
    LOG_INFO "End to prepare the test environment."
}

function check_arch_pkg_white_list() {
    LOG_INFO "Start check arm/x86 different packages with white list"
    local arm_list="repo_packages_arm"
    local x86_list="repo_packages_x86"
    local whitelist="${ARCH_PKG_WHITE_LIST}"
    local diff_arm_only diff_x86_only all_diff_pkg unexpect_pkg

    diff_arm_only=$(comm -13 <(sort "${x86_list}") <(sort "${arm_list}"))
    diff_x86_only=$(comm -23 <(sort "${x86_list}") <(sort "${arm_list}"))
    all_diff_pkg=$(echo -e "${diff_arm_only}\n${diff_x86_only}" | sed '/^$/d')

    if [[ -z "${all_diff_pkg}" ]]; then
        LOG_INFO "No different packages between arm and x86, check pass"
        return 0
    fi
    LOG_INFO "Found difference packages between arm/x86:"
    echo "${all_diff_pkg}" >> /home/pkg_manager_folder/arch_diff_pkg.log

    unexpect_pkg=""
    while IFS= read -r pkg; do
        if [[ -z "${pkg}" ]]; then
            continue
        fi
        if ! grep -q "^${pkg}$" "${whitelist}"; then
            unexpect_pkg+="${pkg}"$'\n'
            LOG_ERROR "Package ${pkg} is different between architectures and NOT in white list"
        fi
    done <<< "${all_diff_pkg}"

    if [[ -n "${unexpect_pkg}" ]]; then
        echo "Unallowed different packages exist, need manual check:" >> /home/pkg_manager_folder/check_pkg_num.log
        echo "${unexpect_pkg}" >> /home/pkg_manager_folder/check_pkg_num.log
        LOG_ERROR "Arm/x86 packages mismatch has unwhite-listed packages, please manual verify"
        return 1
    fi

    LOG_INFO "All different packages are in white list, check pass"
    echo "All architecture difference packages are in white list, skip fail judge" >> /home/pkg_manager_folder/check_pkg_num.log
    return 0
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
    yum makecache
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
	check_arch_pkg_white_list
	CHECK_RESULT $? 0 1 "Arm/x86 package quantity inconsistent, unexpected differential packages exist, manual review required"
    fi
    if [ -s EPOL_update_list ]; then
        arm_epol_pkgs_num=$(grep -ci ".rpm" epol_repo_packages_arm)
        x86_epol_pkgs_num=$(grep -ci ".rpm" epol_repo_packages_x86)
        if [[ "${arm_epol_pkgs_num}" -eq "${x86_epol_pkgs_num}" ]]; then
            echo "The epol two architectures are equal in number" >>/home/pkg_manager_folder/check_pkg_num.log
        else
            echo "The epol two architectures are not equal in number" >>/home/pkg_manager_folder/check_pkg_num.log
	    check_arch_pkg_white_list
	    CHECK_RESULT $? 0 1 "Arm/x86 package quantity inconsistent, unexpected differential packages exist, manual review required"
        fi
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
    REMOTE_REBOOT 2 300
    CHECK_RESULT $? 0 1 "NODE2 reboot timeout, failed to establish SSH connection"
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
    export LANG=$Default_LANG
    rm -rf /etc/yum.repos.d/*
    mv /tmp/openEuler.repo.bak /etc/yum.repos.d/openEuler.repo
    LOG_INFO "End to restore the test environment."
}


main "$@"

