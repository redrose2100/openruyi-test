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
# @Date      :   2024/07/04
# @License   :   Mulan PSL v2
# @Desc      :   test ocaml-gettext 
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL ocaml-gettext-devel
  
  # 创建示例的 OCaml 源文件
  echo '(* example.ml *)
let () =
  let greeting = Gettext.gettext "Hello, world!" in
  let farewell = Gettext.gettext "Goodbye, world!" in

  print_endline greeting;
  print_endline farewell' > example.ml
  
  # 创建示例的 .po 文件
cat > example.po <<EOF
msgid ""
msgstr ""
"Content-Type: text/plain; charset=UTF-8\n"
"Language: zh_CN\n"

msgid "Hello, world!"
msgstr "你好，世界！"

msgid "Goodbye, world!"
msgstr "再见，世界！"
EOF

echo "Example .po file created."
EOF

echo "Script created."

  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  
  ocaml-gettext --action extract --extract-pot example.pot example.ml  
  CHECK_RESULT $? 0 0 "Extracting messages from the example.ml file into the example.pot file failed"
  
  ocaml-gettext --action compile --compile-output example.mo example.po
  CHECK_RESULT $? 0 0 "Failed to compile example.po file into example.mo file"
  
  ocaml-gettext --action install --install-language zh_CN --install-textdomain example example.mo
  CHECK_RESULT $? 0 0 "Failed to install the generated example.mo file into the localized directory of the program"
  
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf example*
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
