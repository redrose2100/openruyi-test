#!/usr/bin/bash
# shellcheck disable=SC2012,SC2086

function downloadFromGitee() {
    downloadName=$1
    downloadBranch=$2
    if [ -z "${downloadBranch}" ]; then
        downloadBranch="openEuler-22.03-LTS"
    fi
    giteeName="src-openeuler"
    if [[ "$3"x != ""x ]]; then
        giteeName=$3
    fi

    git clone -b "${downloadBranch}" "https://gitee.com/${giteeName}/${downloadName}.git" --depth=1 -v "tmp_download/$1"
}

function downloadSource() {
    downloadUrl=$1
    downloadBranch=$2
    urlName=$(basename "${downloadUrl##*/}" .git)

    git clone -b "${downloadBranch}" "${downloadUrl}" --depth=1 -v "tmp_download/${urlName}"
}

function getPackageName() {
    local package_name=$1
    if [[ -z $packageName ]]; then
        packageName=$(find ./ -name "*$downloadName*.tar.*" -regex ".*\.tar\.[a-zA-Z0-9]+")
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
    # 若均为找到相关包则不执行解包动作
    if [[ -z "${packageName}" ]]; then
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
            rm -rf ./tmp_download
            rm -rf ./tmp_extract
            tar -cf tmp_test.tar ./tmp_test
            rm -rf ./tmp_test
            if [[ $2 == "all" ]]; then
                rm -rf ./tmp_test.tar
                rm -rf ./dejagnu
            fi
            return 0
        elif [[ $opt == "-c" ]]; then
            copyFiles "$2" "$3" "$4"
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

main "$@"
