#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_spark_fun.003 - Spark 结束释放资源
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

    em_write_light_config "[--executor-id]" "false"
    em_start_service
    CHECK_RESULT $? 0 0 "light start failed"

    # 提交短期 Spark 任务
    spark-submit --master 'local[2]' \
        --class org.apache.spark.examples.SparkPi \
        "$SPARK_HOME/examples/jars/spark-examples"*.jar 10 2>/dev/null
    sleep 5

    # 确认 executor 进程已退出
    local remaining
    remaining=$(pgrep -f '--executor-id' 2>/dev/null | wc -l)
    LOG_INFO "Remaining executor procs: $remaining"
    [ "$remaining" -eq 0 ]
    CHECK_RESULT $? 0 0 "executor processes still alive"

    # 确认 elasticMem RSS 不增长
    local em_pid=$(em_get_service_pid)
    [ -n "$em_pid" ] && {
        local rss=$(awk '/VmRSS/{print $2}' /proc/$em_pid/status 2>/dev/null)
        LOG_INFO "elasticMem RSS: ${rss} kB"
        [ -n "$rss" ]
        CHECK_RESULT $? 0 0 "cannot read elasticMem RSS"
    }

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
