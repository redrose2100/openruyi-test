#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2024/03/13
# @License   :   Mulan PSL v2
# @Desc      :   Test XML Schema Definition
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "xsd"
    echo -e "<rootElement>
  <childElement>Example</childElement>
</rootElement>" > data.xml
    echo -e "<xs:schema xmlns:xs=\"http://www.w3.org/2001/XMLSchema\">
  <xs:element name=\"rootElement\">
    <xs:complexType>
      <xs:sequence>
        <xs:element name=\"childElement\" type=\"xs:string\"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>" > schema.xsd  
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    xmllint --schema schema.xsd data.xml | grep "xml version"
    CHECK_RESULT $? 0 0 "The xsd specification document failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf data.xml schema.xsd
    LOG_INFO "End to restore the test environment."
}

main "$@"
