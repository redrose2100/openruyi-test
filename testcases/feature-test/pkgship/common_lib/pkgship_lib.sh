#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   Li, Meiting
#@Contact       :   244349477@qq.com
#@Date          :   2020-08-01
#@License       :   Mulan PSL v2
#@Desc          :   Public function
#####################################
# shellcheck disable=SC1091,SC2086,SC2012
source "${OET_PATH}"/conf/mugen.env
source "${OET_PATH}"/libs/locallibs/common_lib.sh

export LANG=en_US.UTF-8
export SYS_CONF_PATH=/etc/pkgship
export USER_CONF_PATH=/home
export YUM_PATH=/etc/yum.repos.d
export LOG_PATH=/var/log
export ES_CONF_PATH=/etc/elasticsearch

function MODIFY_CONF() {
    # $1:modified parameter config
    # $2:modified parameter value
    sed -i "s#$(grep "$1" ${SYS_CONF_PATH}/conf.yaml)#  $1: $2#g" ${SYS_CONF_PATH}/conf.yaml
}

function INIT_CONF() {
    conf_file=$1
    chown pkgshipuser:pkgshipuser "$conf_file"
    pkgship init -filepath "$conf_file" >/dev/null
    SLEEP_WAIT 20
}

function MODIFY_INI() {
    # Modify conf file
    # $1: Modified conf
    # $2: Modified value
    sed -i "/^$1/c $1=$2" ${SYS_CONF_PATH}/package.ini
}

function ACT_SERVICE() {
    # $1: The action of service
    action=${1-"start"}
    cur_system=$(cat /proc/1/cgroup)
    cur_user=$(whoami)

    pgrep -f "elasticsearch" >/dev/null
    [[ $? -eq 1 ]] && {
        bash ${SYS_CONF_PATH}/auto_install_pkgship_requires.sh elasticsearch
        sleep 2
    }

    pgrep -f "redis" >/dev/null
    [[ $? -eq 1 ]] && {
        bash ${SYS_CONF_PATH}/auto_install_pkgship_requires.sh redis
        sleep 2
    }

    if [[ $cur_system =~ "docker" ]]; then
        if [[ $action == "start" ]]; then
            pkgshipd start
        elif [[ $action == "restart" ]]; then
            pkgshipd restart
        else
            pkgshipd stop
        fi
    else
        if [[ $action == "start" ]]; then
            if [[ $cur_user == "root" ]]; then
                systemctl start pkgship
            else
                pkgshipd start
            fi
        elif [[ $action == "restart" ]]; then
            if [[ $cur_user == "root" ]]; then
                systemctl restart pkgship
            else
                pkgshipd restart
            fi
        else
            if [[ $cur_user == "root" ]]; then
                systemctl stop pkgship
            else
                pkgshipd stop
            fi
        fi
    fi

    sleep 2
}

