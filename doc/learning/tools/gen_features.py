# -*- coding: utf-8 -*-
"""gen_features.py — 生成 doc/learning/features/ 逐特性文档（每套件一 .md + README 索引）。
输入: tools/data/case_extract.json (由 collect.py 生成)
用法: python gen_features.py   (在 doc/learning/tools 下执行)
"""
import json, os, re
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
DOC = os.path.abspath(os.path.join(HERE, ".."))
DATA = os.path.join(HERE, "data")

d = json.load(open(os.path.join(DATA, "case_extract.json"), encoding="utf-8"))
S = json.load(open(os.path.join(DATA, "stats.json"), encoding="utf-8"))
FEAT_DIR = os.path.join(DOC, "features")
INDEX = os.path.join(FEAT_DIR, "README.md")

def safe_name(s):
    s = re.sub(r'[<>:"/\\|?*]', "_", s)
    s = s.strip().rstrip(".")
    return s or "unnamed"

CAT_NAMES = {
    "cli-test": "命令行与服务域（cli-test）",
    "smoke-test": "冒烟域（smoke-test）",
    "feature-test": "特性域（feature-test）",
    "system-test": "系统域（system-test）",
    "embedded-test": "嵌入式域（embedded-test）",
    "doc-test": "文档域（doc-test）",
    "security_test": "安全域（security_test）",
    "testsuite": "模板域（testsuite）",
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
    return "other"

def cat_name(s):
    return CAT_NAMES.get(derive_category(s), "其他（未归入正式域）")

def fmt_constraint(c):
    if not c:
        return "无"
    parts = []
    for k, v in c.items():
        if isinstance(v, list):
            v = ",".join(str(x) for x in v)
        parts.append(f"{k} = {v}")
    return "；".join(parts)

def mk_feature_doc(s):
    L = []
    A = L.append
    A(f"# {s['suite']}")
    A("")
    A("> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。")
    A("")
    A("## 元信息")
    A("")
    A("| 项 | 值 |")
    A("|----|----|")
    A(f"| 测试域 | {cat_name(s)} |")
    A(f"| 套件路径 | `{s['path']}` |")
    A(f"| 注册用例数 | {s['n_cases']} |")
    A(f"| 环境约束 | {fmt_constraint(s.get('constraints'))} |")
    A("")
    cons = s.get("constraints")
    if cons:
        A("> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。")
        A("")
    A("## 用例清单（测试点）")
    A("")
    A("| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |")
    A("|--------|------|------|-------:|------|------|------|")
    for c in s["cases"]:
        funcs = "/".join(c.get("functions", [])) or "—"
        checks = len(c.get("checks", []))
        dnf = "✔" if c.get("dnf_install") else ""
        ssh = "✔" if c.get("ssh_use") else ""
        to = (c.get("timeout") or ["—"])[0] if c.get("timeout") else ""
        A(f"| {c['name']} | {c.get('desc','')} | {funcs} | {checks} | {dnf} | {ssh} | {to} |")
    A("")
    # 断言明细
    A("### 断言与命令明细")
    A("")
    for c in s["cases"]:
        checks = c.get("checks", [])
        hint = c.get("cmds_hint", [])
        A(f"#### {c['name']}")
        A("")
        A(f"- 描述：{c.get('desc','')}")
        if c.get("functions"):
            A(f"- 函数：`{', '.join(c['functions'])}`")
        if checks:
            A(f"- 断言（{len(checks)} 条）：")
            A("")
            A("```")
            for ch in checks[:12]:
                A(f"  {ch}")
            if len(checks) > 12:
                A(f"  ... 共 {len(checks)} 条（其余见源脚本）")
            A("```")
            A("")
        if hint:
            A(f"- 涉及命令：{', '.join(f'{h[0]}×{h[1]}' if len(h)>1 else h[0] for h in hint)}")
            A("")
    return "\n".join(L)

os.makedirs(FEAT_DIR, exist_ok=True)
by_cat = defaultdict(list)
for s in d:
    by_cat[derive_category(s)].append(s)

written = 0
for s in d:
    fn = os.path.join(FEAT_DIR, safe_name(s["suite"]) + ".md")
    with open(fn, "w", encoding="utf-8") as f:
        f.write(mk_feature_doc(s))
    written += 1

# ---- 索引 README ----
L = []
A = L.append
A("# features/ 逐特性文档索引")
A("")
A(f"> 本目录按套件生成 {S['suites_total']} 份特性文档（每套件一份，脚本生成，100% 代码事实）。与 `09 附录-全量测试套清单` 配合：附录看全局清单，本目录看单特性细节（用例描述/断言/命令）。")
A("")
A("## 目录")
A("")
for cat in sorted(by_cat, key=lambda x: -len(by_cat[x])):
    sl = sorted(by_cat[cat], key=lambda x: x["suite"].lower())
    n_c = sum(s["n_cases"] for s in sl)
    A(f"### {cat_name(sl[0])}（{len(sl)} 套件 / {n_c} 用例）")
    A("")
    for s in sl:
        cons = " ⚠️" if s.get("constraints") else ""
        A(f"- [{s['suite']}]({safe_name(s['suite'])}.md)（{s['n_cases']} 用例）{cons}")
    A("")
with open(INDEX, "w", encoding="utf-8") as f:
    f.write("\n".join(L))

print(f"generated {written} feature docs + README index")
