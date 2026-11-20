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
# @Desc      :   common_functions
# ############################################
# shellcheck disable=SC1090,SC1091,SC2154

source "${OET_PATH}"/libs/locallibs/configure_repo.sh
# /etc/openEuler-latest 在衍生发行版上不存在，交由 os_release_lib.sh 兜底。
source "${OET_PATH}"/libs/locallibs/os_release_lib.sh
OS_RELEASE_EXPORT_VERSION
source ./common/pkg.conf
service_ip=121.36.84.172


#Get the package lists
function get_related_lists() {
    test -d /home/pkg_manager_folder || mkdir /home/pkg_manager_folder && cd /home/pkg_manager_folder || exit 1
    dnf list --installed | grep "@anaconda" | grep "arch\|x86_64" | awk '{print $1}' | awk -F. 'OFS="."{$NF="";print}' | awk '{print substr($0, 1, length($0)-1)}' >anaconda_list
    dnf list --available --repo="${version_info}_${test_update_repo}" | grep "arch\|x86_64" | awk '{print $1}' | awk -F. 'OFS="."{$NF="";print}' | awk '{print substr($0, 1, length($0)-1)}' >update_dnf_list

    dnf install -y rpm-build --repo="${version_info}"_everything
    exec_path=$(pwd)
    dnf list --repo="${version_info}_source_${test_update_repo}" --available | awk '{print $1}' | awk -F '.src' '{print $1}' | grep -v "Last\|Available\|${version_info}" >source_list
    dnf config-manager --disable "${version_info}_source_${test_update_repo}"
    test -d /home/src || mkdir /home/src && cd /home/src || exit
    while read -r src; do
        if yumdownloader --source "${src}" --repo="${version_info}"_update_source; then
            echo "${src} exist last version source" >>"${exec_path}"/check.log
        else
            if yumdownloader --source "${src}" --repo="${version_info}"_source; then
                echo "${src} not exist last version source,exist base version" >>"${exec_path}"/check.log
            else
                echo "${src} not exist old version" >>"${exec_path}"/check.log
            fi
        fi
    done <"${exec_path}"/source_list
    while read -r name; do
        rpm -i "${name}"*.src.rpm || echo "Source package ${name} install fail !" >>"${exec_path}"/check.log
        rpm2cpio "${name}"*.src.rpm | cpio -idmv --no-absolute-filenames "*.spec" || echo "${name} spec get fail !" >>"${exec_path}"/check.log
    done <"${exec_path}"/source_list
    cd "${exec_path}" || exit
    find /home/src/*spec >spec.list
    while read -r spec; do
        rpm -q --specfile "${spec}" --queryformat="%{NAME}\n" >>update_rpm_list || echo " ${spec} get the package name fail !" >>check.log
    done <spec.list
    test -s update_rpm_list && cat update_dnf_list update_rpm_list | sort | uniq >update_list

    if [ "${test_update_repo}"x == "${test_EPOL_update_repo}"x ]; then
        dnf list --available --repo="${version_info}_EPOL_${test_EPOL_update_repo}" | grep "arch\|x86_64" | awk '{print $1}' | awk -F. 'OFS="."{$NF="";print}' | awk '{print substr($0, 1, length($0)-1)}' >EPOL_update_dnf_list
        dnf list --repo="${version_info}_EPOL_source_${test_EPOL_update_repo}" --available | awk '{print $1}' | awk -F '.src' '{print $1}' | grep -v "Last\|Available\|${version_info}" >epol_source_list
        dnf config-manager --disable "${version_info}_EPOL_source_${test_EPOL_update_repo}"
        test -d /home/src_epol || mkdir /home/src_epol && cd /home/src_epol || exit
        while read -r src; do
            if yumdownloader --source "${src}" --repo="${version_info}"_EPOL_update_source; then
                echo "${src} exist last version source" >>"${exec_path}"/check.log
            else
                if yumdownloader --source "${src}" --repo="${version_info}"_EPOL_source; then
                    echo "${src} not exist last version source,exist base version" >>"${exec_path}"/check.log
                else
                    echo "${src} not exist old version" >>"${exec_path}"/check.log
                fi
            fi
        done <"${exec_path}"/epol_source_list
        while read -r epol_name; do
            rpm -i "${epol_name}"*.src.rpm || echo "Source package ${epol_name} install fail !" >>"${exec_path}"/check.log
            rpm2cpio "${epol_name}"*.src.rpm | cpio -idmv --no-absolute-filenames "*.spec"
        done <"${exec_path}"/epol_source_list
        cd "${exec_path}" || exit
        find /home/src_epol/*spec >epol_spec.list
        while read -r epol_spec; do
            rpm -q --specfile "${epol_spec}" --queryformat="%{NAME}\n" >>EPOL_update_rpm_list || echo " ${epol_spec} get the package name fail !" >>check.log
        done <epol_spec.list
        cat EPOL_update_dnf_list EPOL_update_rpm_list | sort | uniq >EPOL_update_list
    else
        printf "No ${version_info}_EPOL_%s pkg-lists" "$test_update_repo"
    fi
    dnf remove -y rpm-build
}


# Check package suffix
function check_pkg_suffix() {
    cd /home/pkg_manager_folder || exit
    suffix_name=$(echo "${kernelversion}" | awk -F "." '{print $NF}')
    dnf list --all | grep "${test_update_repo}" >all_pkgs_list
    grep "noarch\|aarch64\|x86_64" all_pkgs_list | grep -v "${suffix_name}" | grep -v "${openeulerversion}" >>error_suffix_name_pkgs_list
}


# Check package number
function check_pkg_num() {
    curl http://"${service_ip}"/repo.openeuler.org/"${openeulerversion}"/"${test_update_repo}"/"$(arch)"/Packages/ >repo_packages
    curl http://"${service_ip}"/repo.openeuler.org/"${openeulerversion}"/"${test_update_repo}"/aarch64/Packages/ >repo_packages_arm
    curl http://"${service_ip}"/repo.openeuler.org/"${openeulerversion}"/"${test_update_repo}"/x86_64/Packages/ >repo_packages_x86
    repo_pkgs_num=$(grep -ci ".rpm" repo_packages)
    update_list_pkgs_num=$(wc -l <update_dnf_list)
    if [[ "${repo_pkgs_num}" -eq "${update_list_pkgs_num}" ]]; then
        echo "Check update_list packages number success" >>check_pkg_num.log
    else
        echo "Check update_list packages number fail" >>check_pkg_num.log
    fi

    if [ "${openeulerversion}"x == "openEuler-20.03-LTS-SP1"x ]; then
        if [ -s EPOL_update_list ]; then
            curl http://"${service_ip}"/repo.openeuler.org/"${openeulerversion}"/EPOL/"${test_update_repo}"/"$(arch)"/Packages/ >epol_repo_packages
            curl http://"${service_ip}"/repo.openeuler.org/"${openeulerversion}"/EPOL/"${test_update_repo}"/aarch64/Packages/ >epol_repo_packages_arm
            curl http://"${service_ip}"/repo.openeuler.org/"${openeulerversion}"/EPOL/"${test_update_repo}"/x86_64/Packages/ >epol_repo_packages_x86
            EPOL_repo_pkgs_num=$(grep -ci ".rpm" epol_repo_packages)
            EPOL_update_list_pkgs_num=$(wc -l <EPOL_update_dnf_list)
            # [ "${EPOL_repo_pkgs_num}" -eq "${EPOL_update_list_pkgs_num}" ]
            # CHECK_RESULT $? 0 0 "Check EPOL_update_dnf_list packages number fail"
            if [[ "${EPOL_repo_pkgs_num}" -eq "${EPOL_update_list_pkgs_num}" ]]; then
                echo "Check update_list EPOL packages number success" >>check_pkg_num.log
            else
                echo "Check update_list EPOL packages number fail" >>check_pkg_num.log
            fi
        else
            LOG_INFO "EPOL repo is not exit"
        fi
    else
        if [ -s EPOL_update_list ]; then
            curl http://"${service_ip}"/repo.openeuler.org/"${openeulerversion}"/EPOL/"${test_update_repo}"/main/"$(arch)"/Packages/ >epol_repo_packages
            curl http://"${service_ip}"/repo.openeuler.org/"${openeulerversion}"/EPOL/"${test_update_repo}"/main/aarch64/Packages/ >epol_repo_packages_arm
            curl http://"${service_ip}"/repo.openeuler.org/"${openeulerversion}"/EPOL/"${test_update_repo}"/main/x86_64/Packages/ >epol_repo_packages_x86
            EPOL_repo_pkgs_num=$(grep -ci ".rpm" epol_repo_packages)
            EPOL_update_list_pkgs_num=$(wc -l <EPOL_update_dnf_list)
            if [[ "${EPOL_repo_pkgs_num}" -eq "${EPOL_update_list_pkgs_num}" ]]; then
                echo "Check update_list EPOL packages number success" >>check_pkg_num.log
            else
                echo "Check update_list EPOL packages number fail" >>check_pkg_num.log
            fi
        else
            LOG_INFO "EPOL repo is not exit" >>check.log
        fi
    fi   
}


# Install packages
install_test_pkg() {
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/install.sh "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/noproblem_list "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/escape.pkg "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/
    SSH_CMD "cd /home/pkg_manager_folder
    sh install.sh" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 43200 22
    SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder /home/
}


# Upgrade packages
upgrade_test_pkg() {
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/upgrade.sh "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/noproblem_list "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/escape.pkg "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/
    SSH_CMD "cd /home/pkg_manager_folder 
    sh upgrade.sh" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 43200 22
    SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder /home/
}


# Downgrade packages
downgrade_test_pkg() {
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/downgrade.sh "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/ "${NODE2_PASSWORD}" 22
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/noproblem_list "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/ "${NODE2_PASSWORD}" 22
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/escape.pkg "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/
    SSH_CMD "cd /home/pkg_manager_folder 
    sh downgrade.sh" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 43200 22
    SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder /home/ "${NODE2_PASSWORD}" 22
}


# Remove packages
function uninstall_pkg() {
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/remove.sh "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/ "${NODE2_PASSWORD}" 22
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/noproblem_list "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/ "${NODE2_PASSWORD}" 22
    SSH_SCP "${OET_PATH}"/testcases/function-test/pkgmanager-test/common/escape.pkg "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder/
    SSH_CMD "cd /home/pkg_manager_folder 
    sh remove.sh" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 43200 22
    SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":/home/pkg_manager_folder /home/ "${NODE2_PASSWORD}" 22
}
