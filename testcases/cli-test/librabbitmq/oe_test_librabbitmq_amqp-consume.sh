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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nohup amqp-consume -A -q test_queue -c 5 -p 10 -u amqp://127.0.0.1:5672 --ssl --cacert=cacert.pem --key=privkey.pem --cert=cert.pem cat >./info.out 2>&1 &
    SLEEP_WAIT 3
    amqp-publish -r test_queue -b "test_body"
    SLEEP_WAIT 10
    grep "test_body" ./info.out
    CHECK_RESULT $? 0 0 "Check amqp-consume -r -b failed"
    kill -9 $(ps -ef | grep amqp-consume | grep -Ev 'grep|bash' | awk '{print $2}')
    nohup amqp-consume -A -q test_queue -c 5 -p 10 -s 127.0.0.1 --port=5672 --vhost=/ --username=admin --password=admin --heartbeat=1 cat >./info1.out 2>&1 &
    SLEEP_WAIT 3
    amqp-publish -r test_queue -b "test_body"
    SLEEP_WAIT 3
    grep "test_body" ./info1.out
    CHECK_RESULT $? 0 0 "Check amqp-consume -r -b failed"
    kill -9 $(ps -ef | grep amqp-consume | grep -Ev 'grep|bash' | awk '{print $2}')
    nohup amqp-consume -dx -c 5 -p 10 -s 127.0.0.1 --port=5672 -e test-ex -r test-routing -x --vhost=/ --username=guest --password=guest --heartbeat=1 cat >./info2.out 2>&1 &
    SLEEP_WAIT 3
    echo 'aaaaa' | amqp-publish -e test-ex -l --username=guest --password=guest -r test-routing
    SLEEP_WAIT 10
    grep "aaaaa" ./info2.out
    CHECK_RESULT $? 0 0 "Check amqp-consume -e -x failed"
    amqp-consume --help | grep 'Usage: amqp-consume \[OPTIONS\]'
    CHECK_RESULT $? 0 0 "Check  amqp-consume --help failed"
    amqp-consume --usage | grep 'Usage: amqp-consume'
    CHECK_RESULT $? 0 0 "Check amqp-consume --usage failed"
    amqp-consume -? | grep 'Usage: amqp-consume \[OPTIONS\]'
    CHECK_RESULT $? 0 0 "Check amqp-consume -? failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rabbitmqctl delete_user admin
    kill -9 $(ps -ef | grep amqp-consume | grep -Ev 'grep|bash' | awk '{print $2}')
    rabbitmq-plugins disable rabbitmq_management
    rm -rf privkey.pem pubkey.pem cert.pem *.out info* rabbitmqadmin
    systemctl stop rabbitmq-server
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
