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

  tb_polgen --create --type nonfatal vl.pol
  CHECK_RESULT $? 0 0 "Check tb_polgen create --type  failed"

  tb_polgen --add --num 1 --pcr 18 --hash any vl.pol
  CHECK_RESULT $? 0 0 "Check tb_polgen --add --num --pcr --hash  failed"

  tb_polgen --del --num 0 list.pol 2>&1 | grep 'Policy'
  CHECK_RESULT $? 0 0 "Check tb_polgen del failed"

  lcp2_crtpol --create --alg sha1 --polver 3.2 --type any --pol list.pol --sign rsa-2048-sha1
  CHECK_RESULT $? 0 0 "Check --create --alg sha1 --polver 3.2 --type any --pol list.pol failed"

  lcp2_crtpolelt --create --type pconf --out pconf.elt
  CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --unwrap --elt failed"

  tb_polgen --unwrap --elt list.pol pconf.elt --verbose 2>&1 | grep 'cmd'
  CHECK_RESULT $? 0 0 "Check tb_polgen --unwrap --elt failed"

  tb_polgen --show vl.pol 2>&1 | grep 'policy'
  CHECK_RESULT $? 0 0 "Check tb_polgen --show failed"

  tb_polgen --help 2>&1 | grep 'tb_polgen'
  CHECK_RESULT $? 0 0 "Check tb_polgen --help failed"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf vl.pol list.pol pconf.elt
  DNF_REMOVE

  LOG_INFO "Finish restoring the test environment."
}

main $@
