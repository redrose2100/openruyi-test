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
    mkdir -p /tmp/yum.bak
    cp /etc/yum.repos.d/*.repo /tmp/yum.bak/
    rm -rf /home/{pkg_manager_folder,src,src_epol} /root/rpmbuild
    yum clean all
    # clean the dos \r ending.
    sed -i 's/\r$//' ./common/escape.pkg
    LOG_INFO "End to prepare the test environment."
}

function check_arch_pkg_white_list() {
    LOG_INFO "Start check arch packages white list"
    local arm_html="$1"
    local x86_html="$2"
    local repo_tag="$3"
    local whitelist="${OET_PATH}/testcases/system-test/pkgmanager-test/common/arch_diff_whitelist.pkg"
    local diff_log="/home/pkg_manager_folder/arch_diff_${repo_tag}_pkg.log"

    #get rpm packages
    get_pkg() {
        grep -o 'href=".*\.rpm"' "$1" | sed -E 's/href="//;s/"$//' | sed -E 's/-[0-9]+\.[0-9]+.*$//' | sort -u
    }
    arm_pkg=$(get_pkg "$arm_html")
    x86_pkg=$(get_pkg "$x86_html")

    # get only in arm & x86
    arm_only=$(awk 'NR==FNR{s[$0]=1;next}!s[$0]' <(echo "$x86_pkg") <(echo "$arm_pkg"))
    x86_only=$(awk 'NR==FNR{s[$0]=1;next}!s[$0]' <(echo "$arm_pkg") <(echo "$x86_pkg"))
    diff=$(echo -e "${arm_only}\n${x86_only}" | sed '/^$/d')
     
    # Check differences pkg between the two architectures.
    if [[ -z "${diff}" ]]; then
        LOG_INFO "No diff packages, pass"
        return 0
    fi

    # Check whether the diff packages are in the whitelist
    bad_pkg=$(echo "$diff" | while read -r p; do grep -q "^$p$" "$whitelist" || echo "$p"; done)
    if [[ -n "$bad_pkg" ]]; then
        echo -e "\nNot in whitelist:\n$bad_pkg" >> "$diff_log"
        LOG_ERROR "Packages not in whitelist: $bad_pkg"
        return 1
    fi

    LOG_INFO "All diff packages in whitelist, pass"
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
        check_arch_pkg_white_list "repo_packages_arm" "repo_packages_x86" "everything"
        ret=$?
        if [ ${ret} -eq 0 ]; then
        # 返回0：差异包全部在白名单，可忽略
           echo "all differential packages are in the whitelist, this problem can be ignored" >> /home/pkg_manager_folder/check_pkg_num.log
           LOG_INFO "all differential packages are in the whitelist, this problem can be ignored"
        else
        # 返回1：存在不在白名单的差异包，报错
           echo "two architectures are not equal in number,differential packages not in whitelist see /home/pkg_manager_folder/arch_diff_everything_pkg.log" >> /home/pkg_manager_folder/check_pkg_num.log
           LOG_INFO "two architectures are not equal in number,differential packages not in whitelist see /home/pkg_manager_folder/arch_diff_everything_pkg.log"
        fi
    fi
    grep "two architectures are not equal in number,differential packages not in whitelist see /home/pkg_manager_folder/arch_diff_everything_pkg.log" /home/pkg_manager_folder/check_pkg_num.log
    CHECK_RESULT $? 1 0 "The two architectures are not equal in number,see /home/pkg_manager_folder/arch_diff_everything_pkg.log"
    if [ -s EPOL_update_list ]; then
        arm_epol_pkgs_num=$(grep -ci ".rpm" epol_repo_packages_arm)
        x86_epol_pkgs_num=$(grep -ci ".rpm" epol_repo_packages_x86)
        if [[ "${arm_epol_pkgs_num}" -eq "${x86_epol_pkgs_num}" ]]; then
            echo "The epol two architectures are equal in number" >>/home/pkg_manager_folder/check_pkg_num.log
        else
	    check_arch_pkg_white_list "epol_repo_packages_arm" "epol_repo_packages_x86" "epol"
	    ret=$?
	    if [ ${ret} -eq 0 ]; then
	       echo "The epol differential packages are in the whitelist, this problem can be ignored" >> /home/pkg_manager_folder/check_pkg_num.log
               LOG_INFO "The epol differential packages are in the whitelist, this problem can be ignored"
	    else
	       echo "The epol two architectures are not equal in number,differential packages not in whitelist see /home/pkg_manager_folder/arch_diff_epol_pkg.log" >> /home/pkg_manager_folder/check_pkg_num.log
	       LOG_INFO "The epol two architectures are not equal in number,differential packages not in whitelist see /home/pkg_manager_folder/arch_diff_epol_pkg.log"
	
	    fi
	fi
        grep "The epol two architectures are not equal in number,differential packages not in whitelist see /home/pkg_manager_folder/arch_diff_epol_pkg.log" /home/pkg_manager_folder/check_pkg_num.log
        CHECK_RESULT $? 1 0 "The epol two architectures are not equal in number,see /home/pkg_manager_folder/arch_diff_epol_pkg.log"
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
    REMOTE_REBOOT 2 600
    CHECK_RESULT $? 0 0 "NODE2 reboot timeout, failed to establish SSH connection"
    # Remove packages
    uninstall_pkg
    test -s /home/pkg_manager_folder/remove_fail_list
    CHECK_RESULT $? 1 0 "Remove packages error !"
    test -s /home/pkg_manager_folder/EPOL_remove_fail_list
    CHECK_RESULT $? 1 0 "Remove epol packages error !"
    REMOTE_REBOOT 2 600
    CHECK_RESULT $? 0 0 "NODE2 reboot timeout, failed to establish SSH connection"
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$Default_LANG
    rm -rf /etc/yum.repos.d/*
    mv /tmp/yum.bak/*.repo /etc/yum.repos.d/
    rm -rf /tmp/yum.bak
    LOG_INFO "End to restore the test environment."
}


main "$@"
