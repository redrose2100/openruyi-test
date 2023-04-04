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
    cat > /tmp/readxml.cpp  <<EOF
#include <libxml/parser.h>
#include <iostream>
using namespace std;
int main(int argc, char* argv[])
{
xmlDocPtr doc;           //定义解析文档指针
xmlNodePtr curNode;      //定义结点指针(你需要它为了在各个结点间移动)
xmlChar *szKey;          //临时字符串变量
char *szDocName;
if (argc <= 1)
{
printf("Usage: %s docname\n", argv[0]);
return(0);
}
szDocName = argv[1];
//下面两句是格式化xml的语句
xmlKeepBlanksDefault(0) ;
xmlIndentTreeOutput = 1 ;
doc = xmlReadFile(szDocName,"GB2312",XML_PARSE_RECOVER); //解析文件
//检查解析文档是否成功，如果不成功，libxml将指一个注册的错误并停止。
//一个常见错误是不适当的编码。XML标准文档除了用UTF-8或UTF-16外还可用其它编码保存。
//如果文档是这样，libxml将自动地为你转换到UTF-8。更多关于XML编码信息包含在XML标准中.
if (NULL == doc)
{
fprintf(stderr,"Document not parsed successfully. \n");
return -1;
}
curNode = xmlDocGetRootElement(doc); //确定文档根元素
/*检查确认当前文档中包含内容*/
if (NULL == curNode)
{
fprintf(stderr,"empty document\n");
xmlFreeDoc(doc);
return -1;
}
/*在这个例子中，我们需要确认文档是正确的类型。“root”是在这个示例中使用文档的根类型。*/
if (xmlStrcmp(curNode->name, BAD_CAST "root"))
{
fprintf(stderr,"document of the wrong type, root node != root");
xmlFreeDoc(doc);
return -1;
}
curNode = curNode->xmlChildrenNode;
xmlNodePtr propNodePtr = curNode;
while(curNode != NULL)
{
//取出节点中的内容
if ((!xmlStrcmp(curNode->name, (const xmlChar *)"UOS1")))
{
szKey = xmlNodeGetContent(curNode);
printf("newNode1: %s\n", szKey);
xmlFree(szKey);
}
//查找带有属性attribute的节点
if (xmlHasProp(curNode,BAD_CAST "UOS"))
{
propNodePtr = curNode;
}
curNode = curNode->next;
}
//查找属性
xmlAttrPtr attrPtr = propNodePtr->properties;
while (attrPtr != NULL)
{
if (!xmlStrcmp(attrPtr->name, BAD_CAST "UOS"))
{
xmlChar* szAttr = xmlGetProp(propNodePtr,BAD_CAST "UOS");
cout<<"get value = "<<szAttr<<endl;
xmlFree(szAttr);
}
attrPtr = attrPtr->next;
}
xmlFreeDoc(doc);
return 0;
}
EOF
    DNF_INASTALL "libxml2 libxml2-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep libxml2
    CHECK_RESULT $? 0 0 "Return value error"
    cp CreatedXml.xml /tmp/
    cd /tmp && g++ readxml.cpp -o readxml -I /usr/include/libxml2/ -L /usr/local/lib -lxml2 -lm -lz
    test -f /tmp/readxml
    CHECK_RESULT $? 0 0 "compile testfile fail"     
    ./readxml CreatedXml.xml > libxml2
    grep "get value = yes" /tmp/libxml2
    CHECK_RESULT $? 0 0 "libxml2 information error "
   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/readxml /tmp/readxml.cpp /tmp/CreatedXml.xml /tmp/libxml2
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main $@
