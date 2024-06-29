# -*- coding: utf-8 -*-
"""
 Copyright (c) [2021] Huawei Technologies Co.,Ltd.ALL rights reserved.
 This program is licensed under Mulan PSL v2.
 You can use it according to the terms and conditions of the Mulan PSL v2.
          http://license.coscl.org.cn/MulanPSL2
 THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 See the Mulan PSL v2 for more details.

 @Author  : saarloos
 @email   : 9090-90-90-9090@163.com
 @Date    : 2024-07-10 15:41:00
 @License : Mulan PSL v2
 @Version : 1.0
 @Desc    : 嵌入式ub测试, 并统计分数
"""

import argparse
import sys

BEGIN_STR = "System Benchmarks Index Values"
END_STR = "System Benchmarks Index Score"

ALL_ITEM_STR = [ 
    "Dhrystone 2 using register variables",      # uixbench signl run: dhry2reg
    "Double-Precision Whetstone",                # uixbench signl run: whetstone-double
    "Execl Throughput",                          # uixbench signl run: execl
    "File Copy 1024 bufsize 2000 maxblocks",     # uixbench signl run: fstime
    "File Copy 256 bufsize 500 maxblocks",       # uixbench signl run: fsbuffer
    "File Copy 4096 bufsize 8000 maxblocks",     # uixbench signl run: logmsg
    "Pipe Throughput",                           # uixbench signl run: pipe
    "Pipe-based Context Switching",              # uixbench signl run: context1
    "Process Creation",                          # uixbench signl run: spawn
    "Shell Scripts (1 concurrent)",              # uixbench signl run: shell1
    "Shell Scripts (8 concurrent)",              # uixbench signl run: shell8
    "System Call Overhead"                       # uixbench signl run: sysexec
]

def ana_score(all_lines:list, single_score_lists:list, multiple_score_lists:list):
    begin_select = False
    tmp_scores = []
    single_list = True
    for one_line in all_lines:
        if BEGIN_STR in one_line:
            begin_select = True
            tmp_scores = []
            continue
        if END_STR in one_line:
            total_score = one_line[len(END_STR):].strip().split(" ")[0]
            tmp_scores.insert(0, total_score)
            begin_select = False
            if single_list:
                single_score_lists.append(tmp_scores)
                single_list = False
            else:
                multiple_score_lists.append(tmp_scores)
                single_list = True
            continue
        if not begin_select:
            continue
        for one_item in ALL_ITEM_STR:
            if one_item in one_line:
                tmp_line = one_line[len(one_item) + 1 :].strip().split(" ")
                tmp_line = [tmp_word for tmp_word in tmp_line if tmp_word]
                tmp_scores.append(tmp_line[1])

def add_average(scroc_list:list):
    average_list = []
    total_number = 0
    for one_list in scroc_list:
        if len(average_list) != len(one_list):
            i = 0
            while i < len(one_list):
                average_list.append(float(one_list[i]))
                i += 1
        else:
            i = 0
            while i < len(one_list):
                average_list[i] += float(one_list[i])
                i += 1
        total_number += 1
    if total_number == 0:
        return
    i = 0
    while i < len(average_list):
        average_list[i] /= total_number
        i += 1
    scroc_list.append(average_list)

def print_all_score(score_lists:list):
    i = 0
    for one_list in score_lists:
        i += 1
        line_num = 0
        for one_item in one_list:
            print_str = "%.2f"%float(one_item)
            line_num += len(print_str) + 1
            print(print_str, end=" ")
        print("")
        if i == 3:
            print(line_num * "-")
    print("")

def ana_files(files:list):
    single_score_lists = []
    multiple_score_lists = []
    for one_file in files:
        f = open(one_file, "r")
        all_lines = f.readlines()
        ana_score(all_lines, single_score_lists, multiple_score_lists)
    add_average(single_score_lists)
    add_average(multiple_score_lists)
    print_all_score(single_score_lists)
    print_all_score(multiple_score_lists)
    return 0

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="manual to this script")
    parser.add_argument('-f', '--files', type=str, nargs="+", help = "start qemu or stop qemu")
    args = parser.parse_args()

    if args.files is None:
        parser.error("ERROR", "not files input")
    sys.exit(ana_files(args.files))
