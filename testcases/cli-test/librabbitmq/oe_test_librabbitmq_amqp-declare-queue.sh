#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of librabbitmq command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "librabbitmq rabbitmq-server"
    openssl genrsa -out privkey.pem 2048
    openssl rsa -pubout -in privkey.pem -out pubkey.pem
    openssl rsa -pubout -in privkey.pem -out cert.pem
    nohup systemctl start rabbitmq-server &
    SLEEP_WAIT 30
    rabbitmq-plugins enable rabbitmq_management
    rabbitmqctl add_user admin admin
    rabbitmqctl set_user_tags admin administrator
    rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
    rabbitmqctl change_password admin admin
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    amqp-declare-queue -q test_queue -d -s 127.0.0.1 --port=5672 --vhost=/ --username=admin --password=admin --heartbeat=1 | grep 'test_queue'
    CHECK_RESULT $? 0 0 "Check amqp-declare-queue -q -d -s --port --vhost --username --password --heartbeat failed"
    amqp-declare-queue -u amqp://127.0.0.1:5672 -q test_queue1 -d --heartbeat=1 --ssl --cacert=cacert.pem --key=privkey.pem --cert=cert.pem | grep 'test_queue1'
    CHECK_RESULT $? 0 0 "Check amqp-declare-queue -u -q -d --heartbeat failed"
    amqp-declare-queue --usage 2>&1 | grep 'Usage: amqp-declare-queue'
    CHECK_RESULT $? 0 0 "Check amqp-declare-queue --usage failed"
    amqp-declare-queue -? | grep 'Usage: amqp-declare-queue \[OPTIONS\]'
    CHECK_RESULT $? 0 0 "Check amqp-declare-queue -?  failed"
    amqp-declare-queue --help | grep 'Usage: amqp-declare-queue \[OPTIONS\]'
    CHECK_RESULT $? 0 0 "Check amqp-declare-queue --help failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rabbitmq-plugins disable rabbitmq_management
    rabbitmqctl delete_user admin
    rm -rf privkey.pem pubkey.pem cert.pem
    systemctl stop rabbitmq-server
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
