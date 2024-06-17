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

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "librabbitmq rabbitmq-server"
    if grep -q "$(hostname -f)" /etc/hosts ; then
            :
    else
            echo "127.0.0.1   $(hostname -f)" >> /etc/hosts
    fi
    cp  rabbitmq.conf /etc/rabbitmq/
    unzip main.zip >> /dev/null
    cd tls-gen-main/two_shared_intermediates || exit
    make 
    SLEEP_WAIT 50
    cd result || exit
    mkdir /etc/rabbitmq/ssl
    SSL_PATH=/etc/rabbitmq/ssl
    cp chained_ca_certificate.pem "${SSL_PATH}"/
    cp server_certificate.pem     "${SSL_PATH}"/
    cp server_key.pem             "${SSL_PATH}"/
    chmod 655 -R "${SSL_PATH}"/
    nohup systemctl start rabbitmq-server &
    SLEEP_WAIT 30
    rabbitmq-plugins enable rabbitmq_management
    rabbitmq-plugins enable rabbitmq_auth_mechanism_ssl
    SLEEP_WAIT 30
    rabbitmqctl add_user admin admin
    rabbitmqctl set_user_tags admin administrator
    rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
    rabbitmqctl change_password admin admin
    amqp-declare-queue -u amqps://"$(hostname -f)":5671 -q test_queue1 -d --heartbeat=1 --ssl  --cacert=chained_ca_certificate.pem --key=client_key.pem --cert=client_certificate.pem
    amqp-publish -r test_queue1 -b "test_body1" -C String -t "OK" -p -E utf-8 -H "key:value" -u amqps://"$(hostname -f)":5671 --ssl --ssl --cacert=chained_ca_certificate.pem --key=client_key.pem --cert=client_certificate.pem
    amqp-declare-queue -q test_queue -d -s 127.0.0.1 --port=5672 --vhost=/ --username=admin --password=admin --heartbeat=1
    amqp-publish -r test_queue -b "test_body1" -C String -t "OK" -p -E utf-8 -H "key:value" -s 127.0.0.1 --port=5672 --vhost=/ --username=admin --password=admin --heartbeat=1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    amqp-get -q test_queue1 -u amqps://"$(hostname -f)":5671 --ssl --cacert=chained_ca_certificate.pem --key=client_key.pem --cert=client_certificate.pem | grep 'test_body1'
    CHECK_RESULT $? 0 0 "Check  amqp-get -q -u --ssl --cacert --key --cert failed"
    amqp-get -q test_queue -s 127.0.0.1 --port=5672 --vhost=/ --username=admin --password=admin --heartbeat=1 | grep 'test_body1'
    CHECK_RESULT $? 0 0 "Check  amqp-get -q -s --port --vost --username --password --heartbeat failed"
    amqp-get --help | grep 'Usage: amqp-get \[OPTIONS\]'
    CHECK_RESULT $? 0 0 "Check  amqp-get --help failed"
    amqp-get -? | grep 'Usage: amqp-get \[OPTIONS\]'
    CHECK_RESULT $? 0 0 "Check  amqp-get -? failed"
    amqp-get --usage | grep 'Usage: amqp-get'
    CHECK_RESULT $? 0 0 "Check amqp-get --usage failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rabbitmqctl delete_user admin
    rabbitmq-plugins disable rabbitmq_management
    rabbitmq-plugins disable rabbitmq_auth_mechanism_ssl
    cd ../../../ || exit
    rm -rf tls-gen-main /etc/rabbitmq
    systemctl stop rabbitmq-server
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
