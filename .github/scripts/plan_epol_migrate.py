#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
分析 epol 迁移到 pkgs-test 的完整映射表。

输出：
  - 每个套件的迁移计划（sh 文件 → 新文件名、json case 名）
  - 冲突检测：套件内重名、与 pkgs-test 现有 case 冲突
"""

import json
import os
import re
import sys

REPO = r"E:\code\openruyi-test-dev\openruyi-test"
EPOL = os.path.join(REPO, "testcases", "feature-test", "epol")
PKGS_TEST = os.path.join(REPO, "testcases", "function-test", "pkgs-test")
SUITE_JSON = os.path.join(REPO, "suite2cases", "function-test", "pkgs-test")


def clean_name(stem):
    """净化文件名：去 _数字 后缀、去 .sh_1 怪命名、去非法字符。"""
    name = stem
    # 处理 .sh_1.sh 怪命名: considerAsDead.sh_1 -> considerAsDead
    name = re.sub(r"\.sh_\d+$", "", name)
    # 去 _数字 后缀: wrk_1 -> wrk, bandit_1 -> bandit
    name = re.sub(r"_\d+$", "", name)
    # 去非法字符（--help -> help, CLASSNAME 保留大小写但去特殊符）
    name = name.replace("--", "_").replace("-", "_")
    # 全小写
    name = name.lower()
    # 去多余下划线
    name = re.sub(r"_+", "_", name).strip("_")
    return name


def case_name(sh_file):
    """由 sh 文件名推导 oe_test_ 前缀 case 名。"""
    stem = os.path.splitext(sh_file)[0]
    cleaned = clean_name(stem)
    return "oe_test_" + cleaned


def load_json(path):
    with open(path, "r", encoding="utf-8-sig") as f:
        return json.load(f)


def main():
    suites = sorted(os.listdir(EPOL))
    # 已存在的 pkgs-test json case 集合（大小写不敏感）
    existing = {}
    for jf in os.listdir(SUITE_JSON):
        if not jf.endswith(".json"):
            continue
        pkg = jf[:-5]
        data = load_json(os.path.join(SUITE_JSON, jf))
        existing[pkg.lower()] = {c["name"].lower() for c in data.get("cases", [])}

    report = []
    for suite in suites:
        sdir = os.path.join(EPOL, suite)
        if not os.path.isdir(sdir):
            continue
        sh_files = sorted(f for f in os.listdir(sdir) if f.endswith(".sh"))
        json_files = sorted(f for f in os.listdir(sdir) if f.endswith(".json"))
        # json 里声明的 case（保持顺序）
        declared = []
        for jf in json_files:
            data = load_json(os.path.join(sdir, jf))
            for c in data.get("cases", []):
                declared.append(c["name"])

        # 新 case 名
        new_cases = []
        for f in sh_files:
            new_cases.append(case_name(f))

        # 套件内重名检测（净化后）
        dup_inner = {}
        for i, n in enumerate(new_cases):
            dup_inner.setdefault(n, []).append(sh_files[i])

        # 与现有 pkgs-test case 冲突
        conflicts = []
        for n in new_cases:
            if n.lower() in existing.get(suite.lower(), set()):
                conflicts.append(n)

        report.append({
            "suite": suite,
            "sh_count": len(sh_files),
            "json_count": len(json_files),
            "sh_files": sh_files,
            "declared": declared,
            "new_cases": new_cases,
            "dup_inner": {k: v for k, v in dup_inner.items() if len(v) > 1},
            "conflicts": conflicts,
        })

    # 输出
    total_sh = sum(r["sh_count"] for r in report)
    print("=== 套件总数: %d, sh 总数: %d ===" % (len(report), total_sh))
    print("\n--- 套件内净化后重名 ---")
    for r in report:
        if r["dup_inner"]:
            print("[%s]" % r["suite"])
            for k, v in r["dup_inner"].items():
                print("  %s <- %s" % (k, ", ".join(v)))
    print("\n--- 与 pkgs-test 现有 case 冲突 ---")
    for r in report:
        if r["conflicts"]:
            print("[%s] %s" % (r["suite"], ", ".join(r["conflicts"])))
    print("\n--- 特殊命名样例（净化结果）---")
    special = []
    for r in report:
        for f, n in zip(r["sh_files"], r["new_cases"]):
            if n != "oe_test_" + clean_name(os.path.splitext(f)[0]):
                special.append((r["suite"], f, n))
    for s, f, n in special[:30]:
        print("[%s] %s -> %s" % (s, f, n))


if __name__ == "__main__":
    main()
