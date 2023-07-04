# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yuanlulu
# @Contact   :   1297248816@qq.com
# @Date      :   2023/06/28
# @License   :   Mulan PSL v2
# @Desc      :   Test jvmprobe
# #############################################
source common/gala-gopher.sh

function pre_test() {
    start_gopher
    rm -rf /tmp/java-data*
}

function run_test() {
    yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel javassist
    ls common/JavaOOMHttpServer.class || javac -classpath /usr/share/java/javassist.jar common/JavaOOMHttpServer.java
    if is_support_rest;then
        # 添加动态配置
	curl -X PUT http://localhost:9999/jvm -d json='{"cmd":{"bin":"/opt/gala-gopher/extend_probes/jvmprobe","check_cmd":""},"snoopers":{"proc_name":[{"comm":"java","cmdline":"JavaOOMHttpServer8007","debugging_dir":""}]},"params":{"report_event":1,"report_period":5,"latency_thr":10,"res_lower_thr":10,"res_upper_thr":50,"metrics_type":["raw","telemetry"]}}'
        #启动探针
        curl -X PUT http://localhost:9999/jvm -d json='{"state": "running"}'
        CHECK_RESULT $? 0 0
        ps aux | grep "extend_probes\/jvmprobe" | grep -v grep
        CHECK_RESULT $? 0 0
    else
        # check jvmprobe
	ps aux | grep "extend_probes\/jvmprobe" | grep -v grep
        CHECK_RESULT $? 0 0
    fi

    # start java process
    cd common
    java JavaOOMHttpServer 8007 &
    pid=$!
    cd -
    sleep 1
    ps aux | grep 'java JavaOOMHttpServer' | grep -v grep
    CHECK_RESULT $? 0 0

    # check
    for((i=0;i<5;i++));do
	ls /tmp | grep java-data-"$pid"
	[ $? -eq 0 ] && break
	sleep 1
    done
    curl "${NODE1_IPV4}":8888 > jvm.txt
    while read line; do
        cat jvm.txt | grep "$line"
	[ $? -eq 0 ] || echo "jvm:$line" >> fail_log
    done < metrics/jvm_metrics
    check_log

    # multi java process
    for((i=0;i<100;i++));do
	java JavaOOMHttpServer $((8008+i))&
    done
    for((i=0;i<100;i++));do
        ls /tmp | grep java-data | wc -l | grep 101
        [ $? -eq 0 ] && break
        sleep 1
    done
    [ $i -le 60 ] 
    CHECK_RESULT $? 0 0
}

function post_test() {
    # clean env
    ps uax | grep 'java JavaOOMHttpServer' | grep -v grep | awk '{print $2}' | xargs kill -9
    clean_gopher
}
main "$@"
