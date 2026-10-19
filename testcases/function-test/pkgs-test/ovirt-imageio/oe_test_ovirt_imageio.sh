
#!/usr/bin/bash
# 本测试用例用于测试ovirt-imageio命令的参数功能，包括-h, --help, -c CONF_DIR, --conf-dir CONF_DIR, --show-config等参数。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-imageio"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./config_dir
    touch ./config_dir/daemon.conf
    touch ./config_dir/logger.conf
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试-h参数
    ovirt-imageio -h
    CHECK_RESULT $? 0 0 "failed to run ovirt-imageio -h"
    # 测试--help参数
    ovirt-imageio --help
    CHECK_RESULT $? 0 0 "failed to run ovirt-imageio --help"
    # 测试-c参数
    ovirt-imageio -c ./config_dir
    CHECK_RESULT $? 0 0 "failed to run ovirt-imageio -c ./config_dir"
    # 测试--conf-dir参数
    ovirt-imageio --conf-dir ./config_dir
    CHECK_RESULT $? 0 0 "failed to run ovirt-imageio --conf-dir ./config_dir"
    # 测试--show-config参数
    ovirt-imageio --show-config
    CHECK_RESULT $? 0 0 "failed to run ovirt-imageio --show-config"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "ovirt-imageio"
    # 清理测试中间产物文件
    rm -rf ./config_dir
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
