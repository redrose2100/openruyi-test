#!/usr/bin/bash

source "${OET_PATH}"/testcases/feature-test/oeaware/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ["${NODE1_FRAME}"="x86_64"];then
        echo "the environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager"
    systemctl restart oeaware
    temp_dir=$(mktemp -d)
    mkdir "$temp_dir/low/"
    mkdir "$temp_dir/high/"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    local test_rounds=5
    local flag=0

    oeawarectl analysis -t 3 | grep -A 100 'Analysis Suggestion' | awk '/^$/ {exit} 1' > "$temp_dir/low/suggestion_1.txt"
    for ((i=2;i<test_rounds+1;i++))
    do
        oeawarectl analysis -t 3 | grep -A 100 'Analysis Suggestion' | awk '/^$/ {exit} 1' > "$temp_dir/low/suggestion_$i.txt"
        diff "$temp_dir/low/suggestion_${i-1}.txt" "$temp_dir/low/suggestion_$i.txt"
        CHECK_RESULT $? 0 0 "Check repeated analysis suggestion failed"
    done

    stress-ng --cpu 6 -t 60 &
    SLEEP 5
    oeawarectl analysis -t 3 | grep -A 100 'Analysis Suggestion' | awk '/^$/ {exit} 1' > "$temp_dir/high/suggestion_1.txt"
    for ((i=2;i<test_rounds+1;i++))
    do
        oeawarectl analysis -t 3 | grep -A 100 'Analysis Suggestion' | awk '/^$/ {exit} 1' > "$temp_dir/high/suggestion_$i.txt"
        diff "$temp_dir/high/suggestion_${i-1}.txt" "$temp_dir/high/suggestion_$i.txt"
        CHECK_RESULT $? 0 0 "Check repeated analysis suggestion failed"
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${temp_dir}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
