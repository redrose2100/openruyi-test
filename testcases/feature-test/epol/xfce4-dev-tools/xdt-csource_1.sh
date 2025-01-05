
#!/usr/bin/bash
# 请填写测试用例描述：测试 xdt-csource 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-dev-tools"
    # 准备测试数据
    echo "Test data" > ./test_data.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本功能
    xdt-csource ./test_data.txt
    CHECK_RESULT $? 0 0 "xdt-csource basic function failed"

    # 测试 --name 参数
    xdt-csource --name=test_data ./test_data.txt
    CHECK_RESULT $? 0 0 "xdt-csource --name parameter failed"

    # 测试 --extern 参数
    xdt-csource --extern ./test_data.txt
    CHECK_RESULT $? 0 0 "xdt-csource --extern parameter failed"

    # 测试 --static 参数
    xdt-csource --static ./test_data.txt
    CHECK_RESULT $? 0 0 "xdt-csource --static parameter failed"

    # 测试 --output 参数
    xdt-csource --output=./output.c ./test_data.txt
    CHECK_RESULT $? 0 0 "xdt-csource --output parameter failed"

    # 测试 --build-list 参数
    xdt-csource --build-list test_data ./test_data.txt
    CHECK_RESULT $? 0 0 "xdt-csource --build-list parameter failed"

    # 测试 --strip-comments 参数
    echo "<xml><node>Test data</node></xml>" > ./test_xml.xml
    xdt-csource --strip-comments ./test_xml.xml
    CHECK_RESULT $? 0 0 "xdt-csource --strip-comments parameter failed"

    # 测试 --strip-content 参数
    xdt-csource --strip-content ./test_xml.xml
    CHECK_RESULT $? 0 0 "xdt-csource --strip-content parameter failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "xfce4-dev-tools"
    # 清理测试中间产物文件
    rm -f ./test_data.txt ./output.c ./test_xml.xml
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
