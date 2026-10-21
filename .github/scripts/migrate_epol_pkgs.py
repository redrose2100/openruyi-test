#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
epol -> pkgs-test 迁移执行脚本（生成 git 命令并直接执行）。

用法: python migrate_epol_pkgs.py <start_idx> <end_idx> [--commit]
  - 按套件排序后的索引区间迁移
  - 打印每个操作并执行 git mv / 写 json
"""

import json
import os
import re
import subprocess
import sys

REPO = r"E:\code\openruyi-test-dev\openruyi-test"
EPOL = os.path.join(REPO, "testcases", "feature-test", "epol")
PKGS_TEST = os.path.join(REPO, "testcases", "function-test", "pkgs-test")
SUITE_JSON = os.path.join(REPO, "suite2cases", "function-test", "pkgs-test")

# 完全跳过的套件（内容与现有完全重叠）
SKIP_SUITES = {"wrk"}

# 冲突套件 -> 加后缀迁移
CONFLICT_SUFFIX = {
    "python-lesscpy": "options",   # oe_test_lesscpy_options.sh
}

# 套件内净化后重名，给特定源文件强制改名
RENAME_OVERRIDE = {
    ("whois", "whois.md_1.sh"): "oe_test_whois_md",
    ("mate-terminal", "mate-terminal.wrapper_1.sh"): "oe_test_mate_terminal_config",
    ("gst-editing-services", "+clip.sh"): "oe_test_plus_clip",
    ("gst-editing-services", "+effect.sh"): "oe_test_plus_effect",
    ("gst-editing-services", "+test-clip.sh"): "oe_test_plus_test_clip",
    ("gst-editing-services", "+title.sh"): "oe_test_plus_title",
    ("octave", "octave-5.1.0_1.sh"): "oe_test_octave",
    ("octave", "octave-cli-5.1.0_1.sh"): "oe_test_octave_cli",
    ("octave", "octave_1.sh"): "oe_test_octave_options",
}

# 内容与同套件其他文件完全重复，跳过（不迁移、不写入 json）
DUP_FILES = {
    ("octave", "octave-cli_1.sh"),
}


def git(args):
    r = subprocess.run(["git", "-C", REPO] + args, capture_output=True, text=True)
    return r


def clean_name(stem):
    name = re.sub(r"\.sh_\d+$", "", stem)
    name = re.sub(r"_\d+$", "", name)
    # 去扩展名残留: jsonpath.py_1 -> jsonpath
    name = re.sub(r"\.[a-z0-9]+$", "", name)
    name = name.replace("--", "_").replace("-", "_")
    name = name.lower()
    name = re.sub(r"_+", "_", name).strip("_")
    return name


def case_name(sh_file):
    stem = os.path.splitext(sh_file)[0]
    return "oe_test_" + clean_name(stem)


def load_json(path):
    with open(path, "r", encoding="utf-8-sig") as f:
        return json.load(f)


def save_json(path, data):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
        f.write("\n")


def migrate_suite(suite):
    """迁移单个套件，返回 (moved, skipped_cases, errors)。"""
    sdir = os.path.join(EPOL, suite)
    sh_files = sorted(f for f in os.listdir(sdir) if f.endswith(".sh"))
    json_files = sorted(f for f in os.listdir(sdir) if f.endswith(".json"))
    target_dir = os.path.join(PKGS_TEST, suite)
    suite_json = os.path.join(SUITE_JSON, suite + ".json")
    existing_dir = os.path.isdir(target_dir)

    print("### [%s] sh=%d json=%d existing_dir=%s" % (suite, len(sh_files), len(json_files), existing_dir))

    # 空套件：无 sh 文件，整体跳过
    if not sh_files:
        print("  SKIP: empty suite (no sh files)")
        return 0, 0, []

    new_cases = []
    suffix = CONFLICT_SUFFIX.get(suite, "")
    skip_names = set()

    for f in sh_files:
        if suite in SKIP_SUITES or (suite, f) in DUP_FILES:
            skip_names.add(f)
            continue
        override = RENAME_OVERRIDE.get((suite, f))
        if override:
            base = override
        else:
            base = case_name(f)
            if suffix:
                base = base + "_" + suffix
        new_cases.append((f, base))
        print("  %s -> %s" % (f, base))

    # 目标目录
    if not existing_dir:
        os.makedirs(target_dir, exist_ok=True)

    # git mv 每个 sh（用 -- 分隔，避免以 - 开头的文件名被当作选项）
    for src, dst in new_cases:
        git(["mv", "--", os.path.join(sdir, src), os.path.join(target_dir, dst + ".sh")])

    # 非 sh 非 json 的辅助文件（如 report.lua）也迁移
    for f in os.listdir(sdir):
        if f.endswith(".sh") or f.endswith(".json"):
            continue
        git(["mv", os.path.join(sdir, f), os.path.join(target_dir, f)])

    # json 处理
    if suite in SKIP_SUITES:
        print("  SKIP suite (content overlap), json not migrated")
        return len(new_cases), len(skip_names), []

    if existing_dir and os.path.exists(suite_json):
        # 合并：追加到现有 json
        data = load_json(suite_json)
        existing_names = {c["name"].lower() for c in data.get("cases", [])}
        added = 0
        for _, dst in new_cases:
            if dst.lower() in existing_names:
                continue
            data["cases"].append({"name": dst})
            added += 1
        save_json(suite_json, data)
        print("  merged into existing json, added %d cases" % added)
    else:
        # 新 json
        cases = [{"name": dst} for _, dst in new_cases]
        data = {"path": "$OET_PATH/testcases/function-test/pkgs-test/" + suite, "cases": cases}
        save_json(suite_json, data)
        print("  wrote new json with %d cases" % len(cases))

    return len(new_cases), 0, []


def main():
    start = int(sys.argv[1])
    end = int(sys.argv[2]) if len(sys.argv) > 2 else start + 1
    suites = sorted(os.listdir(EPOL))
    suites = [s for s in suites if os.path.isdir(os.path.join(EPOL, s))]
    batch = suites[start:end]
    total_moved = 0
    total_skip = 0
    errors = []
    for suite in batch:
        moved, skipped, errs = migrate_suite(suite)
        total_moved += moved
        total_skip += skipped
        errors.extend(errs)
    print("=== batch done: moved %d sh, skipped %d sh, errors %d ===" % (total_moved, total_skip, len(errors)))
    for e in errors:
        print("ERROR:", e)


if __name__ == "__main__":
    main()
