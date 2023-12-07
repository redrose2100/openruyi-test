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
# @Date      :   2023/11/30
# @License   :   Mulan PSL v2
# @Desc      :   test grpc
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "gcc-c++ make git protobuf-devel grpc grpc-devel python3-grpcio"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  protoc -I . --cpp_out=./ ./common/helloworld.proto
  CHECK_RESULT $? 0 0 "djvm failure"
  test -e  common/helloworld.pb.cc
  CHECK_RESULT $? 0 0 "output.djvu not exist"
  test -e  common/helloworld.pb.h
  CHECK_RESULT $? 0 0 "output.djvu not exist"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf  common/helloworld.pb.cc   common/helloworld.pb.h
  LOG_INFO "Finish environment cleanup!"
}

main "$@"