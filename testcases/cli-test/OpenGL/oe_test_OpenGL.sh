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
# @Date      :   2023.8.29
# @License   :   Mulan PSL v2
# @Desc      :   OpenGL formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    cat > /tmp/test.c << EOF
#include <GL/glut.h>
void init(void)
{
glClearColor(0.0, 0.0, 0.0, 0.0);
glMatrixMode(GL_PROJECTION);
glOrtho(-5, 5, -5, 5, 5, 15);
glMatrixMode(GL_MODELVIEW);
gluLookAt(0, 0, 10, 0, 0, 0, 0, 1, 0);
return;
}
void display(void)
{
glClear(GL_COLOR_BUFFER_BIT);
glColor3f(1.0, 0, 0);
glutWireTeapot(3);
glFlush();
return;
}
int main(int argc, char *argv[])
{
glutInit(&argc, argv);
glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
glutInitWindowPosition(0, 0);
glutInitWindowSize(300, 300);
glutCreateWindow("OpenGL 3D View");
init();
glutDisplayFunc(display);
glutMainLoop();
return 0;
}
EOF

    DNF_INSTALL "freeglut*"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep freeglut
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && gcc -o test test.c -lGL -lGLU -lglut
    test -f /tmp/test
    CHECK_RESULT $? 0 0 "compile test.c fail"   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.c /tmp/test
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
