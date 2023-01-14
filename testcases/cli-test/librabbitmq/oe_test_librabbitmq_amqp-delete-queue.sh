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
    amqp-declare-queue -q test_queue -d -s 127.0.0.1 --port=5672 --vhost=/ --username=admin --password=admin --heartbeat=1
    amqp-publish -r test_queue -b "test_body1" -C String -t "OK" -p -E utf-8 -H "key:value" -s 127.0.0.1 --port=5672 --vhost=/ --username=admin --password=admin --heartbeat=1
    amqp-declare-queue -u amqp://127.0.0.1:5672 -q test_queue1 -d --heartbeat=1 --ssl --cacert=cacert.pem --key=privkey.pem --cert=cert.pem
    amqp-publish -r test_queue1 -b "test_body1" -C String -t "OK" -p -E utf-8 -H "key:value" -u amqp://127.0.0.1:5672 --ssl --cacert=cacert.pem --key=privkey.pem --cert=cert.pem
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    amqp-delete-queue --if-unused -q test_queue -s 127.0.0.1 --port=5672 --vhost=/ --username=admin --password=admin --heartbeat=1 | grep '[[:digit:]]'
    CHECK_RESULT $? 0 0 "Check amqp-delete-queue -s -q --port --vhost --username --password failed"
    amqp-delete-queue -u -e -q test_queue1 -u amqp://127.0.0.1:5672 --ssl --cacert=cacert.pem --key=privkey.pem --cert=cert.pem | grep '[[:digit:]]'
    CHECK_RESULT $? 0 0 "Check amqp-delete-queue -u -e -q -u --ssl --cacert --key --cert failed"
    amqp-delete-queue --help | grep 'Usage: amqp-delete-queue \[OPTIONS\]'
    CHECK_RESULT $? 0 0 "Check amqp-delete-queue --help  failed"
    amqp-delete-queue -? | grep 'Usage: amqp-delete-queue \[OPTIONS\]'
    CHECK_RESULT $? 0 0 "Check amqp-delete-queue -? failed"
    amqp-delete-queue --usage | grep 'Usage: amqp-delete-queue \[-?\]'
    CHECK_RESULT $? 0 0 "Check amqp-delete-queue --usage failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rabbitmqctl delete_user admin
    rabbitmq-plugins disable rabbitmq_management
    rm -rf privkey.pem pubkey.pem cert.pem rabbitmqadmin*
    systemctl stop rabbitmq-server
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
