
#!/usr/bin/bash
# 本测试用例用于测试dde-dconfig命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "dde-app-services"
    # 准备测试数据
    echo "test_value" > ./test_value_file
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助信息
    dde-dconfig -h
    CHECK_RESULT $? 0 0 "dde-dconfig -h failed"
    dde-dconfig --help
    CHECK_RESULT $? 0 0 "dde-dconfig --help failed"
    dde-dconfig --help-all
    CHECK_RESULT $? 0 0 "dde-dconfig --help-all failed"

    # 测试配置信息列表
    dde-dconfig --list
    CHECK_RESULT $? 0 0 "dde-dconfig --list failed"

    # 测试配置项查询
    dde-dconfig --get -a "org.deepin.dde.control-center" -r "test_resource" -s "test_subpath" -k "test_key"
    CHECK_RESULT $? 0 0 "dde-dconfig --get failed"

    # 测试配置项设置
    dde-dconfig --set -a "org.deepin.dde.control-center" -r "test_resource" -s "test_subpath" -k "test_key" -v "test_value"
    CHECK_RESULT $? 0 0 "dde-dconfig --set failed"

    # 测试配置项重置
    dde-dconfig --reset -a "org.deepin.dde.control-center" -r "test_resource" -s "test_subpath" -k "test_key"
    CHECK_RESULT $? 0 0 "dde-dconfig --reset failed"

    # 测试配置项监视
    dde-dconfig --watch -a "org.deepin.dde.control-center" -r "test_resource" -s "test_subpath" -k "test_key"
    CHECK_RESULT $? 0 0 "dde-dconfig --watch failed"

    # 测试图形界面工具
    dde-dconfig --gui
    CHECK_RESULT $? 0 0 "dde-dconfig --gui failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "dde-app-services"
    # 清理测试中间产物文件
    rm -f ./test_value_file
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
