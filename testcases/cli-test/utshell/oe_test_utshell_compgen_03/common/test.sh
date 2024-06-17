#!/bin/bash

function_lunch() {
local cur opts
COMPREPLY=()
cur=${COMP_WORDS[COMP_CWORD]}
opts="-f -r -t -w -o --output -v --version -h --help" #补全选项
mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
complete  -F _lunch  lunch
echo $?
}