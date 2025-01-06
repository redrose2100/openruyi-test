
#!/usr/bin/bash
# 测试xfburn命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfburn"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfburn --help
    CHECK_RESULT $? 0 0 "xfburn --help failed"
    
    # 测试版本选项
    xfburn --version
    CHECK_RESULT $? 0 0 "xfburn --version failed"
    
    # 测试打开烧录图像对话框
    xfburn --burn-image
    CHECK_RESULT $? 0 0 "xfburn --burn-image failed"
    
    # 测试打开空白光盘对话框
    xfburn --blank
    CHECK_RESULT $? 0 0 "xfburn --blank failed"
    
    # 测试数据组合
    xfburn --data-composition
    CHECK_RESULT $? 0 0 "xfburn --data-composition failed"
    
    # 测试音频组合
    xfburn --audio-composition
    CHECK_RESULT $? 0 0 "xfburn --audio-composition failed"
    
    # 测试选择转码器
    xfburn --transcoder=list
    CHECK_RESULT $? 0 0 "xfburn --transcoder=list failed"
    
    # 测试指定目录
    xfburn --directory=./
    CHECK_RESULT $? 0 0 "xfburn --directory=./ failed"
    
    # 测试显示主程序
    xfburn --main
    CHECK_RESULT $? 0 0 "xfburn --main failed"
    
    # 测试显示主程序并打开烧录图像对话框
    xfburn --main --burn-image
    CHECK_RESULT $? 0 0 "xfburn --main --burn-image failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "xfburn"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
