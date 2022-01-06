#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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

source ${OET_PATH}/conf/mugen.env
source ${OET_PATH}/libs/locallibs/common_lib.sh

export LANG=en_US.UTF-8
export SYS_CONF_PATH=/etc/pkgship
export USER_CONF_PATH=/home
export YUM_PATH=/etc/yum.repos.d
export LOG_PATH=/var/log
export ES_CONF_PATH=/etc/elasticsearch

function MODIFY_CONF() {
    # $1:modified parameter config
    # $2:modified parameter value
    sed -i "s#$(grep $1 ${SYS_CONF_PATH}/conf.yaml)#  $1: $2#g" ${SYS_CONF_PATH}/conf.yaml
}

function INIT_CONF() {
    conf_file=$1
    chown pkgshipuser:pkgshipuser $conf_file
    pkgship init -filepath $conf_file >/dev/null
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

    ps -ef | egrep "elasticsearch" | grep -v grep >/dev/null
    [[ $? -eq 1 ]] && {
        bash ${SYS_CONF_PATH}/auto_install_pkgship_requires.sh elasticsearch
        sleep 2
    }

    ps -ef | egrep "redis" | grep -v grep >/dev/null
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
        wget "https://repo.openeuler.org/openEuler-20.03-LTS/everything/aarch64/repodata/ec190462f84dca9a3efde8dd960a8b76504488b76172dcade988fb7990783f49-primary.sqlite.bz2" -O $openEuler_bin_repo/openEuler-20.03-bin-primary.sqlite.bz2 --no-check-certificate >/dev/null
        wget "https://repo.openeuler.org/openEuler-20.03-LTS/everything/aarch64/repodata/50808141995a36c2c8d805bb1c8afed8bc7891b5b4edf077fc007cf7b05c0f94-filelists.sqlite.bz2" -O $openEuler_bin_repo/openEuler-20.03-bin-filelists.sqlite.bz2 --no-check-certificate >/dev/null

        fedora_src_repo=${SYS_CONF_PATH}/repo/fedora/src/repodata
        fedora_bin_repo=${SYS_CONF_PATH}/repo/fedora/bin/repodata
        mkdir -p $fedora_src_repo
        mkdir -p $fedora_bin_repo
        wget "https://mirrors.huaweicloud.com/fedora/releases/33/Everything/source/tree/repodata/309019b18598555e7f3784481c257c3313840908a34fbcb988679c026fbd7812-primary.sqlite.xz" -O $fedora_src_repo/fedora-33-src-primary.sqlite.xz --no-check-certificate >/dev/null
        wget "https://mirrors.huaweicloud.com/fedora/releases/33/Everything/aarch64/os/repodata/fbf6f0edf597aa13b5d4a065fd984f671a9e57be1c83a1c55a0e9ca37ed19bca-primary.sqlite.xz" -O $fedora_bin_repo/fedora-33-bin-primary.sqlite.xz --no-check-certificate >/dev/null
        wget "https://mirrors.huaweicloud.com/fedora/releases/33/Everything/aarch64/os/repodata/f169f91b65bd08ef1b42ee73cdb17d6eaf36cc192902e4bf8925e00a26de875e-filelists.sqlite.xz" -O $fedora_bin_repo/fedora-33-bin-filelists.sqlite.xz --no-check-certificate >/dev/null

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
    DNF_INSTALL "pkgship wget net-tools diffutils bc"
    bash ${SYS_CONF_PATH}/auto_install_pkgship_requires.sh redis
    bash ${SYS_CONF_PATH}/auto_install_pkgship_requires.sh elasticsearch
}

