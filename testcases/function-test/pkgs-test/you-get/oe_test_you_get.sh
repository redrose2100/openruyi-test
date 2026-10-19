
#!/usr/bin/bash
# 请填写测试用例描述

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "you-get"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "https://example.com/video" > ./test_urls.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等

    # 测试 --version 参数
    you-get --version
    CHECK_RESULT $? 0 0 "you-get --version failed"

    # 测试 --info 参数
    you-get -i https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -i failed"

    # 测试 --url 参数
    you-get -u https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -u failed"

    # 测试 --json 参数
    you-get --json https://example.com/video
    CHECK_RESULT $? 0 0 "you-get --json failed"

    # 测试 --no-merge 参数
    you-get -n https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -n failed"

    # 测试 --force 参数
    you-get -f https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -f failed"

    # 测试 --format 参数
    you-get -F 1080p https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -F failed"

    # 测试 --output-filename 参数
    you-get -O test_output.mp4 https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -O failed"

    # 测试 --output-dir 参数
    you-get -o ./output https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -o failed"

    # 测试 --player 参数
    you-get -p vlc https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -p failed"

    # 测试 --cookies 参数
    you-get -c ./cookies.txt https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -c failed"

    # 测试 --timeout 参数
    you-get -t 30 https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -t failed"

    # 测试 --debug 参数
    you-get -d https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -d failed"

    # 测试 --input-file 参数
    you-get -I ./test_urls.txt
    CHECK_RESULT $? 0 0 "you-get -I failed"

    # 测试 --password 参数
    you-get -P password https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -P failed"

    # 测试 --playlist 参数
    you-get -l https://example.com/playlist
    CHECK_RESULT $? 0 0 "you-get -l failed"

    # 测试 --auto-rename 参数
    you-get -a https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -a failed"

    # 测试 --insecure 参数
    you-get -k https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -k failed"

    # 测试 --first 参数
    you-get --first 1 https://example.com/playlist
    CHECK_RESULT $? 0 0 "you-get --first failed"

    # 测试 --last 参数
    you-get --last 10 https://example.com/playlist
    CHECK_RESULT $? 0 0 "you-get --last failed"

    # 测试 --page-size 参数
    you-get --page-size 50 https://example.com/playlist
    CHECK_RESULT $? 0 0 "you-get --page-size failed"

    # 测试 --http-proxy 参数
    you-get -x 127.0.0.1:8080 https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -x failed"

    # 测试 --extractor-proxy 参数
    you-get -y 127.0.0.1:8080 https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -y failed"

    # 测试 --no-proxy 参数
    you-get --no-proxy https://example.com/video
    CHECK_RESULT $? 0 0 "you-get --no-proxy failed"

    # 测试 --socks-proxy 参数
    you-get -s 127.0.0.1:1080 https://example.com/video
    CHECK_RESULT $? 0 0 "you-get -s failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "you-get"
    # 清理测试中间产物文件
    rm -f ./test_urls.txt ./test_output.mp4 ./output/*
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
