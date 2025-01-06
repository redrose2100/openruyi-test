
#!/usr/bin/bash
# 请填写测试用例描述：测试 xtrabackup --prepare 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "percona-xtrabackup"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_backup_dir
    touch ./test_backup_dir/xtrabackup_checkpoints
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 xtrabackup --prepare 命令
    xtrabackup --prepare --target-dir=./test_backup_dir
    CHECK_RESULT $? 0 0 "xtrabackup --prepare failed"

    # 测试 xtrabackup --prepare --apply-log-only 命令
    xtrabackup --prepare --apply-log-only --target-dir=./test_backup_dir
    CHECK_RESULT $? 0 0 "xtrabackup --prepare --apply-log-only failed"

    # 测试 xtrabackup --prepare --export 命令
    xtrabackup --prepare --export --target-dir=./test_backup_dir
    CHECK_RESULT $? 0 0 "xtrabackup --prepare --export failed"

    # 测试 xtrabackup --prepare --rebuild-indexes 命令
    xtrabackup --prepare --rebuild-indexes --target-dir=./test_backup_dir
    CHECK_RESULT $? 0 0 "xtrabackup --prepare --rebuild-indexes failed"

    # 测试 xtrabackup --prepare --rebuild-threads 命令
    xtrabackup --prepare --rebuild-threads=2 --target-dir=./test_backup_dir
    CHECK_RESULT $? 0 0 "xtrabackup --prepare --rebuild-threads failed"

    # 测试 xtrabackup --prepare --innodb-checksum-algorithm 命令
    xtrabackup --prepare --innodb-checksum-algorithm=CRC32 --target-dir=./test_backup_dir
    CHECK_RESULT $? 0 0 "xtrabackup --prepare --innodb-checksum-algorithm failed"

    # 测试 xtrabackup --prepare --innodb-log-checksum-algorithm 命令
    xtrabackup --prepare --innodb-log-checksum-algorithm=CRC32 --target-dir=./test_backup_dir
    CHECK_RESULT $? 0 0 "xtrabackup --prepare --innodb-log-checksum-algorithm failed"

    # 测试 xtrabackup --prepare --innodb-undo-directory 命令
    xtrabackup --prepare --innodb-undo-directory=./test_backup_dir --target-dir=./test_backup_dir
    CHECK_RESULT $? 0 0 "xtrabackup --prepare --innodb-undo-directory failed"

    # 测试 xtrabackup --prepare --innodb-undo-tablespaces 命令
    xtrabackup --prepare --innodb-undo-tablespaces=2 --target-dir=./test_backup_dir
    CHECK_RESULT $? 0 0 "xtrabackup --prepare --innodb-undo-tablespaces failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "percona-xtrabackup"
    rm -rf ./test_backup_dir
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
