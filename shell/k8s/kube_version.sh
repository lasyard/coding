#!/bin/bash

KUBECTL="kubectl"
JQ="jq"

# 获取 kube server 版本号（major minor）
get_kube_server_version() {
    local version_json major minor

    if ! version_json=$(${KUBECTL} version -o json 2>/dev/null); then
        return 1
    fi

    major=$(echo "${version_json}" | ${JQ} -r '.serverVersion.major' 2>/dev/null)
    minor=$(echo "${version_json}" | ${JQ} -r '.serverVersion.minor' 2>/dev/null)

    major=${major:-1}
    minor=${minor:-0}

    echo "${major} ${minor}"
    return 0
}

# 通用版本比较：当前版本是否大于目标版本
version_gt() {
    local current_major="$1"
    local current_minor="$2"
    local target_major="$3"
    local target_minor="$4"

    if [ "${current_major}" -gt "${target_major}" ]; then
        return 0
    fi

    if [ "${current_major}" -eq "${target_major}" ] && [ "${current_minor}" -gt "${target_minor}" ]; then
        return 0
    fi

    return 1
}

if ! read -r current_major current_minor < <(get_kube_server_version); then
    echo "[ERROR] Failed to get kube server version"
    return 1
fi
echo "Kube server version: ${current_major}.${current_minor}"
if version_gt "${current_major}" "${current_minor}" 1 33; then
    echo "Kube server version is greater than 1.33"
else
    echo "Kube server version is not greater than 1.33"
fi
