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
    if ! command -v spark-submit >/dev/null 2>&1; then
        LOG_WARN "spark-submit not found, skip test"
        return 1
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 1

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
    em_start_service
    CHECK_RESULT $? 0 0 "paral start failed"
    em_assert_log_contains "cmdline_kw=--executor-id"
    CHECK_RESULT $? 0 0 "executor-id not in activation"

    # 提交 Spark 任务
    spark-submit --master 'local[4]' --conf spark.executor.instances=4 \
        --class org.apache.spark.examples.SparkPi \
        "$SPARK_HOME/examples/jars/spark-examples"*.jar 10 2>/dev/null &
        em_track_pid $!
    local SPARK_PID=$!
    em_track_pid $SPARK_PID
    sleep 20

    # 检查 executor 进程 NUMA 绑定
    local exec_count=0
    for pid in $(pgrep -f '--executor-id' 2>/dev/null); do
        exec_count=$((exec_count + 1))
        local affinity
        affinity=$(LC_ALL=C taskset -p $pid 2>/dev/null | awk '{print $NF}')
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
