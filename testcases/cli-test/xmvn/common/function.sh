#!/usr/bin/bash
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pretreatment() {
    DNF_INSTALL "xmvn tar"
    cd common/
    tar -xvf common.tar
    cp -rf .m2 /root
    cd my-app
}

function restore() {
    rm -rf result.txt
    cd ../
    rm -rf .m2
    rm -rf my-app
    rm -rf maven-parent-master
    cd /root
    rm -rf .m2
    DNF_REMOVE
}
