#!/bin/bash

version_check(){
	PODMAN_VERSION=$(yum info podman 2>/dev/null  | grep -E '^Version' | awk '{print $NF}' | head -1)

	if [[ "$PODMAN_VERSION" != "0.10.1" ]]; then
    		echo "当前仓库podman版本为 ${PODMAN_VERSION}，不等于0.10.1，跳过测试"
    		exit 255
	fi

}
