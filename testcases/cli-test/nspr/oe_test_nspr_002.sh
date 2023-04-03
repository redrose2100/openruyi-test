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
# @Desc      :   File system common command test-nspr
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    cat > /tmp/test_nspr2.cpp  <<EOF
#include "nspr.h"
#include <iostream>
#include <vector>
#include <string>
#pragma comment(lib,"nspr4.lib")
#pragma comment(lib,"plc4.lib")
using namespace std;
int main(int argc, char* argv[])
{
std::vector<std::string> vDirName;
vector<string> vFileName;
char err[256];
string strBaseName= "/root/";
string strFileName;
PR_Init(PR_USER_THREAD, PR_PRIORITY_NORMAL, 0);
PRFileInfo info = {};
PRDir* dir = PR_OpenDir(strBaseName.c_str());
PRDirEntry* dirEntry = PR_ReadDir(dir, PR_SKIP_BOTH);
do{
strFileName.clear();
strFileName = strBaseName + dirEntry->name;
if (PR_SUCCESS == PR_GetFileInfo(strFileName.c_str(), &info))
{
if (info.type == PR_FILE_DIRECTORY)
{
vDirName.push_back(strFileName);
cout << vDirName.back().c_str() << "  Dir" << endl;
}else
{
vFileName.push_back(strFileName);
cout << vFileName.back().c_str() << "  File" << endl;
}
}
else{
PR_GetErrorText(err);
}
}while ((dirEntry = PR_ReadDir(dir, PR_SKIP_BOTH)));
PR_CloseDir(dir);
PR_Cleanup();
return 0;
}
EOF
    DNF_INASTALL "nspr-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep nspr
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && g++ test_nspr2.cpp -o test_nspr2 -I /usr/include/nspr4 -L /usr/lib64 -lnspr4
    test -f /tmp/test_nspr2
    CHECK_RESULT $? 0 0 "compile testfile fail"    
    ./test_nspr2 > test
    test -f /tmp/test
    CHECK_RESULT $? 0 0 "Generate test fail "
    grep "/root/.bash_history  File" /tmp/test
    CHECK_RESULT $? 0 0 "information is error"   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test_nspr2 /tmp/test_nspr2.cpp /tmp/test
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main $@
