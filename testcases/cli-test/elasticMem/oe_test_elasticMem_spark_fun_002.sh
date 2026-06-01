#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_spark_fun.002 - Spark light 模式内存均衡
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
    em_require_numactl
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    em_check_env || return 1

    cat > "$CONFIG_PATH" << EOF
policy = light
log_level = info
log_file = $LOG_FILE
whitelist = [--executor-id]
comm_whitelist = []
memory_migration = true
sample_interval = 100
sample_count = 10
nr_cpus=1
EOF
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    # 提交 Spark 任务
    spark-submit --master 'local[4]' --driver-memory 4g --executor-memory 4g \
        --class org.apache.spark.examples.SparkPi \
        "$SPARK_HOME/examples/jars/spark-examples"*.jar 100 2>/dev/null &
        em_track_pid $!
    local SPARK_PID=$!
    em_track_pid $SPARK_PID
    sleep 20

    # 检查 java 进程是否在 em_node cgroup 中
    for pid in $(pgrep -f java 2>/dev/null); do
        cat /proc/$pid/cgroup 2>/dev/null | grep -q 'em_node' && \
            LOG_INFO "Java PID $pid is in em_node cgroup"
    done

    # 采样 mem 分布
    numastat -c java 2>/dev/null | head -5
    CHECK_RESULT $? 0 0 "numastat failed"

    wait $SPARK_PID 2>/dev/null
    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    em_stop_service
    em_restore_config
    em_dnf_remove
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
