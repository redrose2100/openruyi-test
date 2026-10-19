
#!/usr/bin/bash
# 本测试脚本用于验证 hbase classpath 命令的输出是否符合预期

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
    # 获取 hbase classpath 的输出
    hbase classpath
    CHECK_RESULT $? 0 0 "hbase classpath command failed"
    # 验证输出是否包含预期的路径
    EXPECTED_CLASSPATH="/usr/share/hbase/bin/../conf:/usr/lib/jvm/jre/lib/tools.jar:/usr/share/hbase/bin/..:/usr/share/hbase/bin/../lib/shaded-clients/hbase-shaded-client-2.5.0.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/audience-annotations-0.5.0.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/commons-logging-1.2.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/htrace-core4-4.1.0-incubating.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/jcl-over-slf4j-1.7.33.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/jul-to-slf4j-1.7.33.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/opentelemetry-api-1.15.0.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/opentelemetry-context-1.15.0.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/opentelemetry-semconv-1.15.0-alpha.jar:/usr/share/hbase/bin/../lib/client-facing-thirdparty/slf4j-api-1.7.33.jar"
    hbase classpath | grep "${EXPECTED_CLASSPATH}"
    CHECK_RESULT $? 0 0 "hbase classpath output does not match expected output"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "hbase"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
