#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
生成 epol -> pkgs-test 迁移的完整命令清单（dry-run）。
输出每个套件的：
  - 每个 sh 文件的 git mv 命令（净化改名）
  - json 更新方案
先打印，人工确认后再执行。
"""

import json
import os
import re

REPO = r"E:\code\openruyi-test-dev\openruyi-test"
EPOL = os.path.join(REPO, "testcases", "feature-test", "epol")
PKGS_TEST = os.path.join(REPO, "testcases", "function-test", "pkgs-test")
SUITE_JSON = os.path.join(REPO, "suite2cases", "function-test", "pkgs-test")

# 完全跳过的套件（内容与现有完全重叠）
SKIP_SUITES = {"wrk"}
# 冲突套件加后缀（内容有独有测试点）
CONFLICT_SUFFIX = {"python-lesscpy": "options"}
# 套件内净化后重名，给特定源文件加后缀
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

# 内容与同套件其他文件完全重复，跳过
DUP_FILES = {
    ("octave", "octave-cli_1.sh"),
}


def clean_name(stem):
    name = re.sub(r"\.sh_\d+$", "", stem)  # considerAsDead.sh_1 -> considerAsDead
    name = re.sub(r"_\d+$", "", name)       # wrk_1 -> wrk
    # 去扩展名残留: jsonpath.py_1 -> jsonpath (去掉 .py 等点后缀)
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


def main():
    suites = sorted(s for s in os.listdir(EPOL) if os.path.isdir(os.path.join(EPOL, s)))
    print("=== 总套件: %d ===" % len(suites))

    for suite in suites:
        sdir = os.path.join(EPOL, suite)
        sh_files = sorted(f for f in os.listdir(sdir) if f.endswith(".sh"))
        aux = sorted(f for f in os.listdir(sdir) if not f.endswith(".sh") and not f.endswith(".json"))
        target_dir = os.path.join(PKGS_TEST, suite)
        suite_json = os.path.join(SUITE_JSON, suite + ".json")
        existing_dir = os.path.isdir(target_dir)

        print("\n### [%s] sh=%d aux=%s existing_dir=%s" % (suite, len(sh_files), aux, existing_dir))

        if suite in SKIP_SUITES:
            print("  SKIP: 内容与现有完全重叠，不迁移")
            continue

        if not sh_files:
            print("  SKIP: empty suite (no sh files)")
            continue

        # 过滤套件内重复文件
        sh_files = [f for f in sh_files if (suite, f) not in DUP_FILES]
        if not sh_files:
            print("  SKIP: all sh files duplicate, no migration")
            continue

        suffix = CONFLICT_SUFFIX.get(suite, "")
        for f in sh_files:
            override = RENAME_OVERRIDE.get((suite, f))
            if override:
                base = override
            else:
                base = case_name(f)
                if suffix:
                    base = base + "_" + suffix
            print("  git mv -- %s %s/%s.sh" % (f, suite, base))

        # json 处理
        if existing_dir and os.path.exists(suite_json):
            data = load_json(suite_json)
            existing = {c["name"].lower() for c in data.get("cases", [])}
            new_names = []
            for f in sh_files:
                override = RENAME_OVERRIDE.get((suite, f))
                if override:
                    base = override
                else:
                    base = case_name(f)
                    if suffix:
                        base = base + "_" + suffix
                if base.lower() not in existing:
                    new_names.append(base)
            print("  MERGE into existing json +%d: %s" % (len(new_names), ", ".join(new_names)))
        else:
            new_names = []
            for f in sh_files:
                override = RENAME_OVERRIDE.get((suite, f))
                if override:
                    base = override
                else:
                    base = case_name(f)
                    if suffix:
                        base = base + "_" + suffix
                new_names.append(base)
            print("  NEW json cases(%d): %s" % (len(new_names), ", ".join(new_names)))


if __name__ == "__main__":
    main()
