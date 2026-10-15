#!/bin/bash

export WIRESHARK_TRAFFIC_PID="-1"
function generate_traffic()
{
	while true; do
		curl www.openeuler.org >/dev/null 2>&1
		echo "generating tcp 22 traffic" | nc -w 0.4 www.openeuler.org 22 >/dev/null 2>&1
		sleep 0.5
	done
}

function close_traffic()
{
	local wireshark_traffic_pid=${1-"-1"}
	if [ "$1" == "-1" ]; then
		echo "generate_traffic pid does not exist."
	else
		kill -9 "${wireshark_traffic_pid}"
	fi
}

function version_ge() {
    test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"
}


