#!/usr/bin/bash
# shellcheck disable=SC2012,SC2086

MANIFEST_MAP="${OET_PATH}/testcases/embedded-test/common_libs/manifest_map.json"

GIT_CLONE_MAX_RETRY=3
GIT_CLONE_RETRY_INTERVAL=10

function git_clone_with_retry() {
    local retry_count=0
    local clone_args="$@"
    local target_dir=""
    for arg in "$@"; do
        if [[ ! "$arg" =~ ^- ]]; then
            target_dir="$arg"
        fi
    done
    while [ $retry_count -lt $GIT_CLONE_MAX_RETRY ]; do
        if [ $retry_count -gt 0 ]; then
            echo "WARN: git clone retry #$retry_count after $GIT_CLONE_RETRY_INTERVAL seconds..."
            sleep $GIT_CLONE_RETRY_INTERVAL
            if [ -n "$target_dir" ] && [ -e "$target_dir" ]; then
                rm -rf "$target_dir"
            fi
        fi
        if git clone $clone_args; then
            if [ $retry_count -gt 0 ]; then
                echo "INFO: git clone succeeded on retry #$retry_count"
            fi
            return 0
        fi
        retry_count=$((retry_count + 1))
    done
    echo "ERROR: git clone failed after $GIT_CLONE_MAX_RETRY attempts: git clone $clone_args"
    return 1
}

function downloadFromGitee() {
    downloadName=$1
    downloadBranch=$2
    if [ -z "${downloadBranch}" ]; then
        downloadBranch="openEuler-24.03-LTS"
    fi
    giteeName="src-openeuler"
    if [[ "$3"x != ""x ]]; then
        giteeName=$3
    fi

    if [[ -d "tmp_download/$1" ]]; then
        echo "INFO: $1 source already exists, skip clone"
        return 0
    fi
    git_clone_with_retry -b "${downloadBranch}" "https://atomgit.com/${giteeName}/${downloadName}.git" --depth=1 -v "tmp_download/$1"
}

function downloadFromManifest() {
    packageName=$1
    if [[ ! -f "${MANIFEST_MAP}" ]]; then
        echo "manifest_map.json not found, please run manifest_parse.sh first"
        return 1
    fi
    remote_url=$(python3 -c "import json; d=json.load(open('${MANIFEST_MAP}')); print(d.get('${packageName}', {}).get('url', ''))")
    commit_hash=$(python3 -c "import json; d=json.load(open('${MANIFEST_MAP}')); print(d.get('${packageName}', {}).get('version', ''))")

    if [[ -z "${remote_url}" || -z "${commit_hash}" ]]; then
        echo "Package ${packageName} not found in manifest, fallback to branch download"
        downloadFromGitee "${packageName}" "${DOWNLOAD_BRANCH}"
        mkdir -p tmp_extract
        local tar_file=$(find "tmp_download/${packageName}" -maxdepth 1 -type f \( -name "*.tar.gz" -o -name "*.tar.xz" -o -name "*.tar.bz2" -o -name "*.zip" \) | head -1)
        if [[ -n "${tar_file}" ]]; then
            tar -xf "${tar_file}" -C tmp_extract 2>/dev/null || unzip -d tmp_extract "${tar_file}" 2>/dev/null || true
        fi
        return 0
    fi

    if [[ -d "tmp_download/${packageName}" ]]; then
        pushd "tmp_download/${packageName}" >/dev/null
        local current_hash=$(git rev-parse HEAD 2>/dev/null)
        popd >/dev/null
        if [[ "${current_hash}" == "${commit_hash}" ]]; then
            echo "INFO: ${packageName} source already exists with correct commit, skip clone"
            mkdir -p tmp_extract
            local tar_file=$(find "tmp_download/${packageName}" -maxdepth 1 -type f \( -name "*.tar.gz" -o -name "*.tar.xz" -o -name "*.tar.bz2" \) | head -1)
            if [[ -n "${tar_file}" ]]; then
                tar -xf "${tar_file}" -C tmp_extract
            fi
            return 0
        fi
        rm -rf "tmp_download/${packageName}"
    fi
    if ! git_clone_with_retry "${remote_url}" "tmp_download/${packageName}"; then
        return 1
    fi
    pushd "tmp_download/${packageName}" >/dev/null
    git checkout "${commit_hash}"
    popd >/dev/null

    mkdir -p tmp_extract
    local tar_file=$(find "tmp_download/${packageName}" -maxdepth 1 -type f \( -name "*.tar.gz" -o -name "*.tar.xz" -o -name "*.tar.bz2" \) | head -1)
    if [[ -n "${tar_file}" ]]; then
        tar -xf "${tar_file}" -C tmp_extract
    fi
}

function downloadSource() {
    downloadUrl=$1
    downloadBranch=$2
    urlName=$(basename "${downloadUrl##*/}" .git)

    if [[ -d "tmp_download/${urlName}" ]]; then
        echo "INFO: ${urlName} source already exists, skip clone"
        return 0
    fi
    git_clone_with_retry -b "${downloadBranch}" "${downloadUrl}" --depth=1 -v "tmp_download/${urlName}"
}