function CHECK_LOCAL_REPO() {
    if [[ -e ${SYS_CONF_PATH}/repo ]]; then
        return 0
    else
        mkdir ${SYS_CONF_PATH}/repo
        openEuler_src_repo=${SYS_CONF_PATH}/repo/openEuler-20.03/src/repodata
        openEuler_bin_repo=${SYS_CONF_PATH}/repo/openEuler-20.03/bin/repodata
        mkdir -p $openEuler_src_repo
        mkdir -p $openEuler_bin_repo
        wget "https://repo.openeuler.org/openEuler-20.03-LTS/source/repodata/c4a181f9986fc40bf068b601c828876789110236d9652ac0c49e3eae3a20e8e0-primary.sqlite.bz2" -O $openEuler_src_repo/openEuler-20.03-src-primary.sqlite.bz2 --no-check-certificate >/dev/null
        if [ "${NODE1_FRAME}" = "aarch64" ]; then
            wget "https://repo.openeuler.org/openEuler-20.03-LTS/everything/aarch64/repodata/ec190462f84dca9a3efde8dd960a8b76504488b76172dcade988fb7990783f49-primary.sqlite.bz2" -O $openEuler_bin_repo/openEuler-20.03-bin-primary.sqlite.bz2 --no-check-certificate >/dev/null
            wget "https://repo.openeuler.org/openEuler-20.03-LTS/everything/aarch64/repodata/50808141995a36c2c8d805bb1c8afed8bc7891b5b4edf077fc007cf7b05c0f94-filelists.sqlite.bz2" -O $openEuler_bin_repo/openEuler-20.03-bin-filelists.sqlite.bz2 --no-check-certificate >/dev/null
        else
            wget "https://repo.openeuler.org/openEuler-20.03-LTS/everything/x86_64/repodata/e2a6b9bfb310fddc97b0138360d801d498f61339b069442828c05a6d6752de9e-primary.sqlite.bz2" -O $openEuler_bin_repo/openEuler-20.03-bin-primary.sqlite.bz2 --no-check-certificate >/dev/null
            wget "https://repo.openeuler.org/openEuler-20.03-LTS/everything/x86_64/repodata/abac5a3ac968db4abe6138c7da425407c5a10ecd9970c150cc0e65a674e9066e-filelists.sqlite.bz2" -O $openEuler_bin_repo/openEuler-20.03-bin-filelists.sqlite.bz2 --no-check-certificate >/dev/null    
        fi
        fedora_src_repo=${SYS_CONF_PATH}/repo/fedora/src/repodata
        fedora_bin_repo=${SYS_CONF_PATH}/repo/fedora/bin/repodata
        mkdir -p $fedora_src_repo
        mkdir -p $fedora_bin_repo
        wget "https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/34/Everything/source/tree/repodata/747637dc211617ac6a0c630f63e109fd834a62cea678fbe953a1fe036cddfe49-primary.sqlite.xz" -O $fedora_src_repo/fedora-34-src-primary.sqlite.xz --no-check-certificate >/dev/null
        if [ "${NODE1_FRAME}" = "aarch64" ]; then
            wget "https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/34/Everything/aarch64/os/repodata/2e165e1e73f87a2c52c4e61ff9fc9f9da5a4cc1e37ee4d5ad7f4d5640b744a1f-primary.sqlite.xz" -O $fedora_bin_repo/fedora-34-bin-primary.sqlite.xz --no-check-certificate >/dev/null
            wget "https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/34/Everything/aarch64/os/repodata/8abb99b754848d81e12d2cdd28b33903b127e8d3181b1d9c1f580a61629f05a1-filelists.sqlite.xz" -O $fedora_bin_repo/fedora-34-bin-filelists.sqlite.xz --no-check-certificate >/dev/null
        else
            wget "https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/34/Everything/x86_64/os/repodata/8c2b9b7733384c2442750134bfcb0aa9fb8f9e87572d7628ef4cda0c6a2600eb-primary.sqlite.xz" -O $fedora_bin_repo/fedora-34-bin-primary.sqlite.xz --no-check-certificate >/dev/null
            wget "https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/34/Everything/x86_64/os/repodata/10a1aa1989ca58d1688b65d4584d326a67cd5b1b8f39e162c209f7fd31e1eb29-filelists.sqlite.xz" -O $fedora_bin_repo/fedora-34-bin-filelists.sqlite.xz --no-check-certificate >/dev/null  
        fi   
        
        cp -r ../../common_lib/repo/data1 ${SYS_CONF_PATH}/repo
    fi

}

function CHECK_YUM() {
    # Check local yum repo
    file=${YUM_PATH}/pkgship_yum.repo
    if [[ ! -f $file ]]; then
        cp -p ../../common_lib/pkgship_yum.repo ${YUM_PATH}/pkgship_yum.repo
        dnf clean all
        dnf makecache
    fi

}

