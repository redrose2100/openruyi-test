#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-04-11
# @License   :   Mulan PSL v2
# @Desc      :   Use cairo case
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "cairo-devel"
    pwd=`pwd`
    mkdir cairo_test/ && cd cairo_test/
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    cat > cairo_test.c << EOF
#include <cairo.h>
#define SIZE (640) /* 太极图大小 */
#define CX (SIZE / 2) /* 太极圆中心横坐标 */
#define CY (SIZE / 2) /* 太极圆中心纵坐标 */
#define R (SIZE / 2) /* 太极圆半径 */
/* 把角度转换为所对应的弧度 */
#define ANGLE(ang) (ang * 3.1415926 / 180.0)
int main(int argc, char *argv[])
{
/* 创建32位RGBA颜色格式的Cairo绘图环境，直接在Memory中渲染 */
cairo_surface_t* surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, SIZE + 1, SIZE + 1);
cairo_t* cr = cairo_create(surface);
/* 绘制太极边框 */
cairo_set_line_width(cr, 2.0);
cairo_set_source_rgba(cr, 0, 0, 0, 1);
cairo_arc(cr, CX, CY, R, ANGLE(0), ANGLE(360));
cairo_stroke(cr);
/* 绘制阴阳圆 */
cairo_set_source_rgba(cr, 0, 0, 0, 1);
cairo_arc(cr, CX, CY, R, ANGLE(90), ANGLE(270));
cairo_fill(cr);
cairo_set_source_rgba(cr, 1, 1, 1, 1);
cairo_arc(cr, CX, CY, R, ANGLE(-90), ANGLE(90));
cairo_fill(cr);
/* 绘制阴阳线 */
cairo_set_source_rgba(cr, 0, 0, 0, 1);
cairo_arc(cr, CX, CY - R / 2, R / 2, ANGLE(-90), ANGLE(90));
cairo_fill(cr);
cairo_set_source_rgba(cr, 1, 1, 1, 1);
cairo_arc(cr, CX, CY + R / 2, R / 2, ANGLE(90), ANGLE(270));
cairo_fill(cr);
/* 绘制太极眼 */
cairo_set_source_rgba(cr, 1, 1, 1, 1);
cairo_arc(cr, CX, CY - R / 2, R / 10, ANGLE(0), ANGLE(360));
cairo_fill(cr);
cairo_set_source_rgba(cr, 0, 0, 0, 1);
cairo_arc(cr, CX, CY + R / 2, R / 10, ANGLE(0), ANGLE(360));
cairo_fill(cr);
/* 将Memory的渲染效果存储到图片中 */
cairo_surface_write_to_png(surface, "cairo_test.png");
/* 销毁并退出Cairo绘图环境 */
cairo_destroy(cr);
cairo_surface_destroy (surface);
return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Fail to cairo_test.c"
    gcc -o cairo_test1 $(pkg-config --cflags --libs cairo) cairo_test.c
    CHECK_RESULT $? 0 0 "Error,check the file cairo_test.c"
    ls |grep cairo_test1
    CHECK_RESULT $? 0 0 "Error,fail to create cairo_test1"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    cd $pwd && rm -rf cairo_test/
    LOG_INFO "End to restore the test environment."
}

main "$@"