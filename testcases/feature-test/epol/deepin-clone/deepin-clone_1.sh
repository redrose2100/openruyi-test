
#!/usr/bin/bash
# 本测试脚本用于测试 deepin-clone 命令的基本用法及其参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "deepin-clone"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch ./sda.dim
    touch ./sdb.dim
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    deepin-clone /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone basic usage failed"
    
    # 测试 --info 参数
    deepin-clone -i /dev/sda
    CHECK_RESULT $? 0 0 "deepin-clone --info failed"
    
    # 测试 --dim-info 参数
    deepin-clone --dim-info ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --dim-info failed"
    
    # 测试 --override 参数
    deepin-clone -O /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --override failed"
    
    # 测试 --buffer-size 参数
    deepin-clone -B 1024 /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --buffer-size failed"
    
    # 测试 --compress-level 参数
    deepin-clone -C 5 /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --compress-level failed"
    
    # 测试 --tui 参数
    deepin-clone --tui /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --tui failed"
    
    # 测试 --to-serial-url 参数
    deepin-clone --to-serial-url ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --to-serial-url failed"
    
    # 测试 --from-serial-url 参数
    deepin-clone --from-serial-url serial://W530B6RT:0
    CHECK_RESULT $? 0 0 "deepin-clone --from-serial-url failed"
    
    # 测试 --no-check-dim 参数
    deepin-clone --no-check-dim /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --no-check-dim failed"
    
    # 测试 --re-checksum 参数
    deepin-clone --re-checksum ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --re-checksum failed"
    
    # 测试 --log-file 参数
    deepin-clone -L ./clone.log /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --log-file failed"
    
    # 测试 --format-log-file 参数
    deepin-clone --format-log-file ./format.log /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --format-log-file failed"
    
    # 测试 --log-backup 参数
    deepin-clone --log-backup ./backup.log /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --log-backup failed"
    
    # 测试 --loop-device 参数
    deepin-clone --loop-device /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --loop-device failed"
    
    # 测试 --debug 参数
    deepin-clone -d 1 /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --debug failed"
    
    # 测试 --fix-boot 参数
    deepin-clone -f /dev/sda1 /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --fix-boot failed"
    
    # 测试 --auto-fix-boot 参数
    deepin-clone --auto-fix-boot /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --auto-fix-boot failed"
    
    # 测试 --write-custom-file 参数
    deepin-clone --write-custom-file dim://example.dim/custom /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --write-custom-file failed"
    
    # 测试 --read-custom-file 参数
    deepin-clone --read-custom-file dim://example.dim/custom /dev/sda ./sda.dim
    CHECK_RESULT $? 0 0 "deepin-clone --read-custom-file failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "deepin-clone"
    # 清理测试中间产物文件
    rm -f ./sda.dim ./sdb.dim ./clone.log ./format.log ./backup.log
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
