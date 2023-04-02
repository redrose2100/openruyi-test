#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test fluent-gem
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-fluentd tar"
    extract_data
    fluent-gem install rake
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    fluent-gem --help | grep "RubyGems is a package"
    CHECK_RESULT $? 0 0 "Check fluent-gem --help failed"
    fluent-gem -h | grep "RubyGems is a package"
    CHECK_RESULT $? 0 0 "Check fluent-gem -h failed"
    fluent-gem -v | grep -e "[0-9].[0-9]"
    CHECK_RESULT $? 0 0 "Check fluent-gem -v failed"
    fluent-gem --version | grep -e "[0-9].[0-9]"
    CHECK_RESULT $? 0 0 "Check fluent-gem --version failed"
    pushd ./data/gem
        fluent-gem build hola.gemspec | grep "Successfully built RubyGem"
        CHECK_RESULT $? 0 0 "Check fluent-gem build failed"
        rm -f hola-0.0.0.gem 
    popd
    fluent-ca-generate tmp tmp@123
    fluent-gem cert -a ./tmp/ca_cert.pem  | grep "Added"
    CHECK_RESULT $? 0 0 "Check fluent-gem cert failed"
    rm -rf tmp
    fluent-gem check | grep "Checking gems"
    CHECK_RESULT $? 0 0 "Check fluent-gem check failed"
    fluent-gem cleanup | grep "Clean up complete"
    CHECK_RESULT $? 0 0 "Check fluent-gem cleanup failed"
    fluent-gem contents rake | grep "rake.gemspec"
    CHECK_RESULT $? 0 0 "Check fluent-gem contents failed"
    fluent-gem dependency rake | grep "Gem rake"
    CHECK_RESULT $? 0 0 "Check fluent-gem dependency failed"
    fluent-gem fetch rake
    ls -al | grep "rake"
    CHECK_RESULT $? 0 0 "Check fluent-gem fetch failed"
    rm -f rake*gem
    fluent-gem environment | grep "RubyGems Environment"
    CHECK_RESULT $? 0 0 "Check fluent-gem environment failed"
    gem generate_index | grep "Generating Marshal quick index gemspecs"
    CHECK_RESULT $? 0 0 "Check fluent-gem generate_index failed"
    fluent-gem help commands | grep "GEM commands are"
    CHECK_RESULT $? 0 0 "Check fluent-gem help failed"
    fluent-gem info rake | grep "Installed at"
    CHECK_RESULT $? 0 0 "Check fluent-gem info failed"
    fluent-gem install rake  | grep "Successfully installed rake"
    CHECK_RESULT $? 0 0 "Check fluent-gem install failed"
    fluent-gem list rake | grep "rake ("
    CHECK_RESULT $? 0 0 "Check fluent-gem list failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    rm -rf quick *specs.4.8*
    LOG_INFO "End to restore the test environment."
}
main "$@"
