#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.4.3
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-libxml2
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    cat > /tmp/createxml.cpp  <<EOF
#include <stdio.h>
#include <stdlib.h>
#include <libxml/parser.h>
#include <libxml/tree.h>
#include <iostream>
using namespace std;
int main()
{
//定义文档和节点指针
xmlDocPtr doc = xmlNewDoc(BAD_CAST"1.0");
xmlNodePtr root_node = xmlNewNode(NULL,BAD_CAST"root");
//设置根节点
xmlDocSetRootElement(doc,root_node);
//在根节点中直接创建节点
xmlNewTextChild(root_node, NULL, BAD_CAST "UOS1", BAD_CAST "UOS1 content");
xmlNewTextChild(root_node, NULL, BAD_CAST "UOS2", BAD_CAST "UOS2 content");
xmlNewTextChild(root_node, NULL, BAD_CAST "UOS3", BAD_CAST "UOS3 content");
//创建一个节点，设置其内容和属性，然后加入根结点
xmlNodePtr node = xmlNewNode(NULL,BAD_CAST"node2");
xmlNodePtr content = xmlNewText(BAD_CAST"NODE CONTENT");
xmlAddChild(root_node,node);
xmlAddChild(node,content);
xmlNewProp(node,BAD_CAST"UOS",BAD_CAST "yes");
//创建一个儿子和孙子节点
node = xmlNewNode(NULL, BAD_CAST "xian-uos");
xmlAddChild(root_node,node);
xmlNodePtr grandson = xmlNewNode(NULL, BAD_CAST "branch");
xmlAddChild(node,grandson);
xmlAddChild(grandson, xmlNewText(BAD_CAST "xian-uos yes!"));
//存储xml文档
int nRel = xmlSaveFile("CreatedXml.xml",doc);
if (nRel != -1)
{
cout<<"一个xml文档被创建,写入"<<nRel<<"个字节"<<endl;
}
//释放文档内节点动态申请的内存
xmlFreeDoc(doc);
return 1;
}
EOF
    DNF_INASTALL "libxml2 libxml2-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep libxml2
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && g++ createxml.cpp -o createdxml -I /usr/include/libxml2/ -L /usr/local/lib -lxml2 -lm -lz
    test -f /tmp/createdxml
    CHECK_RESULT $? 0 0 "compile testfile fail"    
    ./createdxml
    test -f /tmp/CreatedXml.xml
    CHECK_RESULT $? 0 0 "Generate CreatedXml.xml fail "
    grep "<UOS2>UOS2 content</UOS2><UOS3>UOS3 content</UOS3>" /tmp/CreatedXml.xml
    CHECK_RESULT $? 0 0 "CreatedXml.xml information is error"
    xmllint --format CreatedXml.xml --output createxml.xml
    CHECK_RESULT $? 0 0 "Generate createxml.xml fail"
    grep "<UOS3>UOS3 content</UOS3>" /tmp/createxml.xml |grep -v "<UOS2>UOS2 content</UOS2>"
    CHECK_RESULT $? 0 0 "createxml.xml information error"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/createdxml /tmp/createxml.cpp /tmp/CreatedXml.xml /tmp/createxml.xml
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main $@
