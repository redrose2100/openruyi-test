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
# @Date      :   2023/06/29
# @License   :   Mulan PSL v2
# @Desc      :   Test gala-gopher docker
# #############################################
source common/gala-gopher.sh

function pre_test() {
    start_kafka
    start_gopher
}

function run_test() {
    #python探针未改造
    docker ps
    expect_eq $? 0 || docker ps -a
    check_gala_gopher
    ps aux | grep -v grep | grep cadvisor_probe.py
    CHECK_RESULT $? 0 0

    sleep 60
    curl "$ETS_LOCAL_IP":8888 > docker.txt
    while read line; do
        cat docker.txt | grep container | grep "$line" | grep container_id
        [ $? -eq 0 ] || echo "container:$line not exist" >> fail_log
    done < metrics/container_metric
    check_log
}

function post_test() {
    # clean env
    clean_kafka
    clean_gopher
}
main "$@"
