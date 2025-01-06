
#!/usr/bin/bash
# 请填写测试用例描述：测试percona-xtrabackup的备份功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "percona-xtrabackup"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_data
    touch ./test_data/test_file.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    # 基本备份测试
    xtrabackup --backup --target-dir=./backup_test
    CHECK_RESULT $? 0 0 "Backup failed"
    
    # 测试备份到指定目录
    xtrabackup --backup --target-dir=./backup_test_dir
    CHECK_RESULT $? 0 0 "Backup to specific directory failed"
    
    # 测试备份时使用压缩
    xtrabackup --backup --target-dir=./backup_test_compress --compress
    CHECK_RESULT $? 0 0 "Backup with compression failed"
    
    # 测试备份时使用加密
    xtrabackup --backup --target-dir=./backup_test_encrypt --encrypt=AES256 --encrypt-key=123456
    CHECK_RESULT $? 0 0 "Backup with encryption failed"
    
    # 测试备份时使用并行处理
    xtrabackup --backup --target-dir=./backup_test_parallel --parallel=4
    CHECK_RESULT $? 0 0 "Backup with parallel processing failed"
    
    # 测试备份时使用临时目录
    xtrabackup --backup --target-dir=./backup_test_tmpdir --tmpdir=./test_data
    CHECK_RESULT $? 0 0 "Backup with temporary directory failed"
    
    # 测试备份时使用增量备份
    xtrabackup --backup --target-dir=./backup_test_incremental --incremental-lsn=1234567890
    CHECK_RESULT $? 0 0 "Incremental backup failed"
    
    # 测试备份时使用特定的innodb参数
    xtrabackup --backup --target-dir=./backup_test_innodb --innodb-buffer-pool-size=209715200
    CHECK_RESULT $? 0 0 "Backup with specific innodb parameters failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        DNF_REMOVE "percona-xtrabackup"
        # 清理测试中间产物文件
    rm -rf ./backup_test ./backup_test_dir ./backup_test_compress ./backup_test_encrypt ./backup_test_parallel ./backup_test_tmpdir ./backup_test_incremental ./backup_test_innodb ./test_data
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
