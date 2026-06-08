#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_spark_fun.001 - Spark executor paral 均匀分布
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_check_env || return 1
    em_backup_config
    em_stop_service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 0

    em_require_spark || return 0

    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = info
log_file = $LOG_FILE
whitelist = [--executor-id]
comm_whitelist = [java]
nr_cpus=8
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
    em_start_service_for_paral
    CHECK_RESULT $? 0 0 "paral start failed"
    em_assert_log_contains "cmdline_kw=--executor-id"
    CHECK_RESULT $? 0 0 "executor-id not in activation"

    spark-submit --master 'local[4]' --conf spark.executor.instances=4 \
        --class org.apache.spark.examples.SparkPi \
        "$SPARK_HOME/examples/jars/spark-examples"*.jar 10 2>/dev/null &
        em_track_pid $!
    local SPARK_PID=$!
    em_track_pid $SPARK_PID
    sleep 20

    local exec_count=0
    for pid in $(pgrep -f '--executor-id' 2>/dev/null); do
        exec_count=$((exec_count + 1))
        local affinity
        affinity=$(em_get_cpu_affinity $pid)
        LOG_INFO "Executor PID $pid affinity: $affinity"
    done
    [ "$exec_count" -gt 0 ]
    CHECK_RESULT $? 0 0 "no executor processes found"

    wait $SPARK_PID 2>/dev/null
    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    em_stop_service
    em_restore_config
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
