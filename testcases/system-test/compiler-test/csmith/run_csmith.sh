#!/bin/sh

#set -x

RED=$(printf "\033[31m")
GREEN=$(printf "\033[32m")
NONE=$(printf "\033[39m")

total=0
passed=0
failed=0

echo $1

failed_logs_dir=/tmp/os_test_csmith/failed_cases/

summary() {
	echo "Total: $total Passed: $passed Failed: $failed" > /tmp/oe_test_csmith/result.txt
}

create_logdir() {
    if [ -d "/tmp/os_test_csmith/failed_cases" ]; then
        rm -rf $failed_logs_dir
    fi
    mkdir -p $failed_logs_dir
}

run() {
    for i in `seq 1 $1`
    do
        cfile="random$i.c"
        csmith > $cfile
        gcc $cfile -I/root/csmith/install/include -o random_gcc
        clang $cfile -I/root/csmith/install/include -o random_clang
        gcc_checksum=$(./random_gcc)
        clang_checksum=$(./random_clang)
        gcc_value=${gcc_checksum:11}
        clang_value=${clang_checksum:11}
        if [ $gcc_value = $clang_value ]; then
           echo "${GREEN}Passed${NONE}"
           passed=$(($passed + 1))
        else
           echo "${RED}Failed${NONE}"
           cp $cfile $failed_logs_dir
           failed=$(($failed + 1))
	fi
        total=$(($total + 1))
        rm -rf $cfile
        rm -rf random_gcc
        rm -rf random_clang
        summary
    done
}

create_logdir
run $1
summary
exit 0

