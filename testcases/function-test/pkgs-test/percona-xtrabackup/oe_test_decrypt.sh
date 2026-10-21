
#!/usr/bin/bash
# 请填写测试用例描述：测试innobackupex的--decrypt参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "percona-xtrabackup"
    # 准备测试数据
    mkdir -p ./test_backup_dir
    touch ./test_backup_dir/file.qbcrypt
    touch ./test_backup_dir/encryption-key-file.key
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试innobackupex --decrypt参数
    innobackupex --decrypt=aes --encrypt-key-file=./test_backup_dir/encryption-key-file.key ./test_backup_dir
    CHECK_RESULT $? 0 0 "innobackupex --decrypt failed"
    # 测试innobackupex --decrypt参数的其他加密算法
    innobackupex --decrypt=twofish --encrypt-key-file=./test_backup_dir/encryption-key-file.key ./test_backup_dir
    CHECK_RESULT $? 0 0 "innobackupex --decrypt with twofish failed"
    # 测试innobackupex --decrypt参数的其他加密算法
    innobackupex --decrypt=camellia --encrypt-key-file=./test_backup_dir/encryption-key-file.key ./test_backup_dir
    CHECK_RESULT $? 0 0 "innobackupex --decrypt with camellia failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "percona-xtrabackup"
    # 清理测试中间产物文件
    rm -rf ./test_backup_dir
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
