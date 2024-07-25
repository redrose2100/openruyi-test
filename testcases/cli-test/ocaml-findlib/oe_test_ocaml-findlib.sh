#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2024/06/28
# @License   :   Mulan PSL v2
# @Desc      :   test openjpeg2-tools
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL ocaml-findlib
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  ocamlfind list
  CHECK_RESULT $? 0 0 "Ocamlfind tool failed to list information on all installed OCaml packages in the current system"
  ocamlfind query ocamldoc
  CHECK_RESULT $? 0 0 "Ocamlfind tool failed to list information on all installed OCaml packages in the current system"
  ocamlfind ocamlc -o myexecutable common/mymodule.ml
  test	-f myexecutable 
  CHECK_RESULT $? 0 0 "Compiled mymodule.ml into a bytecode file and generated mymodule.cmi and mymodule.cmo. Next, by default, ocamlc will link mymodule.cmo to the executable file a.out, which fails"
  ./myexecutable |grep "is"
  CHECK_RESULT $? 0 0 "Myexecutable file execution failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf myexecutable  common/mymodule.cmi  common/mymodule.cmo 
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
