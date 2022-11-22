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
# @Desc      :   verify the uasge of tboot command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL tboot
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  if [[ 20.03 == $(cat /etc/os-release | awk '{if($2 ~ /^\w/){print $2}}') ]]; then
    lcp2_crtpollist --create --out list_unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --create --listver --out failed"
  else
    lcp2_crtpollist --create --listver 0x200 --out list_unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --create --listver --out failed"

    lcp2_crtpollist --verify list_unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --verify  failed"

    lcp2_crtpollist --version 2>&1 | grep 'lcp2_crtpollist version'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --version  failed"
  fi

  openssl genrsa -out privkey.pem 2048
  openssl rsa -pubout -in privkey.pem -out pubkey.pem
  lcp2_crtpollist --sign --sigalg rsa --pub pubkey.pem --priv privkey.pem --out list_unsig.lst
  CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --sign --sigalg --pub --priv --out  failed"

  lcp2_crtpollist --show list_unsig.lst 2>&1 | grep 'policy'
  CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --show failed"

  lcp2_crtpollist --help 2>&1 | grep 'Usage:'
  CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --help  failed"

  lcp2_crtpollist --show list_unsig.lst --verbose
  CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --show --verbose failed"

  rm -rf list_unsig privkey.pem pubkey.pem

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."

  DNF_REMOVE

  LOG_INFO "Finish restoring the test environment."
}

main $@
