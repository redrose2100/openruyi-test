#!/usr/bin/bash

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    if ["${NODE1_FRAME}"="x86_64"];then
        echo "the environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager"
    systemctl restart oeaware
    cp /etc/oeAware/analysis_config.yaml /etc/oeAware/analysis_config.yaml_bak
    LOG_INFO "End to prepare the test environment"
}
function run_test(){
    LOG_INFO "Start to run the test."
    yaml_dir=/etc/oeAware/analysis_config.yaml
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn:.*docker_coordination_burst:(host|docker)_cpu_usage_threshold"
    CHECK_RESULT $? 0 1 "Check docker threshold failed."
    
    sed -i '/^  host_cpu_usage_threshold:/ s/[-?0-9]\+/1/' $yaml_dir
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn:.*docker_coordination_burst:(host|docker)_cpu_usage_threshold"
    CHECK_RESULT $? 0 1 "Check docker threshold failed."
    sed -i '/^  host_cpu_usage_threshold:/ s/[-?0-9]\+/100/' $yaml_dir
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn:.*docker_coordination_burst:(host|docker)_cpu_usage_threshold"
    CHECK_RESULT $? 0 1 "Check docker threshold failed."
    sed -i '/^  host_cpu_usage_threshold:/ s/[-?0-9]\+/-1/' $yaml_dir
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn:.*docker_coordination_burst:host_cpu_usage_threshold"
    CHECK_RESULT $? 0 0 "Check docker threshold failed."
    sed -i '/^  host_cpu_usage_threshold:/ s/[-?0-9]\+/101/' $yaml_dir
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn:.*docker_coordination_burst:host_cpu_usage_threshold"
    CHECK_RESULT $? 0 0 "Check docker threshold failed."
    sed -i '/^  host_cpu_usage_threshold:/ s/[-?0-9]\+/45/' $yaml_dir

    sed -i '/^  docker_cpu_usage_threshold:/ s/[-?0-9]\+/1/' $yaml_dir
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn:.*docker_coordination_burst:(host|docker)_cpu_usage_threshold"
    CHECK_RESULT $? 0 1 "Check docker threshold failed."
    sed -i '/^  docker_cpu_usage_threshold:/ s/[-?0-9]\+/100/' $yaml_dir
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn:.*docker_coordination_burst:(host|docker)_cpu_usage_threshold"
    CHECK_RESULT $? 0 1 "Check docker threshold failed."
    sed -i '/^  docker_cpu_usage_threshold:/ s/[-?0-9]\+/-1/' $yaml_dir
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn:.*docker_coordination_burst:docker_cpu_usage_threshold"
    CHECK_RESULT $? 0 0 "Check docker threshold failed."
    sed -i '/^  docker_cpu_usage_threshold:/ s/[-?0-9]\+/101/' $yaml_dir
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn:.*docker_coordination_burst:docker_cpu_usage_threshold"
    CHECK_RESULT $? 0 0 "Check docker threshold failed."
    LOG_INFO "End to run the test."
}
function post_test(){
    LOG_INFO "Start to restore the test environment"
    mv /etc/oeAware/analysis_config.yaml_bak /etc/oeAware/analysis_config.yaml 
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment"
}

main "$@"
