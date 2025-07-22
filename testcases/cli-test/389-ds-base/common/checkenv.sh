#!/bin/bash


# 判断 389-ds-base 版本是否为1.4.3开头, 如果不是skip退出 
checkversion143() {
    DSBASE_VERSION=$(yum info 389-ds-base 2>/dev/null  | grep -E '^Version' | awk '{print $NF}' | head -1)
    REQUIRED_VERSION=1.4.3
    if [[ ! "$DSBASE_VERSION" =~ ^1\.4\.3\. ]]; then
        echo "当前 389-ds-base 版本为 ${DSBASE_VERSION}，不等于${REQUIRED_VERSION}，跳过测试"
        exit 255
    fi
}

