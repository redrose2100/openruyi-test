#!/bin/bash


# 判断 python3-pywbem 版本是否为0.12.4, 如果不是skip退出 
checkversion0124() {
    PYWBEM_VERSION=$(yum info python3-pywbem 2>/dev/null  | grep -E '^Version' | awk '{print $NF}' | head -1)
    REQUIRED_VERSION=0.12.4
    if [[ "$PYWBEM_VERSION" != "$REQUIRED_VERSION" ]]; then
        echo "当前仓库 python3-pywbem 版本为 ${PYWBEM_VERSION}，不等于${REQUIRED_VERSION}，跳过测试"
        exit 255
    fi
}

