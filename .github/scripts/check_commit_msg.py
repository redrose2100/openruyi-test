#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
 Copyright (c) [2026] Huawei Technologies Co.,Ltd.ALL rights reserved.
 This program is licensed under Mulan PSL v2.
 You can use it according to the terms and conditions of the Mulan PSL v2.
          http://license.coscl.org.cn/MulanPSL2
 THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 See the Mulan PSL v2 for more details.

 @Author  : redrose2100
 @License : Mulan PSL v2
 @Version : 1.0
 @Desc    : 检查 commit message 是否符合 Conventional Commits 规范
"""

import argparse
import os
import re
import subprocess
import sys

def find_repo_root(start_dir):
    """从脚本所在目录向上查找仓库根（含 suite2cases 的目录）。

    脚本位于 .github/scripts 下，不能再用脚本所在目录当仓库根，
    这里改为向上逐级探测，同时兼容被移动到其他层级的情况。
    """
    current = os.path.realpath(start_dir)
    while True:
        if os.path.isdir(os.path.join(current, "suite2cases")):
            return current
        parent = os.path.dirname(current)
        if parent == current:
            break
        current = parent
    # 兜底：退化到脚本上两级目录，保证不会静默拿到错误路径
    return os.path.realpath(os.path.join(start_dir, os.pardir, os.pardir))


# 仓库根目录：以脚本自身位置向上推导，不依赖调用者的当前工作目录
REPO_ROOT = find_repo_root(os.path.dirname(os.path.abspath(__file__)))

# 允许的提交类型
ALLOWED_TYPES = (
    "feat",
    "fix",
    "docs",
    "style",
    "refactor",
    "perf",
    "test",
    "build",
    "ci",
    "chore",
    "revert",
)

# header 长度上限
HEADER_MAX_LEN = 100

# Conventional Commits：type(scope)!: subject
# scope 可选；! 表示破坏性变更；冒号后必须有一个空格
HEADER_RE = re.compile(
    r"^(?P<type>[a-zA-Z]+)"
    r"(?:\((?P<scope>[^()]*)\))?"
    r"(?P<breaking>!)?"
    r": (?P<subject>.+)$"
)

# 不需要校验的自动生成提交
EXEMPT_PREFIXES = (
    "Merge ",
    "Revert ",
    "fixup! ",
    "squash! ",
    "amend! ",
)

# 正文中声明破坏性变更的写法
BREAKING_BODY_RE = re.compile(r"^BREAKING[ -]CHANGE:", re.MULTILINE)

# 提交信息分隔：空行以上为 header
SEPARATOR = "\n\n"


def is_exempt(header):
    """Merge / Revert / fixup! 等自动提交不参与校验。"""
    return header.startswith(EXEMPT_PREFIXES)


def split_message(message):
    """拆出 header 与正文。"""
    parts = message.split(SEPARATOR, 1)
    header = parts[0].splitlines()[0] if parts[0].splitlines() else ""
    body = parts[1] if len(parts) > 1 else ""
    return header, body


def check_message(message):
    """校验单条 commit message，返回错误列表。"""
    errors = []
    header, body = split_message(message)

    if not header.strip():
        return ["commit message header is empty"]

    if is_exempt(header):
        return errors

    if len(header) > HEADER_MAX_LEN:
        errors.append(
            "header is %d chars, exceeds the %d limit" % (len(header), HEADER_MAX_LEN)
        )

    match = HEADER_RE.match(header)
    if not match:
        errors.append(
            "header does not match 'type(scope): subject' -> %r" % header
        )
        return errors

    commit_type = match.group("type")
    if commit_type not in ALLOWED_TYPES:
        errors.append(
            "unknown type %r, allowed: %s" % (commit_type, ", ".join(ALLOWED_TYPES))
        )

    subject = match.group("subject")
    if not subject.strip():
        errors.append("subject is empty")
    if subject.rstrip().endswith((".", "。")):
        errors.append("subject must not end with a period -> %r" % subject)

    # 破坏性变更：header 中的 ! 或正文中的 BREAKING CHANGE footer，二者其一即可
    # 都是合法写法，这里不做额外校验

    return errors


def read_range_messages(rev_range):
    """读取 rev-range 内所有 commit message。

    使用 RECORD (\\x1e) 分隔 commit、FIELD (\\x1f) 分隔字段，避免 message
    内部的换行导致解析错位。
    """
    cmd = [
        "git",
        "-C",
        REPO_ROOT,
        "log",
        "--no-merges",
        "--format=%H%x1f%B%x1e",
        rev_range,
    ]
    try:
        completed = subprocess.run(
            cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False
        )
    except OSError as exc:
        sys.stderr.write("ERROR: cannot run git: %s\n" % exc)
        sys.exit(2)

    if completed.returncode != 0:
        sys.stderr.write(
            "ERROR: git log failed for '%s':\n%s\n"
            % (rev_range, completed.stderr.decode("utf-8", "replace"))
        )
        sys.exit(2)

    raw = completed.stdout.decode("utf-8", "replace")
    commits = []
    for chunk in raw.split("\x1e"):
        chunk = chunk.strip("\n")
        if not chunk:
            continue
        if "\x1f" not in chunk:
            continue
        sha, message = chunk.split("\x1f", 1)
        commits.append((sha.strip(), message.rstrip("\n")))
    return commits


def read_messages_file(path):
    """从文件读取消息，每条消息之间用单独一行 '---' 分隔，便于本地测试。"""
    with open(path, "r", encoding="utf-8") as handle:
        content = handle.read()
    blocks = re.split(r"^-{3,}\s*$", content, flags=re.MULTILINE)
    messages = []
    for index, block in enumerate(blocks, 1):
        block = block.strip("\r\n")
        if not block.strip():
            continue
        messages.append(("block-%d" % index, block))
    return messages


def emit_annotations(failures):
    """输出 GitHub Actions 注解。commit 规范错误没有文件行号，只带标题。"""
    for sha, message, errors in failures:
        for one_error in errors:
            print(
                "::error title=commit message::%s (%s): %s"
                % (sha[:12], message.splitlines()[0], one_error)
            )


def build_arg_parser():
    parser = argparse.ArgumentParser(
        description="Check commit messages against Conventional Commits."
    )
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--rev-range", metavar="A..B", help="check commits in this range")
    source.add_argument(
        "--messages-file",
        metavar="FILE",
        help="check messages from a file, separated by a line of '---'",
    )
    parser.add_argument(
        "--github-annotations",
        dest="annotations",
        action="store_true",
        default=None,
        help="force GitHub Actions annotations",
    )
    parser.add_argument(
        "--no-github-annotations",
        dest="annotations",
        action="store_false",
        help="disable GitHub Actions annotations",
    )
    return parser


def main(argv=None):
    args = build_arg_parser().parse_args(argv)

    if args.annotations is None:
        annotations_enabled = os.environ.get("GITHUB_ACTIONS", "").lower() == "true"
    else:
        annotations_enabled = args.annotations

    if args.rev_range:
        commits = read_range_messages(args.rev_range)
        scope_desc = "range %s" % args.rev_range
    else:
        commits = read_messages_file(args.messages_file)
        scope_desc = "file %s" % args.messages_file

    if not commits:
        print("No commit to check (%s), skip." % scope_desc)
        return 0

    failures = []
    for sha, message in commits:
        errors = check_message(message)
        if errors:
            failures.append((sha, message, errors))

    for sha, message, errors in failures:
        header = message.splitlines()[0] if message.splitlines() else ""
        print("ERROR %s: %r" % (sha[:12], header))
        for one_error in errors:
            print("      - %s" % one_error)

    if annotations_enabled and failures:
        emit_annotations(failures)

    print("checked %d commit(s) (%s); %d non-conforming" % (len(commits), scope_desc, len(failures)))

    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
