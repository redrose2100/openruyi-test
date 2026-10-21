
#!/usr/bin/bash
# 请填写测试用例描述：测试 hbase mapredcp 命令，验证其输出的 CLASSPATH 是否符合预期

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "hbase"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 hbase mapredcp 命令
    hbase mapredcp
    CHECK_RESULT $? 0 0 "hbase mapredcp command failed"
    # 验证输出的 CLASSPATH 是否符合预期
    EXPECTED_OUTPUT="/usr/share/hbase/bin/../lib/shaded-clients/hbase-shaded-mapreduce-2.5.0.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/audience-annotations-0.5.0.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/commons-logging-1.2.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/htrace-core4-4.1.0-incubating.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/jcl-over-slf4j-1.7.33.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/jul-to-slf4j-1.7.33.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/opentelemetry-api-1.15.0.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/opentelemetry-context-1.15.0.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/opentelemetry-semconv-1.15.0-alpha.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/slf4j-api-1.7.33.jar"
    hbase mapredcp | grep "${EXPECTED_OUTPUT}"
    CHECK_RESULT $? 0 0 "hbase mapredcp output does not match expected output"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "hbase"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
