#!/bin/bash
set +e

function oe_err {
    LOG_ERROR "$@"
    ((exec_result++))
}

function oe_log {
    LOG_INFO "$@"
}
