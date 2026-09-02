#!/usr/bin/bash
# shellcheck disable=SC2086

# shellcheck disable=SC1091
source "${OET_PATH}/testcases/embedded-test/common_libs/common.sh"

YOCTO_META_DIR="${OET_PATH}/yocto-meta-openeuler"
MANIFEST_FILE="${YOCTO_META_DIR}/.oebuild/manifest.yaml"
MAP_FILE="${OET_PATH}/testcases/embedded-test/common_libs/manifest_map.json"

YOCTO_META_BRANCH=${YOCTO_META_BRANCH:-"openEuler-24.03-LTS"}
YOCTO_META_REMOTE=${YOCTO_META_REMOTE:-"https://atomgit.com/openeuler/yocto-meta-openeuler.git"}

function fetch_manifest() {
    if [[ -d "${YOCTO_META_DIR}" ]]; then
        pushd "${YOCTO_META_DIR}" >/dev/null || exit
        git fetch origin
        git checkout "${YOCTO_META_BRANCH}"
        git reset --hard "origin/${YOCTO_META_BRANCH}"
        popd >/dev/null || exit
    else
        git_clone_with_retry -b "${YOCTO_META_BRANCH}" "${YOCTO_META_REMOTE}" "${YOCTO_META_DIR}"
    fi
}

function parse_manifest() {
    python3 -c "
import yaml, json, sys

with open('${MANIFEST_FILE}', 'r') as f:
    data = yaml.safe_load(f)

manifest_list = data.get('manifest_list', {})
result = {}
for name, info in manifest_list.items():
    url = info.get('remote_url', '')
    version = info.get('version', '')
    if url and version:
        result[name] = {'url': url, 'version': version}

with open('${MAP_FILE}', 'w') as f:
    json.dump(result, f, indent=2)

print(f'Generated manifest map with {len(result)} packages')
"
}

function main() {
    fetch_manifest
    parse_manifest
}

main
