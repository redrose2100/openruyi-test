#!/usr/bin/env python3
"""migrate_cli_to_pkgs.py — 计算 suite2cases/cli-test → function-test/pkgs-test 移动集合

用法:
  python3 scripts/migrate_cli_to_pkgs.py --dry-run   # 只计算并打印清单，不执行
  python3 scripts/migrate_cli_to_pkgs.py --move-json # 执行 json 移动 + path 更新
  python3 scripts/migrate_cli_to_pkgs.py --move-dirs # 执行文件夹移动 + common 复制
  python3 scripts/migrate_cli_to_pkgs.py --update-refs # 更新移动套件内 common 引用
  python3 scripts/migrate_cli_to_pkgs.py --verify    # 全量验证（sh 存在性等）
"""

import json
import os
import shutil
import sys

REPO = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SUITE2CASES = os.path.join(REPO, "suite2cases")
CLI_TEST = os.path.join(REPO, "testcases", "cli-test")
PKGS_JSON = os.path.join(SUITE2CASES, "function-test", "pkgs-test")
PKGS_DIR = os.path.join(REPO, "testcases", "function-test", "pkgs-test")

OLD_PREFIX = "testcases/cli-test/"
NEW_PREFIX = "testcases/function-test/pkgs-test/"

# 版本化 json：path 指向非同名文件夹
VERSIONED_JSON = {
    "tboot_1.9.12-2": "tboot",
    "tboot_1.10.2-3": "tboot",
    "nototools_0-2": "nototools",
    "nototools_0.2.17": "nototools",
    "podman_0.10.1": "podman",
}


def load_json(path):
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def suite_json_path(suite):
    return os.path.join(SUITE2CASES, suite + ".json")


def compute_sets():
    """计算移动集合。返回 (json_to_move, json_stay, dirs_to_move, dirs_stay)"""
    cli_dirs = {d for d in os.listdir(CLI_TEST)
                if os.path.isdir(os.path.join(CLI_TEST, d))}
    top_json = {f[:-5] for f in os.listdir(SUITE2CASES)
                if f.endswith(".json") and os.path.isfile(os.path.join(SUITE2CASES, f))}

    json_to_move = []
    json_stay = []
    for suite in sorted(top_json):
        j = load_json(suite_json_path(suite))
        p = j.get("path", "")
        if OLD_PREFIX in p:
            # path 指向 cli-test
            target_dir = p.split(OLD_PREFIX, 1)[1].split("/")[0]
            if suite in cli_dirs or target_dir in cli_dirs:
                json_to_move.append(suite)
            else:
                json_stay.append(suite)
        else:
            json_stay.append(suite)

    # 文件夹移动：cli-test 下与 json 同名（或版本化 json 指向）的目录
    moved_json_names = set(json_to_move)
    dirs_to_move = []
    dirs_stay = []
    for d in sorted(cli_dirs):
        if d == "common":
            continue  # 单独处理
        if d in moved_json_names or any(
            v == d for v in VERSIONED_JSON.values() if v in moved_json_names
        ):
            dirs_to_move.append(d)
        else:
            dirs_stay.append(d)

    return json_to_move, json_stay, dirs_to_move


