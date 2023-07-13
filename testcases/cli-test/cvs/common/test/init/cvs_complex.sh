#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/03/18
# @License   :   Mulan PSL v2
# @Desc      :   cvs init
# #############################################
run_dir=$(cd $(dirname $0) && pwd )
cvs_dir=$(cd $(dirname $0) && pwd )/cvs_test/cvs_init_dir
testd_cvs_dir=$(cd $(dirname $0) && pwd )/cvs_test/cvs_testd_dir
DATE=$(date +'%a %B %d %H:%M:%S %Y')
export CVSROOT=$cvs_dir
    groupadd cvs;mkdir -p $cvs_dir $testd_cvs_dir;useradd -g cvs -G cvs -d $cvs_dir cvsroot;
    chown -R cvsroot.cvs $cvs_dir;chmod -R 775 $cvs_dir;
    sed -i "s/## Allows people in group wheel to run all commands/Allows people in group wheel to run all commands/g" /etc/sudoers
    usermod -g root cvsroot;
    su cvsroot << EOF
cvs init
cd cvs_test/cvs_project
cvs import -m "my cvs project" myProject cvsroot start
EOF
    cvs -d $cvs_dir checkout myProject
    chown -R cvsroot.cvs myProject;chmod -R 775 myProject
    cd myProject && touch tmp.txt && cvs add tmp.txt
    chown -R cvsroot.cvs tmp.txt
    su cvsroot << EOF
cvs commit -m 'aa' 2>&1 < /dev/null 
echo "abc" >> tmp.txt
echo " efg" >> 1.txt
mkdir dir;touch dir/2.txt;echo 'new file' >> dir/2.txt
cvs add tmp.txt 1.txt dir tmp.txt 1.txt 2>&1 < /dev/null
cvs add dir/2.txt 2>&1 < /dev/null
cvs commit -m 'aa' 2>&1 < /dev/null
EOF