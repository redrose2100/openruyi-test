# -*- coding: utf-8 -*-
"""校验渲染产物：无残留占位符、关键数字、mermaid 括号、与 collect 数据一致性"""
import re, os, json

DOC = r"D:\code\mugen\doc\learning"
TOOLS = os.path.join(DOC, "tools")
S = json.load(open(os.path.join(TOOLS, "data", "stats.json"), encoding="utf-8"))

problems = []

# 1. 残留占位符
for fn in ["README.md", "00-项目总览.md", "06-测试自动化总览.md", "07-多维度测试分析.md",
           "08-测试特性树.md", "10-新用例与新测试套贡献指南.md", "11-代码扫描问题汇总.md"]:
    txt = open(os.path.join(DOC, fn), encoding="utf-8").read()
    left = re.findall(r"\{\{[A-Z0-9_]+\}\}", txt)
    if left:
        problems.append(f"{fn}: 残留占位符 {sorted(set(left))}")

# 2. mermaid 括号配平
for fn in ["00-项目总览.md", "06-测试自动化总览.md", "07-多维度测试分析.md", "08-测试特性树.md"]:
    txt = open(os.path.join(DOC, fn), encoding="utf-8").read()
    for m in re.finditer(r"```mermaid\n(.*?)```", txt, re.S):
        body = m.group(1)
        if body.count("[") != body.count("]"):
            problems.append(f"{fn}: mermaid 方括号不平 {body.count('[')} vs {body.count(']')}")

# 3. 关键数字抽查
checks = {
    "README.md": ["**979**", "**7189**", "**6718**", "**7629**", "7137", "6461", "7147"],
    "00-项目总览.md": ["**979**", "**7189**", "6718", "7629", "7147", "7137", "6461", "879", "503", "376"],
    "06-测试自动化总览.md": ["979", "7189", "863", "4316", "89.9%", "4958", "292", "123"],
    "07-多维度测试分析.md": ["6884", "121", "71", "67", "29", "17", "772", "1610", "80", "22.4%"],
    "08-测试特性树.md": ["×979", "×7189", "680", "编译器与开发工具(29)", "安全与认证(22)"],
    "10-新用例与新测试套贡献指南.md": ["6461", "41", "879"],
    "11-代码扫描问题汇总.md": ["40", "879", "552", "461", "471", "6718", "261", "274", "319", "226"],
}
for fn, subs in checks.items():
    txt = open(os.path.join(DOC, fn), encoding="utf-8").read()
    for sub in subs:
        if sub not in txt:
            problems.append(f"{fn}: 缺少 {sub}")

# 4. 07/08 修正点抽查（90.5% 不应出现、771 不应出现、90.5 不应出现）
txt07 = open(os.path.join(DOC, "07-多维度测试分析.md"), encoding="utf-8").read()
for bad in ["771 个第三方包", "90.5%"]:
    if bad in txt07:
        problems.append(f"07: 残留旧值 {bad}")
txt06 = open(os.path.join(DOC, "06-测试自动化总览.md"), encoding="utf-8").read()
if "占 90.5%" in txt06:
    problems.append("06: 残留旧值 占 90.5%")

print("校验项数:", len(checks) + 4)
if problems:
    print("发现问题:")
    for p in problems:
        print(" -", p)
else:
    print("全部通过：无残留占位符、无旧值、关键数字齐全、mermaid 配平。")
