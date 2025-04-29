#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
 Copyright (c) [2025] Huawei Technologies Co.,Ltd.ALL rights reserved.
 This program is licensed under Mulan PSL v2.
 You can use it according to the terms and conditions of the Mulan PSL v2.
          http://license.coscl.org.cn/MulanPSL2
 THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 See the Mulan PSL v2 for more details.

 @Author  : erin_dan
 @email   : 1743994506@qq.com
 @Date    : 2025-04-08 10:09:36
 @License : Mulan PSL v2
 @Version : 1.0
 @Desc    : 用于给driver_test模块生成json文件
"""

import pandas as pd
import argparse
import sys
import json
import os
import ast

import mugen_log

SCRIPT_PATH = os.path.dirname(os.path.abspath(__file__))
PARTS = SCRIPT_PATH.split(os.path.sep)
MUGEN_INDEX = PARTS.index('mugen')
OET_PATH = os.path.sep.join(PARTS[:MUGEN_INDEX+1])

if OET_PATH is None:
    mugen_log.logging("error", "OET_PATH不存在,请检查mugen框架.")
    sys.exit(1)

def remove_value_0(data):
    if data.get("machine num")  == 0:
        del data["machine num"]
        for item in data.get("case", []):
            if "machine num" in item:
                del item["machine num"]
    else:
        for item in data.get("case", []):
            if "machine num" in item and item["machine num"] == 0:
                del item["machine num"]

    if data.get("add network interface")  == 0:
        del data["add network interface"]
        for item in data.get("case", []):
            if "add network interface" in item:
                del item["add network interface"]
    else:
        for item in data.get("case", []):
            if "add network interface" in item and item["add network interface"] == 0:
                del item["add network interface"]

    if len(data.get("add disk")) == 1 and data.get("add disk")[0] == 0:
        del data["add disk"]
        for item in data.get("case", []):
            if "add disk" in item:
                del item["add disk"]
    else:
        for item in data.get("case", []):
            if "add disk" in item and item["add disk"] == 0:
                del item["add disk"]

def excel_to_json(df, sheet_name):

    json_data = {
            "path": "",
            "add disk": [],
            "machine type": "",
            "machine num": 0,
            "add network interface": 0,
            "case": []
            }

    columns = df.columns.tolist()

    if 'path' in columns and 'add disk(suite)' in columns and 'machine type(suite)' in columns and 'machine num(suite)' in columns and 'add network interface(suite)' in columns:
        json_data['path'] = df['path'].iloc[0]
        json_data['machine type'] = df['machine type(suite)'].iloc[0]
        json_data['machine num'] = int(df['machine num(suite)'].iloc[0])
        json_data['add network interface'] = int(df['add network interface(suite)'].iloc[0])
        if type(df['add disk(suite)'].iloc[0]) is not str:
            json_data['add disk'] = [int(df['add disk(suite)'].iloc[0])]
        else:
            json_data['add disk'] = ast.literal_eval(df['add disk(suite)'].iloc[0])
    
    if 'case name' in columns and 'add disk(case)' in columns and 'machine type(case)' in columns and 'machine num(case)' in columns and 'add network interface(case)' in columns:
        for index, row in df.iterrows():
            if type(row['add disk(case)']) is not str:
                case = {
                        "name": row['case name'],
                        "add disk": int(row['add disk(case)']),
                        "machine type": row['machine type(case)'],
                        "machine num": row['machine num(case)'],
                        "add network interface": row['add network interface(case)']
                       }
            else:
                case = {
                         "name": row['case name'],
                         "add disk": ast.literal_eval(row['add disk(case)']),
                         "machine type": row['machine type(case)'],
                         "machine num": row['machine num(case)'],
                         "add network interface": row['add network interface(case)']
                        }
            json_data['case'].append(case)
    remove_value_0(json_data)

    json_str = json.dumps(json_data, indent=4, ensure_ascii=False)

    json_filename = f"{OET_PATH}/suite2cases/driver_{sheet_name}.json"

    with open(json_filename, 'w') as f:
        f.write(json_str)
    print(f"JSON file saved as {json_filename}")

def read_excel(excel_path, sheet_names):
    if len(sheet_names) == 0:
        xls = pd.ExcelFile(excel_path)
        sheet_names = xls.sheet_names

    for sheet_name in sheet_names:
        df = pd.read_excel(excel_path, sheet_name=sheet_name, usecols='A:J')
        excel_to_json(df, sheet_name)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        mugen_log.logging("error", "Usage: python excel_to_json.py <excel_path> <sheet_name>")
        sys.exit(1)
    
    excel_path = sys.argv[1]
    sheet_names = sys.argv[2:]

    if len(sheet_names) > 0:
        sheet_name_args = ['perf', 'minios', 'hikptool', 'ras', 'sas', 'sata', 'wayca', 'nic', 'pcie', 'roce', 'virt', 'dpdk', 'miniio']
        result = all(element in sheet_name_args for element in sheet_names)
        if result:
            read_excel(excel_path, sheet_names)
        else:
            mugen_log.logging("error", "传入的sheet_name不正确,请检查.需在perf,minios,hikptool,ras,sas,sata,wayca,nic,pcie,roce,virt,dpdk,miniio范围内")
            sys.exit(1)
    else:
        read_excel(excel_path, sheet_names)