function getPackageName() {
    local package_name=$1
    if [[ -z $packageName ]]; then
        packageName=$(find ./ -name "*$downloadName*.tar.*" -regex ".*\.tar\.[a-zA-Z0-9]+")
    fi
    if [[ -z $packageName ]]; then
        packageName=$(find "./${downloadName}" -maxdepth 1 -name "*.tar.*" -regex ".*\.tar\.[a-zA-Z0-9]+" | head -1)
    fi
    if [[ -z $packageName ]]; then
        packageName=$(find ./ -name "*$package_name*.zip")
    fi
}

function extractPackage() {
    downloadName=$1
    packageName=$2
    extractType=$3
    pushd tmp_download || exit 1
    if [[ -z "${packageName}" ]]; then
        getPackageName "${downloadName}"
    fi
    # 若还未找到相关包可能包名带版本号，例如glib2，实际为glib-2.68.1.tar.xz
    if [[ -z "${packageName}" ]]; then
        getPackageName "$(echo "${downloadName}" | grep -Eo '[a-zA-Z]+')"
    fi
    # 若均为找到相关包，检查是否为纯源码仓库（无压缩包），直接复制
    if [[ -z "${packageName}" ]]; then
        if [[ -d "${downloadName}" ]]; then
            mkdir -p ../tmp_extract
            cp -rR "${downloadName}" ../tmp_extract/
            popd || exit
            return 0
        fi
        echo "not found package to extract！"
        return 1
    fi
    # 规避因代码规范导致指定包名模糊匹配问题，例如 packageName=python3/Python*.tar.xz
    packageName="$(ls ${packageName} | tail -n 1)"
    if [[ -z "${extractType}" ]]; then
        if echo "${packageName}" | grep -q ".tar."; then
            extractType="tar"
        elif echo "${packageName}" | grep -q ".zip" "${packageName}"; then
            extractType="zip"
        fi
    fi
    if [[ "${extractType}" == "zip" ]]; then
        unzip -d ../tmp_extract "${packageName}"
    elif [[ "${extractType}" == "tar" ]]; then
        mkdir -p ../tmp_extract
        tar -xf "${packageName}" -C ../tmp_extract
    fi
    popd || exit
}

function copyFiles() {
    findDir="./tmp_extract/$1"
    if [[ "$3"x != ""x ]]; then
        findDir=$3
    fi

    findThings=$(find ${findDir} -name "$2")
    if [ "$(find ${findDir} -name "$2" | wc -l)" -gt 1 ]; then
        for oneThing in ${findThings}; do
            cp -rR "${oneThing}" ./tmp_test/
        done
    else
        if [ -f "${findThings}" ]; then
            cp "${findThings}" ./tmp_test/
        elif [ -d "${findThings}" ]; then
            cp -rR "${findThings}" ./tmp_test/
        fi
    fi
}

main() {
    mkdir -p ./tmp_download
    mkdir -p ./tmp_extract
    mkdir -p ./tmp_test
    for opt in "$@"; do
        if [[ $opt == "-d" ]]; then
            downloadFromGitee "$2" "$3" "$6"
            if [ -z "$6" ]; then
                if [ -z "$5" ]; then
                    extractPackage "$2" "$4" ""
                else
                    extractPackage "$2" "$4" "$5"
                fi

            fi
            return 0
        elif [[ $opt == "-r" ]]; then
            rm -rf ./tmp_extract
            tar -cf tmp_test.tar ./tmp_test
            rm -rf ./tmp_test
            if [[ $2 == "all" ]]; then
                rm -rf ./tmp_download
                rm -rf ./tmp_test.tar
                rm -rf ./dejagnu
                rm -rf ./dejagnu.tar
                rm -rf ./make
                for subdir in ./oe_test_*; do
                    if [ -d "$subdir" ]; then
                        rm -rf "$subdir/tmp_download"
                        rm -rf "$subdir/tmp_extract"
                        rm -rf "$subdir/tmp_test"
                        rm -rf "$subdir/tmp_test.tar"
                    fi
                done
            fi
            return 0
        elif [[ $opt == "-c" ]]; then
            copyFiles "$2" "$3" "$4"
            return 0
        elif [[ $opt == "-M" ]]; then
            if ! downloadFromManifest "$2"; then
                return 1
            fi
            if [ -z "$5" ]; then
                if ! extractPackage "$2" "$4" ""; then
                    return 1
                fi
            else
                if ! extractPackage "$2" "$4" "$5"; then
                    return 1
                fi
            fi
            return 0
        elif [[ $opt == "-s" ]]; then
            downloadSource "$2" "$3"
            return 0
        elif [[ $opt == "-g" ]]; then
            downloadFromGitee "$2" "$3" "$6"
            return 0
        else
            return 1
        fi
    done

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
