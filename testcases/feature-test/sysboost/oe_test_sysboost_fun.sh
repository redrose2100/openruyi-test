#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   leijifeng
#@Contact       :   leijifeng@h-partners.com
#@Date          :   2023-10-17
#@License       :   Mulan PSL v2
#@Desc          :   sysboost test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
alias ..='cd ..'
alias ...='cd ../..'
shopt -s expand_aliases

function pre_test() {
    DNF_INSTALL "sysboost bash-relocation coreutils-relocation ncurses-relocation zlib-relocation openssl-relocation"
    if ! rpm -q sysboost bash-relocation coreutils-relocation ncurses-relocation zlib-relocation openssl-relocation; then
        exit 255
    fi
    cat <<EOF >/etc/sysboost.d/bash.toml
elf_path = "/usr/bin/bash"
mode = "static-nolibc"
libs = ["/usr/lib64/libtinfo.so.6"]
EOF

    cat <<EOF >/etc/sysboost.d/od.toml
elf_path = "/usr/bin/od"
mode = "static-nolibc"
libs = []
EOF

    cat <<EOF >/etc/sysboost.d/rm.toml
elf_path = "/usr/bin/rm"
mode = "static-nolibc"
libs = []
EOF

    cat <<EOF >/etc/sysboost.d/sort.toml
elf_path = "/usr/bin/sort"
mode = "static-nolibc"
libs = ["/usr/lib64/libcrypto.so.3","/usr/lib64/libz.so.1"]
EOF

    cat <<EOF >/etc/sysboost.d/tee.toml
elf_path = "/usr/bin/tee"
mode = "static-nolibc"
libs = []
EOF

    cat <<EOF >/etc/sysboost.d/wc.toml
elf_path = "/usr/bin/wc"
mode = "static-nolibc"
libs = []
EOF

    cat <<EOF >bashtest.sh
#!/usr/bin/bash
sleep 60
EOF
}

function run_test() {
    cur_path=$(pwd)
    systemctl start sysboost
    CHECK_RESULT $? 0
    sleep 5

    for commands in bash od rm sort tee wc; do
        test -e /usr/bin/${commands}.rto
        CHECK_RESULT $? 0 || break
    done

    bash bashtest.sh &
    pid=$!
    grep "bash.rto" /proc/${pid}/smaps
    CHECK_RESULT $? 0

    Size=$(grep -A 23 ".*r-xp.*/usr/bin/bash.rto" /proc/${pid}/smaps | grep "^Size:" | awk '{print $2}')
    FilePmdMapped=$(grep -A 23 ".*r-xp.*/usr/bin/bash.rto" /proc/${pid}/smaps | grep "^FilePmdMapped:" | awk '{print $2}')
    [[ "${Size}" = "${FilePmdMapped}" ]]
    CHECK_RESULT $? 0

    test_dir1=test1
    test_dir2=test2
    test_dir3=test3
    mkdir -p ${test_dir1}/${test_dir2}/${test_dir3}
    cd ${test_dir1}/${test_dir2}/${test_dir3} || exit
    ..
    value_1=$(pwd | grep -Fxc "${cur_path}/${test_dir1}/${test_dir2}")
    CHECK_RESULT "${value_1}" 1
    cd ${test_dir3} || exit
    ...
    value_2=$(pwd | grep -Fxc "${cur_path}/${test_dir1}")
    CHECK_RESULT "${value_2}" 1
}

function post_test() {
    if ! rpm -q sysboost bash-relocation coreutils-relocation ncurses-relocation zlib-relocation openssl-relocation; then
        exit 255
    fi
    pstree -p ${pid} | awk -F'[()]' '{for(i=0;i<=NF;i++) if ($i~/(^[0-9])+/) print $i}' | xargs kill -9
    systemctl stop sysboost
    for commands in bash od rm sort tee wc; do
        rm -f /etc/sysboost.d/"${commands}.toml" /usr/bin/"${commands}.rto"
    done
    rm -rf "${cur_path:?}/${test_dir1:?}" "${cur_path:?}"/bashtest.sh
    DNF_REMOVE "$@"
}

main "$@"
