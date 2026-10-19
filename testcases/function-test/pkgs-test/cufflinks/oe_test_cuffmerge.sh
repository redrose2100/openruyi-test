
#!/usr/bin/bash
# 测试cuffmerge命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cufflinks"
    # 准备测试数据
    mkdir -p ./test_data
    touch ./test_data/assembly_GTF_list.txt
    echo "test_data/file1.gtf" > ./test_data/assembly_GTF_list.txt
    echo "test_data/file2.gtf" >> ./test_data/assembly_GTF_list.txt
    touch ./test_data/file1.gtf
    touch ./test_data/file2.gtf
    touch ./test_data/reference.gtf
    touch ./test_data/reference.fasta
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本功能
    cuffmerge ./test_data/assembly_GTF_list.txt
    CHECK_RESULT $? 0 0 "cuffmerge basic function failed"

    # 测试-o参数
    cuffmerge -o ./test_output ./test_data/assembly_GTF_list.txt
    CHECK_RESULT $? 0 0 "cuffmerge -o parameter failed"

    # 测试-g参数
    cuffmerge -g ./test_data/reference.gtf ./test_data/assembly_GTF_list.txt
    CHECK_RESULT $? 0 0 "cuffmerge -g parameter failed"

    # 测试-s参数
    cuffmerge -s ./test_data/reference.fasta ./test_data/assembly_GTF_list.txt
    CHECK_RESULT $? 0 0 "cuffmerge -s parameter failed"

    # 测试--min-isoform-fraction参数
    cuffmerge --min-isoform-fraction 0.1 ./test_data/assembly_GTF_list.txt
    CHECK_RESULT $? 0 0 "cuffmerge --min-isoform-fraction parameter failed"

    # 测试-p参数
    cuffmerge -p 2 ./test_data/assembly_GTF_list.txt
    CHECK_RESULT $? 0 0 "cuffmerge -p parameter failed"

    # 测试--keep-tmp参数
    cuffmerge --keep-tmp ./test_data/assembly_GTF_list.txt
    CHECK_RESULT $? 0 0 "cuffmerge --keep-tmp parameter failed"

    # 测试多个参数组合
    cuffmerge -o ./test_output -g ./test_data/reference.gtf -s ./test_data/reference.fasta --min-isoform-fraction 0.1 -p 2 --keep-tmp ./test_data/assembly_GTF_list.txt
    CHECK_RESULT $? 0 0 "cuffmerge multiple parameters combination failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "cufflinks"
    # 清理测试中间产物文件
    rm -rf ./test_data
    rm -rf ./test_output
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
