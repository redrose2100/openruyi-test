#!/bin/bash

. tst_test.sh
mpam_dir="/sys/fs/resctrl"

# log file
LOG_MEMINFO="log_meminfo"

ENV_L2_ID=()
ENV_L2_ID_NUM=0
ENV_L3_ID=()
ENV_L3_ID_NUM=0
ENV_NUMA_NUM=0
ENV_CPU_NUM=0

RES_GROUP_MAX=31 # 32-1
MON_GROUP_MAX=3 # 4-1

fn_get_env_l2_id(){
    local i found index list

    while read line; do
        found=0
        for i in ${ENV_L2_ID[@]}; do
            if [ "$i" == "$line" ]; then
                found=1
                break
            fi
        done
        if [ $found -eq 0 ]; then
            ENV_L2_ID[${#ENV_L2_ID[@]}]=$line
        fi
    done < <(cat /sys/devices/system/cpu/cpu*/cache/index2/id)

    list=$(echo ${ENV_L2_ID[*]} | tr ' ' '\n' | sort -n)

    index=0
    for i in $list; do
        ENV_L2_ID[$index]=$i
        let index++
    done

    ENV_L2_ID_NUM=${#ENV_L2_ID[@]}
}

fn_get_env_l3_id(){
    local i found index list

    while read line; do
        found=0
        for i in ${ENV_L3_ID[@]}; do
            if [ "$i" == "$line" ]; then
                found=1
                break
            fi
        done
        if [ $found -eq 0 ]; then
            ENV_L3_ID[${#ENV_L3_ID[@]}]=$line
        fi
    done < <(cat /sys/devices/system/cpu/cpu*/cache/index3/id)

    list=$(echo ${ENV_L3_ID[*]} | tr ' ' '\n' | sort -n)

    index=0
    for i in $list; do
        ENV_L3_ID[$index]=$i
        let index++
    done

    ENV_L3_ID_NUM=${#ENV_L3_ID[@]}
}

fn_get_env_numa_num(){
    ENV_NUMA_NUM=`lscpu | grep "NUMA node(s)" | awk '{print $3}'`
}

fn_get_env_cpu_num(){
    ENV_CPU_NUM=`lscpu | grep "^CPU(s):" | awk '{print $2}'`
}

fn_get_env_l2_id
fn_get_env_l3_id
fn_get_env_numa_num
fn_get_env_cpu_num