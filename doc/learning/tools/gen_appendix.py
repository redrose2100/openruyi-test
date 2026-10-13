# -*- coding: utf-8 -*-
"""gen_appendix.py — 生成 doc/learning/09-附录-全量测试套清单.md（全量枚举）。
输入: tools/data/case_extract.json (由 collect.py 生成)
用法: python gen_appendix.py   (在 doc/learning/tools 下执行)
"""
import json, os, re
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
DOC = os.path.abspath(os.path.join(HERE, ".."))
DATA = os.path.join(HERE, "data")

d = json.load(open(os.path.join(DATA, "case_extract.json"), encoding="utf-8"))
S = json.load(open(os.path.join(DATA, "stats.json"), encoding="utf-8"))

CAT_ORDER = ["cli-test", "smoke-test", "feature-test", "system-test",
             "embedded-test", "doc-test", "security_test", "testsuite", "其他/未分类"]
CAT_NAMES = {
    "cli-test": "命令行与服务域（cli-test）",
    "smoke-test": "冒烟域（smoke-test）",
    "feature-test": "特性域（feature-test）",
    "system-test": "系统域（system-test）",
    "embedded-test": "嵌入式域（embedded-test）",
    "doc-test": "文档域（doc-test）",
    "security_test": "安全域（security_test）",
    "testsuite": "模板域（testsuite）",
    "其他/未分类": "其他（未归入正式域）",
}

def derive_category(s):
    """优先用已标 category；为 '?' 时按 suite2cases path 中 testcases/ 后的首段推导"""
    c = s["category"]
    if c and c in CAT_NAMES:
        return c
    m = re.search(r"testcases/([^/$]+)", s.get("path", ""))
    if m:
        d_ = m.group(1)
        if d_ in CAT_NAMES:
            return d_
        if d_ == "security_test":
            return "security_test"
    return "其他/未分类"

by_cat = defaultdict(list)
for s in d:
    by_cat[derive_category(s)].append(s)
for cat in list(by_cat):
    by_cat[cat].sort(key=lambda x: x["suite"].lower())

def fmt_constraint(c):
    if not c:
        return "—"
    parts = []
    for k, v in c.items():
        if isinstance(v, list):
            v = ",".join(str(x) for x in v)
        parts.append(f"{k}={v}")
    return "；".join(parts)

def truncate(s, n=90):
    s = (s or "").strip()
    return s if len(s) <= n else s[: n - 1] + "…"

lines = []
A = lines.append
A(f"# 09 附录：全量测试套清单（{S['suites_total']} 套件 / {S['cases_total']} 用例全枚举）")
A("")
A(f"> 本附录由 `suite2cases/`（{S['suites_total']} 个 JSON）与 `case_extract.json` 全量解析生成，**零遗漏**。每套件含：路径、注册用例数、环境约束（如有）、用例清单（用例名 + @Desc 摘要）。逐用例的断言/命令细节见 `features/` 逐特性文档。")
A("")

# ---- 总览索引表 ----
A("## 目录索引")
A("")
A("| 测试域 | 套件数 | 用例数 | 说明 |")
A("|--------|-------:|-------:|------|")
tot_s = tot_c = 0
for cat in CAT_ORDER:
    sl = by_cat.get(cat, [])
    if not sl:
        continue
    n_s = len(sl)
    n_c = sum(s["n_cases"] for s in sl)
    tot_s += n_s
    tot_c += n_c
    A(f"| {cat} | {n_s} | {n_c} | [跳转](#{cat}) |")
A(f"| **合计** | **{tot_s}** | **{tot_c}** | |")
A("")
A("| 编号 | 套件名 | 测试域 | 用例数 |")
A("|-----:|--------|--------|-------:|")
idx = 0
for cat in CAT_ORDER:
    for s in by_cat.get(cat, []):
        idx += 1
        A(f"| {idx} | {s['suite']} | {cat} | {s['n_cases']} |")
A("")

# ---- 各域明细 ----
for cat in CAT_ORDER:
    sl = by_cat.get(cat, [])
    if not sl:
        continue
    n_c = sum(s["n_cases"] for s in sl)
    A(f"## {CAT_NAMES.get(cat, cat)}（{len(sl)} 套件 / {n_c} 用例）")
    A("")
    for s in sl:
        A(f"### {s['suite']}")
        A("")
        A(f"- 路径：`{s['path']}`")
        A(f"- 注册用例数：{s['n_cases']}")
        cons = fmt_constraint(s.get("constraints"))
        A(f"- 环境约束：{cons}")
        A("")
        if s.get("constraints"):
            A("> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检，不满足自动 skipped。")
            A("")
        A("| 用例名 | 描述（@Desc 摘要） |")
        A("|--------|--------------------|")
        for c in s["cases"]:
            A(f"| {c['name']} | {truncate(c.get('desc',''))} |")
        A("")

OUT = os.path.join(DOC, "09-附录-全量测试套清单.md")
with open(OUT, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))
print(f"written {OUT}, {len(lines)} lines")
