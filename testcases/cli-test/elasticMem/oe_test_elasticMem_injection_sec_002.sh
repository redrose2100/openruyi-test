#!/usr/bin/bash
# #############################################
# @Desc    : test_elasticMem_injection_sec.002 - 路径穿越被阻止
# #############################################

source "../common/common_lib.sh"
source "./common/em_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    em_backup_config
    em_stop_service
    # 使用 md5sum 记录原始文件内容，避免元数据干扰
    md5sum /etc/passwd > /tmp/passwd.md5.orig
    cp /etc/passwd /etc/passwd.em_backup
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    # 路径穿越
    cat > "$CONFIG_PATH" << EOF
policy = paral
log_level = info
log_file = ../../../etc/passwd
whitelist = []
comm_whitelist = []
nr_cpus=1
memory_migration = true
sample_interval = 100
sample_count = 10
EOF
    systemctl start $SERVICE_NAME 2>/dev/null
    sleep 3

    # /etc/passwd 应未被修改（使用 md5sum 比较内容，忽略元数据）
    md5sum /etc/passwd > /tmp/passwd.md5.after
    diff /tmp/passwd.md5.orig /tmp/passwd.md5.after > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "path traversal: /etc/passwd was modified!"

    LOG_INFO "Finish test!"
}

function post_test() {
    em_kill_bg
    LOG_INFO "start environment cleanup."
    em_stop_service
    # 如果被修改，从备份恢复
    if ! diff /tmp/passwd.md5.orig /tmp/passwd.md5.after >/dev/null 2>&1; then
        mv /etc/passwd.em_backup /etc/passwd 2>/dev/null
    else
        rm -f /etc/passwd.em_backup
    fi
    rm -f /tmp/passwd.md5.orig /tmp/passwd.md5.after
    em_restore_config
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
