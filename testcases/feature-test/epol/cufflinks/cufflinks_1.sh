
#!/usr/bin/bash
# 测试cufflinks的基本用法和各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cufflinks"
    # 准备测试数据
    echo "read1" > ./test.sam
    echo "transcript1" > ./test.gtf
    echo "mask1" > ./mask.gtf
    echo "reference1" > ./reference.fa
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    cufflinks -o ./output -p 2 -G ./test.gtf -g ./test.gtf -M ./mask.gtf -b ./reference.fa -u ./test.sam
    CHECK_RESULT $? 0 0 "cufflinks basic usage failed"

    # 测试不同的参数组合
    cufflinks --frag-len-mean 250 --frag-len-std-dev 100 --max-mle-iterations 10000 --compatible-hits-norm --total-hits-norm --num-frag-count-draws 200 --num-frag-assign-draws 100 --max-frag-multihits 100 --no-effective-length-correction --no-length-correction ./test.sam
    CHECK_RESULT $? 0 0 "cufflinks advanced abundance estimation options failed"

    # 测试高级组装选项
    cufflinks -L CUFF -F 0.15 -j 0.2 -I 500000 -a 0.005 -A 0.1 --min-frags-per-transfrag 15 --overhang-tolerance 10 --max-bundle-length 5000000 --max-bundle-frags 1000000 --min-intron-length 100 --trim-3-avgcov-thresh 15 --trim-3-dropoff-frac 0.2 --max-multiread-fraction 0.5 --overlap-radius 100 ./test.sam
    CHECK_RESULT $? 0 0 "cufflinks advanced assembly options failed"

    # 测试高级参考注释引导组装选项
    cufflinks --no-faux-reads --3-overhang-tolerance 500 --intron-overhang-tolerance 50 ./test.sam
    CHECK_RESULT $? 0 0 "cufflinks advanced reference annotation guided assembly options failed"

    # 测试高级程序行为选项
    cufflinks -v -q --no-update-check ./test.sam
    CHECK_RESULT $? 0 0 "cufflinks advanced program behavior options failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "cufflinks"
    # 清理测试中间产物文件
    rm -rf ./output ./test.sam ./test.gtf ./mask.gtf ./reference.fa
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