def main():
    args = sys.argv[1:]
    dry_run = "--dry-run" in args
    preview_path = "--preview-path" in args
    move_json = "--move-json" in args
    move_dirs = "--move-dirs" in args
    update_refs = "--update-refs" in args
    verify = "--verify" in args

    json_to_move, json_stay, dirs_to_move = compute_sets()

    if dry_run:
        print(f"json 移动: {len(json_to_move)} 个")
        print(f"json 保留: {len(json_stay)} 个")
        print(f"文件夹移动: {len(dirs_to_move)} 个")
        print("版本化 json:", [s for s in json_to_move if s in VERSIONED_JSON])
        print("cli-test 保留文件夹:", sorted(
            set(os.listdir(CLI_TEST)) - set(dirs_to_move) - {"common"}))
        return

    if preview_path:
        print(f"[preview-path] 预览 {len(json_to_move)} 个 json 的 path 更新")
        errors = []
        for suite in json_to_move:
            j = load_json(suite_json_path(suite))
            old_p = j.get("path", "")
            new_p = old_p.replace(OLD_PREFIX, NEW_PREFIX)
            target_dir = new_p.split(NEW_PREFIX, 1)[1].split("/")[0]
            if suite in VERSIONED_JSON:
                expected = VERSIONED_JSON[suite]
                if target_dir != expected:
                    errors.append(f"{suite}.json -> {new_p} (期望 {expected})")
            elif target_dir != suite:
                errors.append(f"{suite}.json -> {new_p} (期望目录 {suite})")
        for e in errors:
            print(f"  !! {e}")
        if not errors:
            print("  全部 path 更新正确（含 5 个版本化 json）")
        else:
            print(f"  错误 {len(errors)} 个")
        return

    if move_json:
        print(f"[move-json] 移动 {len(json_to_move)} 个 json + 更新 path")
        os.makedirs(PKGS_JSON, exist_ok=True)
        for suite in json_to_move:
            src = suite_json_path(suite)
            dst = os.path.join(PKGS_JSON, suite + ".json")
            if os.path.exists(dst):
                print(f"  !! 目标已存在: {dst}")
                sys.exit(1)
            # 先更新 path，再移动
            with open(src, "r", encoding="utf-8") as f:
                content = f.read()
            assert OLD_PREFIX in content, f"{suite}.json 无 cli-test 前缀"
            new_content = content.replace(OLD_PREFIX, NEW_PREFIX)
            with open(src, "w", encoding="utf-8") as f:
                f.write(new_content)
            shutil.move(src, dst)
            print(f"  moved: {suite}.json -> pkgs-test/")
        print("[move-json] 完成")

    if move_dirs:
        # 文件夹移动集合基于 pkgs-test 已移动的 json 计算
        moved_suites = {f[:-5] for f in os.listdir(PKGS_JSON)
                        if f.endswith(".json")}
        want_dirs = set()
        for s in moved_suites:
            want_dirs.add(s)
            if s in VERSIONED_JSON:
                want_dirs.add(VERSIONED_JSON[s])
        cli_dirs = {d for d in os.listdir(CLI_TEST)
                    if os.path.isdir(os.path.join(CLI_TEST, d))}
        dirs_to_move = sorted(want_dirs & cli_dirs - {"common"})
        print(f"[move-dirs] 移动 {len(dirs_to_move)} 个文件夹 + common")
        os.makedirs(PKGS_DIR, exist_ok=True)
        for d in dirs_to_move:
            src = os.path.join(CLI_TEST, d)
            dst = os.path.join(PKGS_DIR, d)
            if os.path.exists(dst):
                print(f"  !! 目标已存在: {dst}")
                sys.exit(1)
            shutil.move(src, dst)
            print(f"  moved: cli-test/{d} -> pkgs-test/{d}")
        # common：复制（cli-test 保留副本）
        common_src = os.path.join(CLI_TEST, "common")
        common_dst = os.path.join(PKGS_DIR, "common")
        if os.path.exists(common_src) and not os.path.exists(common_dst):
            shutil.copytree(common_src, common_dst)
            print("  copied: cli-test/common -> pkgs-test/common (cli-test 保留)")
        print("[move-dirs] 完成")

    if update_refs:
        print("[update-refs] 更新移动套件内 common 引用")
        pkgs_dirs = [d for d in os.listdir(PKGS_DIR)
                     if os.path.isdir(os.path.join(PKGS_DIR, d))]
        count = 0
        skipped = 0
        for d in pkgs_dirs:
            if d == "common":
                continue
            base = os.path.join(PKGS_DIR, d)
            for root, _, files in os.walk(base):
                for fn in files:
                    if fn.endswith(".sh"):
                        p = os.path.join(root, fn)
                        with open(p, "rb") as f:
                            raw = f.read()
                        content = None
                        for enc in ("utf-8", "gbk"):
                            try:
                                content = raw.decode(enc)
                                break
                            except UnicodeDecodeError:
                                continue
                        if content is None:
                            skipped += 1
                            continue
                        if OLD_PREFIX in content:
                            new_content = content.replace(
                                OLD_PREFIX, NEW_PREFIX)
                            with open(p, "w", encoding="utf-8") as f:
                                f.write(new_content)
                            count += 1
        print(f"  更新 {count} 个文件 (无法解码跳过 {skipped})")
        print("[update-refs] 完成")

    if verify:
        print("[verify] 全量验证")
        print(f"  pkgs-test json 数: {len([f for f in os.listdir(PKGS_JSON) if f.endswith('.json')])}")
        print(f"  suite2cases 顶层 json 数: {len([f for f in os.listdir(SUITE2CASES) if f.endswith('.json') and os.path.isfile(os.path.join(SUITE2CASES, f))])}")
        print(f"  pkgs-test 文件夹数: {len([d for d in os.listdir(PKGS_DIR) if os.path.isdir(os.path.join(PKGS_DIR, d))])}")
        print(f"  cli-test 剩余: {sorted(os.listdir(CLI_TEST))}")
        print("[verify] 完成")


if __name__ == "__main__":
    main()