function INSTALL_ENV() {
    pgrep -f -a "dnf|yum" | grep -Ev "grep|bash" | awk '{print $1}' | xargs kill -9
    dnf remove elasticsearch redis pkgship wget net-tools diffutils tar -y
    dnf clean all
    DNF_INSTALL "pkgship wget net-tools diffutils tar"
    SLEEP_WAIT 20
    bash ${SYS_CONF_PATH}/auto_install_pkgship_requires.sh redis
    bash ${SYS_CONF_PATH}/auto_install_pkgship_requires.sh elasticsearch
}

function REVERT_ENV() {
    ACT_SERVICE stop
    rm -rf ${YUM_PATH}/pkgship_yum.repo ${YUM_PATH}/pkgship_elasticsearch.repo ${LOG_PATH}/pkgship/*
    SLEEP_WAIT 10
    for i in $(pgrep -f -a "pkgship|uwsgi|elasticsearch|redis|dnf" | grep -Ev "nohup|mugen.sh|oe_test|grep" | awk '{print $1}'); do
        kill -9 "$i"
    done
    dnf clean all
    dnf makecache
    SLEEP_WAIT 10
    DNF_REMOVE "$@"
    rm -rf ${SYS_CONF_PATH}
}

function QUERY_LIST() {
    # option: -s
    dbName=$1
    option=$2
    pkgship list $dbName $option
}

function QUERY_PKGINFO() {
    # option: -s
    pkgName=$1
    dbName=$2
    option=$3
    pkgship pkginfo $pkgName $dbName $option
}

function QUERY_INSTALLDEP() {
    pkgName=$1
    dbName=$2
    level=$3
    if [[ $level == "" ]]; then
        pkgship installdep $pkgName -dbs $dbName
    else
        pkgship installdep $pkgName -dbs $dbName -level $level
    fi
}

function QUERY_BUILDDEP() {
    pkgName=$1
    dbName=$2
    level=$3
    if [[ $level == "" ]]; then
        pkgship builddep "$pkgName" -dbs "$dbName"
    else
        pkgship builddep "$pkgName" -dbs "$dbName" -level "$level"
    fi
}

function QUERY_SELFDEPEND() {
    # option: -b, -s, -w
    pkgName=$1
    dbName=$2
    option=$3
    pkgship selfdepend "$pkgName" -dbs "$dbName" "$option"
}

function QUERY_BEDEPEND() {
    # option: -b, -w, -install, -build
    dbName=$1
    pkgName=$2
    option=$3
    pkgship bedepend "$dbName" "$pkgName" "$option"
}

function GET_RANDOM_PKGNAME() {
    sqliteName=$1
    cp ../../common_lib/sqlite/$sqliteName ./
    count=$(wc -l $sqliteName | awk '{print $1}')
    random=$((RANDOM % count + 1))
    pkg=$(head -n $random $sqliteName | tail -n 1)
    echo "$pkg"
    rm -rf $sqliteName
}

function CONCURRENCY_THREAD() {
    # $1: execution cmd
    # $2: concurrency time, default is 100
    command=$1
    concurrency_num=${2-"100"}
    start_time=$(date +%s)

    # Create fifo and exec
    [ -e /tmp/fd1 ] || mkfifo /tmp/fd1
    exec 3<>/tmp/fd1
    rm -rf /tmp/fd1
    for ((i = 0; i < 9; i++)); do
        # Put an exec
        echo ""
    done >&3

    for j in $(seq 0 "$concurrency_num"); do
        # Get an exec
        echo "$j"
        read -r -u3
        {
            $command
            sleep 5
            echo "" >&3

        } &
    done

    # wait
    end_time=$(date +%s)
    exec_time=$((end_time-start_time))

    echo "Exectue $concurrency_num cmd for times: ""$exec_time"

    # Close
    exec 3>&-
    exec 3<&-
}

function INSTALL_STRESS() {
    wget -P /opt/ https://fossies.org/linux/privat/old
    stress="$(grep '"stress-*' /opt/old | awk -F '"' '{print $4}')"
    wget -P /opt/ https://fossies.org/linux/privat/old/$stress
    tar -zxvf /opt/$stress -C /opt/
    stress_dir=$(echo $stress | awk -F '.tar' '{print $1}')
    cd /opt/$stress_dir || exit
    ./configure
    make >/dev/null
    make check >/dev/null
    make install >/dev/null
    cd - || exit
}

function CLEAN_STRESS() {
    cd /opt/$stress_dir || exit
    make clean >/dev/null
    cd - || exit
    rm -rf /opt/stress-* /opt/old
}

function CPU_STRESS() {
    stress --timeout 120s --cpu $(($(grep -c "processor" /proc/cpuinfo) - 2)) &
}

function MEM_STRESS() {
    stress --vm 9 --vm-bytes 3G --vm-hang 120 --timeout 120s &
}

function GET_DNF_BUILDDEPLIST() {
    pkg=$1
    query_level=${2-"1"}
    repo="openEuler-Source"
    type="builddep"
    dep=$(GET_SINGLEDEP "$pkg" "$repo" "$type")
    dnf builddep "$pkg" --disablerepo=fedora-Binary --installroot=/home --releasever=1 --assumeno >dnf_builddep_result
    count=1
    [[ "$query_level" == "$count" ]] && {
        for ele in "${dep[@]}"; do
            find=$(grep "$ele" dnf_builddep_result)
            [[ $find =~ $ele ]] && {
                echo "$ele"
            }
        done
        rm -rf dnf_builddep_result
        return 0
    }

    repo="openEuler-Binary"
    type="installdep"
    for data1 in "${dep[@]}"; do
        level=$(GET_SINGLEDEP "$data1" "$repo" "$type")
        dep=("${dep[@]}" "${level[@]}")
        count=$(("$count" + 1))
        [[ "$query_level" == "$count" ]] && {
            break
        }
    done
    for ele in "${dep[@]}"; do
        find=$(grep "$ele" dnf_builddep_result)
        [[ $find =~ $ele ]] && {
            echo "$ele"
        }
    done
    rm -rf dnf_builddep_result
}

function GET_SINGLEDEP() {
    pkg=$1
    repo=$2
    type=$3
    if [[ $type == "installdep" ]]; then
        level=$(dnf deplist "$pkg" --repo="$repo" | grep provider | cut -d ':' -f 2 | cut -d '-' -f 1 | sort | uniq)
    else
        level=$(dnf deplist "$pkg" --repo="$repo" | grep dependency | cut -d ':' -f 2 | cut -d ' ' -f 2 | sort | uniq)
    fi

    if [[ "$level"x != ""x ]]; then
        echo "$level"
        return 0
    else
        return 1
    fi
}

# input parameter to get result
function send_command() {
    para=$1
    QUERY_LIST $para | grep "Request parameter error"
    CHECK_RESULT $? 0 0 "The message is error when para=$para."
    
    QUERY_LIST $para -s | grep "Request parameter error"
    CHECK_RESULT $? 0 0 "The message is error when para=$para with -s."
}

function GET_INSTALLDEP() {
    pkgname=$1
    filename=$2
    dbname=${3-""}
    level=${4-""}
    QUERY_INSTALLDEP $pkgname $dbname $level >installdep.txt
    start_line=$(sed -n '/^Source/=' installdep.txt)
    end_line=$(wc -l installdep.txt | awk '{print $1}')
    sed -i "${start_line},${end_line}d" installdep.txt
    grep "openeuler-lts" installdep.txt | grep -v $pkgname | awk '{print $1}' | sort | uniq | grep -Ev "openeuler-lts|=" >${filename}
    rm -rf installdep.txt
}

function check_file_access() {
    file_name=$1
    expect_owner=$2
    expect_group=$3
    expect_code=$4
    ls -ld $file_name | awk '{print $3}' | grep $expect_owner
    CHECK_RESULT $? 0 0 "Check owner for $file_name failed."
    ls -ld $file_name | awk '{print $4}' | grep $expect_group
    CHECK_RESULT $? 0 0 "Check group for $file_name failed."
    echo "obase=8;ibase=2;$(ls -ld $file_name | awk '{print $1}' | sed 's/^[a-zA-Z-]//' | tr 'x|r|w' '1' | tr '-' '0')" | bc | grep $expect_code
    CHECK_RESULT $? 0 0 "Check access for $file_name failed."
}

function GET_DNF_REPOQUERY() {
    pkg=$1
    repo=${2-"openEuler-Binary"}
    dnf repoquery --whatrequires="$pkg" --repo="$repo" | cut -d ':' -f 1 >./dnf_repoquery
    [[ -f ./expect_repoquery ]] && {
        rm -rf ./expect_repoquery
    }

    touch ./expect_repoquery
    while read -r line; do
        echo "${line%-*}" >>./expect_repoquery
    done < ./dnf_repoquery
    SLEEP_WAIT 2
}

function COMPARE_DNF() {
    expect=$1
    actual=$2
    grep -Ev "^$=|[#;]" "$expect" >./expect_grep_deal
    grep -Ev "^$=|[#;]" "$actual" >./actual_grep_deal
    while read -r line; do
        id=$(echo "$line" | cut -d"^" -f1)
        grep -q "$id" ./expect_grep_deal
        [[ $? == 1 ]] && {
            printf 1
            rm -rf ./actual_grep_deal ./expect_grep_deal
            return 0
        }
    done <actual_grep_deal
    rm -rf ./actual_grep_deal ./expect_grep_deal
    printf 0
}

function CHECK_COMPARE() {
    testlog=$1
    dbname=$2
    grep -q "\[INFO\] The data comparison is successful, and the generated file" "$testlog"
    CHECK_RESULT $? 0 0 "Execute compare build command failed."
    compare_dir=$(tail -n 1 "$testlog" | cut -d '(' -f 2 | cut -d ')' -f 1)
    test -e "${compare_dir}"/compare.csv
    CHECK_RESULT $? 0 0 "Check file number failed."
    first_row=$(wc -l "${compare_dir}"/"${dbname}".csv | awk '{print $1}')
    cmp_row=$(wc -l "${compare_dir}"/compare.csv | awk '{print $1}')
    if [[ $cmp_row -lt $first_row ]]; then
        CHECK_RESULT 1 0 0 "Check compare file failed."
    fi
    echo "${compare_dir}"
}

function COMPARE_BUILD_PKG() {
    type=$1
    compare_dir=$2
    dbname=$3
    pkgname=$4

    # check file info
    str="install"
    if [ "$type" = "$str" ]; then
        QUERY_INSTALLDEP "$pkgname" "$dbname" 1 >expect
    else
        QUERY_BUILDDEP "$pkgname" "$dbname" 1 >expect
    fi
    grep  "$dbname" expect | awk '{print $1}' | grep -v "$dbname" | grep -v "$pkgname"| sort | uniq >expect_cmp
    grep "^$pkgname->" "${compare_dir}"/"${dbname}".csv | cut -d ',' -f 1 >actual
    CHECK_RESULT $? 0 0 "Get data in ${dbname} failed."
    while read -r line; do
        grep -q "$line" "${compare_dir}"/compare.csv
        [[ $? == 1 ]] && {
            CHECK_RESULT 1 0 0 "Check package $dbname in compare.csv failed."
            return 1
        }
    done < ./actual

    sed -i "s/$pkgname->//g" actual
    sort actual | uniq >actual_cmp
    code=$(COMPARE_DNF actual_cmp expect_cmp)
    CHECK_RESULT "$code" 0 0 "Check package $pkgname in $dbname failed."
}

if [[ ${NODE1_FRAME} == "riscv64" ]]; then
    LOG_WARN "Testing cannot be performed if NODE1_FRAME is riscv64"
    exit 255
fi

path=$(pwd)
if [[ $path =~ "install_service" ]]; then
    echo "no install"
else
    INSTALL_ENV
fi

CHECK_YUM
CHECK_LOCAL_REPO
