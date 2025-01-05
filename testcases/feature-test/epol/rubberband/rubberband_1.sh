
#!/usr/bin/bash
# 请填写测试用例描述：测试rubberband命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "rubberband"
    # 准备测试数据
    touch "./test_input.wav"
    touch "./test_output.wav"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本功能
    rubberband -t2 "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband -t2 failed"
    
    # 测试不同的时间拉伸参数
    rubberband -T0.5 "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband -T0.5 failed"
    
    rubberband -T1.5:2 "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband -T1.5:2 failed"
    
    rubberband -D10 "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband -D10 failed"
    
    # 测试不同的音高参数
    rubberband -p2 "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband -p2 failed"
    
    rubberband -f1.5 "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband -f1.5 failed"
    
    # 测试crispness参数
    rubberband -c0 "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband -c0 failed"
    
    rubberband -c3 "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband -c3 failed"
    
    rubberband -c6 "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband -c6 failed"
    
    # 测试其他选项
    rubberband -L "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband -L failed"
    
    rubberband --no-threads "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband --no-threads failed"
    
    rubberband --window-short "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband --window-short failed"
    
    rubberband --detector-soft "./test_input.wav" "./test_output.wav"
    CHECK_RESULT $? 0 0 "rubberband --detector-soft failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "rubberband"
    # 清理测试中间产物文件
    rm -f "./test_input.wav" "./test_output.wav"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
