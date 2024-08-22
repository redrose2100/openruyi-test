#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/3/1
# @License   :   Mulan PSL v2
# @Desc      :   Test bsmtp & btraceback
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "bacula-client bacula-common mysql-server sendmail m4"
    line=$(grep -nr 'port=smtp,Addr=::1, Name=MTA-v6, Family=inet6' /etc/mail/sendmail.mc |  awk 'BEGIN {FS=":"}{print $1}')
    sed -i "${line}s/dnl //g" /etc/mail/sendmail.mc
    sed -i "${line}s/dnl//g" /etc/mail/sendmail.mc
    m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf
    systemctl start bacula-dir.service bacula-sd.service bacula-fd.service
    systemctl restart sendmail
}

function run_test() {
    LOG_INFO "Start to run test."
    echo '1111' | bsmtp -f xxx@qq.com -c bacula -h localhost -s "123" root -4
    CHECK_RESULT $? 0 0 "test bsmtp -f -c -h -s -4 failed"
    echo '1111' | bsmtp -f xxx@qq.com -c bacula -h localhost -s "123" root -8
    CHECK_RESULT $? 0 0 "test bsmtp -6 failed"
    echo '1111' | bsmtp -f xxx@qq.com -c bacula -h localhost -s "123" root -a
    CHECK_RESULT $? 0 0 "test bsmtp -a failed"
    echo '1111' | bsmtp -f xxx@qq.com -c bacula -h localhost -s "123" root -d 11
    CHECK_RESULT $? 0 0 "test bsmtp -d failed"
    echo '1111' | bsmtp -f xxx@qq.com -c bacula -h localhost -s "123" root -dt
    CHECK_RESULT $? 0 0 "test bsmtp -dt failed"
    echo '1111' | bsmtp -f xxx@qq.com -c bacula -h localhost -s "123" root -r 'a'
    CHECK_RESULT $? 0 0 "test bsmtp -r failed"
    echo '1111' | bsmtp -f xxx@qq.com -c bacula -h localhost -s "123" root -l 50
    CHECK_RESULT $? 0 0 "test bsmtp -l failed"
    bsmtp -? 2>&1 | grep 'Usage: '
    CHECK_RESULT $? 0 0 "test bsmtp -? failed"
    btraceback bacula.md
    CHECK_RESULT $? 0 0 "test btraceback failed"
    echo '1111' | bsmtp -f xxx@qq.com -h localhost -s "123" root -6
    CHECK_RESULT $? 0 0 "test bsmtp -6 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$OLD_LANG
    systemctl stop bacula-dir.service bacula-sd.service bacula-fd.service sendmail
    rm -rf config/ /var/lib/mysql/* /tmp/test* /var/spool/bacula/* /etc/mail/sendmail.cf.rpmsave sendmail.mc.rpmsave
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
