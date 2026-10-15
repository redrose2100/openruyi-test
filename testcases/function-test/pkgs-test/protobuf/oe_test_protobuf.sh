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
# @Author    :   changxuqing
# @Contact   :   changxuqing@uniontech.com
# @Date      :   2023/04/07
# @License   :   Mulan PSL v2
# @Desc      :   test protobuf
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "protobuf-bom protobuf-java protobuf-java-util protobuf-javadoc protobuf-javalite protobuf-parent python3-protobuf protobuf protobuf-compiler protobuf-devel protobuf-lite protobuf-lite-devel"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  protoc --version 2>&1 | grep -i "libprotoc"
  CHECK_RESULT $? 0 0 "Installation failure"
  protoc person.proto --cpp_out=./
  test -e person.pb.cc
  CHECK_RESULT $? 0 0 "pb.cc failure"
  test -e person.pb.h
  CHECK_RESULT $? 0 0 "pb.h failure"
  protoc person.proto --python_out=./
  test -e person_pb2.py
  CHECK_RESULT $? 0 0 "pb2.py failure"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE
  rm -rf  person.pb.cc person.pb.h person_pb2.py
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
