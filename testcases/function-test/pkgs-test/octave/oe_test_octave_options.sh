
#!/usr/bin/bash
# 本测试脚本用于测试octave命令的各种参数组合和行为

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "octave"
    # 准备测试数据
    echo "disp('Hello, World!');" > ./test_script.m
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --version 参数
    octave --version
    CHECK_RESULT $? 0 0 "octave --version failed"

    # 测试 --help 参数
    octave --help
    CHECK_RESULT $? 0 0 "octave --help failed"

    # 测试 --eval 参数
    octave --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --eval failed"

    # 测试 --no-init-file 参数
    octave --no-init-file --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --no-init-file --eval failed"

    # 测试 --no-init-path 参数
    octave --no-init-path --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --no-init-path --eval failed"

    # 测试 --no-history 参数
    octave --no-history --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --no-history --eval failed"

    # 测试 --no-line-editing 参数
    octave --no-line-editing --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --no-line-editing --eval failed"

    # 测试 --no-gui 参数
    octave --no-gui --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --no-gui --eval failed"

    # 测试 --no-window-system 参数
    octave --no-window-system --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --no-window-system --eval failed"

    # 测试 --persist 参数
    octave --eval "disp('Hello, World!')" --persist
    CHECK_RESULT $? 0 0 "octave --eval --persist failed"

    # 测试 --silent 参数
    octave --silent --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --silent --eval failed"

    # 测试 --traditional 参数
    octave --traditional --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --traditional --eval failed"

    # 测试 --path 参数
    octave --path ./ --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --path --eval failed"

    # 测试 --image-path 参数
    octave --image-path ./ --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --image-path --eval failed"

    # 测试 --exec-path 参数
    octave --exec-path ./ --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --exec-path --eval failed"

    # 测试 --info-file 参数
    octave --info-file ./test_script.m --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --info-file --eval failed"

    # 测试 --info-program 参数
    octave --info-program ./test_script.m --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --info-program --eval failed"

    # 测试 --doc-cache-file 参数
    octave --doc-cache-file ./test_script.m --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --doc-cache-file --eval failed"

    # 测试 --built-in-docstrings-file 参数
    octave --built-in-docstrings-file ./test_script.m --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --built-in-docstrings-file --eval failed"

    # 测试 --texi-macros-file 参数
    octave --texi-macros-file ./test_script.m --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --texi-macros-file --eval failed"

    # 测试 --debug 参数
    octave --debug --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --debug --eval failed"

    # 测试 --debug-jit 参数
    octave --debug-jit --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --debug-jit --eval failed"

    # 测试 --jit-compiler 参数
    octave --jit-compiler --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --jit-compiler --eval failed"

    # 测试 --line-editing 参数
    octave --line-editing --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --line-editing --eval failed"

    # 测试 --interactive 参数
    octave --interactive --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --interactive --eval failed"

    # 测试 --gui 参数
    octave --gui --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --gui --eval failed"

    # 测试 --norc 参数
    octave --norc --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --norc --eval failed"

    # 测试 --no-site-file 参数
    octave --no-site-file --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --no-site-file --eval failed"

    # 测试 --echo-commands 参数
    octave --echo-commands --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --echo-commands --eval failed"

    # 测试 --verbose 参数
    octave --verbose --eval "disp('Hello, World!')"
    CHECK_RESULT $? 0 0 "octave --verbose --eval failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "octave"
    # 清理测试中间产物文件
    rm -f ./test_script.m
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
