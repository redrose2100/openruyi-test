#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujuan
# @Contact   :   lchutian@163.com
# @Date      :   2021/01/04
# @License   :   Mulan PSL v2
# @Desc      :   verify the usage of sosreport command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "sos tar hostname"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    name="sosreport-$(hostname -s)"
    sos report --list-profiles
    CHECK_RESULT $?
    sos report --batch --log-size 10 --case-id log-size
    test -f /var/tmp/"${name}"-log-size-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    sos report --batch -n dnf,rpm,selinux,dovecot --case-id skip-plugins
    test -f /var/tmp/"${name}"-skip-plugins-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    sos report --batch --no-report --case-id no-report
    test -f /var/tmp/"${name}"-no-report-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    no_report_file=$(ls /var/tmp/"${name}"-no-report-"$(date +%Y-%m-%d)"-*.tar.xz)
    tar -xvf "${no_report_file}"
    test -f "${name}"-no-report-"$(date +%Y-%m-%d)"-*/sos_reports/sos.html -a -f "${name}"-no-report-"$(date +%Y-%m-%d)"-*/sos_reports/sos.txt -a -f "${name}"-no-report-"$(date +%Y-%m-%d)"-*/sos_reports/sos.json
    CHECK_RESULT $? 1
    sos report --batch --note "testnote" --case-id testnote
    test -f /var/tmp/"${name}"-testnote-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    sos report --batch -o dnf,rpm,selinux,dovecot --label only-plugins
    CHECK_RESULT $?
    test -f /var/tmp/"${name}"-only-plugins-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    for file in *; do
        if [[ ! $file =~ \.sh$ ]]; then
            rm -rf "$file"
        fi
    done
    rm -rf /var/tmp/sos*
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