function REVERT_ENV() {
    ACT_SERVICE stop
    rm -f ${YUM_PATH}/pkgship_yum.repo ${YUM_PATH}/pkgship_elasticsearch.repo ${LOG_PATH}/pkgship/*
    dnf clean all
    dnf makecache
    for i in $(ps -ef | egrep "pkgship|uwsgi|elasticsearch|redis" | grep -Ev "bash|grep" | awk '{print $2}'); do
        kill -9 $i
    done
    DNF_REMOVE
    dnf remove elasticsearch redis -y
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
        pkgship builddep $pkgName -dbs $dbName
    else
        pkgship builddep $pkgName -dbs $dbName -level $level
    fi
}

function QUERY_SELFDEPEND() {
    # option: -b, -s, -w
    pkgName=$1
    dbName=$2
    option=$3
    pkgship selfdepend $pkgName -dbs $dbName $option
}

function QUERY_BEDEPEND() {
    # option: -b, -w, -install, -build
    dbName=$1
    pkgName=$2
    option=$3
    pkgship bedepend $dbName $pkgName $option
}

function GET_RANDOM_PKGNAME() {
    # $1: sqliteName
    sqliteName=$1

    # Get all pkg name
    sqlite3 ../../common_lib/sqlite/$sqliteName "select name from packages;" &>pkg_list.txt
    # Get count

    count=$(cat pkg_list.txt | wc -l)
    # Get a randome in 1~count
    random=$((RANDOM % count + 1))

    printf $(cat pkg_list.txt | head -n $random | tail -n 1)

    rm -f pkg_list.txt
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

    for j in $(seq 0 $concurrency_num); do
        # Get an exec
        read -u3
        {
            $command
            sleep 5
            echo "" >&3

        } &
    done

    # wait
    end_time=$(date +%s)
    exec_time=$(expr $(($end_time - $start_time)))
    echo "Exectue $concurrency_num cmd for times: ""$exec_time"

    # Close
    exec 3>&-
    exec 3<&-
}

function INSTALL_STRESS() {
    wget -P /opt/ https://fossies.org/linux/privat/old/stress-1.0.4.tar.gz
    cd /opt/
    tar -zxvf stress-1.0.4.tar.gz
    cd stress-1.0.4
    ./configure
    make >/dev/null
    make checke >/dev/null
    make installe >/dev/null
    cd -
}

function CLEAN_STRESS() {
    cd /opt/stress-1.0.4
    make cleane >/dev/null
    cd -
    rm -rf /opt/stress-1.0.4.tar.gz /opt/stress-1.0.4
}

function CPU_STRESS() {
    stress --timeout 120s --cpu $(($(grep "processor" /proc/cpuinfo | wc -l) - 2)) &
}

function MEM_STRESS() {
    stress --vm 9 --vm-bytes 3G --vm-hang 120 --timeout 120s &
}

function GET_DNF_BUILDDEPLIST() {
    pkg=$1
    query_level=${2-"1"}
    repo="openEuler-Source"
    type="builddep"
    dep=()
    dep=$(GET_SINGLEDEP $pkg $repo $type)
    dnf builddep $pkg --disablerepo=fedora-Binary --installroot=/home --releasever=1 --assumeno >dnf_builddep_result
    count=1
    [[ $query_level == $count ]] && {
        for ele in ${dep[@]}; do
            find=$(grep $ele dnf_builddep_result)
            [[ $find =~ $ele ]] && {
                echo $ele
            }
        done
        rm -f dnf_builddep_result
        return 0
    }

    repo="openEuler-Binary"
    type="installdep"
    len=${#dep[@]}
    for data1 in ${dep[@]}; do
        level=$(GET_SINGLEDEP $data1 $repo $type)
        dep=(${dep[@]} ${level[@]})
        count=$(($count + 1))
        [[ $query_level == $count ]] && {
            break
        }
    done
    for ele in ${dep[@]}; do
        find=$(grep $ele dnf_builddep_result)
        [[ $find =~ $ele ]] && {
            echo $ele
        }
    done
    rm -f dnf_builddep_result
}

function GET_SINGLEDEP() {
    pkg=$1
    repo=$2
    type=$3
    if [[ $type == "installdep" ]]; then
        level=$(dnf deplist $pkg --repo=$repo | grep provider | cut -d ':' -f 2 | cut -d '-' -f 1 | sort | uniq)
    else
        level=$(dnf deplist $pkg --repo=$repo | grep dependency | cut -d ':' -f 2 | cut -d ' ' -f 2 | sort | uniq)
    fi

    if [[ "$level"x != ""x ]]; then
        echo $level
        return 0
    else
        return 1
    fi
}

function GET_INSTALLDEP() {
    pkgname=$1
    filename=$2
    dbname=${3-""}
    level=${4-""}
    QUERY_INSTALLDEP "$pkgname" "$dbname" "$level" >installdep.txt
    start_line=$(sed -n '/^Source/=' installdep.txt)
    end_line=$(wc -l installdep.txt | awk '{print $1}')
    sed -i "${start_line},${end_line}d" installdep.txt
    grep "openeuler-lts" installdep.txt | grep -v "$pkgname" | awk '{print $1}' | sort | uniq | grep -Ev "openeuler-lts|=" >${filename}
    rm -f installdep.txt
}

function GET_DNF_REPOQUERY() {
    pkg=$1
    repo=${2-"openEuler-Binary"}
    dnf repoquery --whatrequires=$pkg --repo=$repo | cut -d ':' -f 1 >./dnf_repoquery
    [[ -f ./expect_repoquery ]] && {
        rm -f ./expect_repoquery
    }

    touch ./expect_repoquery
    cat ./dnf_repoquery | while read line; do
        echo ${line%-*} >>./expect_repoquery
    done
    SLEEP_WAIT 2
}

function COMPARE_DNF() {
    expect=$1
    actual=$2
    grep -Ev "^$=|[#;]" $expect >./expect_grep_deal
    grep -Ev "^$=|[#;]" $actual >./actual_grep_deal
    while read line; do
        id=$(echo $line | cut -d"^" -f1)
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
    grep -q "\[INFO\] The data comparison is successful, and the generated file" $testlog
    CHECK_RESULT $? 0 0 "Execute compare build command failed."
    compare_dir=$(tail -n 1 $testlog | cut -d '(' -f 2 | cut -d ')' -f 1)
    ls ${compare_dir} | grep -q "compare.csv"
    CHECK_RESULT $? 0 0 "Check file number failed."
    first_row=$(wc -l ${compare_dir}/${dbname}.csv | awk '{print $1}')
    cmp_row=$(wc -l ${compare_dir}/compare.csv | awk '{print $1}')
    if [[ $cmp_row -lt $first_row ]]; then
        CHECK_RESULT 1 0 0 "Check compare file failed."
    fi
    printf ${compare_dir}
}

function COMPARE_BUILD_PKG() {
    type=$1
    compare_dir=$2
    dbname=$3
    pkgname=$4

    # check file info
    if [[ $type -eq "install" ]]; then
        QUERY_INSTALLDEP $pkgname $dbname 1 >expect
    else
        QUERY_BUILDDEP $pkgname $dbname 1 >expect
    fi
    cat expect | grep $dbname | grep -v $dbname | awk '{print $1}' | sort | uniq >expect_cmp
    grep "^$pkgname->" ${compare_dir}/${dbname}.csv | cut -d ',' -f 1 >actual
    CHECK_RESULT $? 0 0 "Get data in ${dbname} failed."
    cat actual | while read line; do
        grep -q "$line" ${compare_dir}/compare.csv
        [[ $? == 1 ]] && {
            CHECK_RESULT 1 0 0 "Check package $dbname in compare.csv failed."
            return 1
        }
    done

    sed -i "s/$pkgname->//g" actual
    cat actual | sort | uniq >actual_cmp
    code=$(COMPARE_DNF actual_cmp expect_cmp)
    CHECK_RESULT $code 0 0 "Check package $pkgname in $dbname failed."
}

path=$(pwd)
if [[ $path =~ "install_service" ]]; then
    return 0
else
    INSTALL_ENV
fi

CHECK_YUM
CHECK_LOCAL_REPO

