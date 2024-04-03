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
# @Date      :   2023.8.15
# @License   :   Mulan PSL v2
# @Desc      :   gtk+_test formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){

cat > /tmp/gtk+_test.c << EOF
#include <gtk/gtk.h>
int main(int argc, char* argv[])
{
GtkWidget* window;
GtkWidget* label;
gtk_init(&argc, &argv);
window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
label = gtk_label_new("Hello World.");
gtk_container_add(GTK_CONTAINER(window), label);
gtk_widget_show_all(window);
gtk_main();
return 0;
}
EOF

    LOG_INFO "Start environment preparation."
    DNF_INSTALL "gcc gtk3 gtk3-devel gtk+ gtk+-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep gtk
    CHECK_RESULT $? 0 0 "Return value error"
    read -ra pkg_config_args < <(pkg-config --cflags --libs gtk+)
    cd /tmp && gcc -o gtk+_test gtk+_test.c $"${pkg_config_args[@]}"
    test -f /tmp/gtk+_test
    CHECK_RESULT $? 0 0 "compile gtk+_test.c fail"    
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/gtk+_test.c /tmp/gtk+_test
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

