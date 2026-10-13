# -*- coding: utf-8 -*-
"""render.py — 用 tools/data/stats.json + tools/templates/ 渲染 doc/learning 各章节。
被替换的章节: README / 00 / 06 / 07 / 08 / 10 / 11 (其余 01-05 为人工精读章节，不在此渲染)。
用法: python render.py   (在 doc/learning/tools 下执行)
"""
import json, os, re

HERE = os.path.dirname(os.path.abspath(__file__))
DOC = os.path.abspath(os.path.join(HERE, ".."))          # doc/learning
TPL = os.path.abspath(os.path.join(HERE, "..", "templates"))  # doc/learning/templates
DATA = os.path.join(HERE, "data")

S = json.load(open(os.path.join(DATA, "stats.json"), encoding="utf-8"))
tot = S["cases_total"]
pct = lambda a, b: round(a / b * 100, 1) if b else 0

ctx = {}

# ---------- 标量 ----------
for k in ["suites_total", "cases_total", "unique_cases", "dup_names", "extra_refs",
          "script_files", "orphans", "orphan_case", "orphan_lib", "sh_cases", "py_cases",
          "desc_cases", "check_cases", "dnf_cases", "ssh_cases", "timeout_cases",
          "config_params", "pre_test", "post_test", "run_test", "smoke_overlap",
          "missing_cases", "suites_with_constraints", "smoke_cases", "smoke_basic_os_cases",
          "smoke_syscare_cases", "cli_dirs", "security_themes", "commit_short", "branch"]:
    ctx[k.upper()] = S[k]
ctx["SMOKE_SET"] = S["smoke_cases"]
ctx["SMOKE_BASIC_OS"] = S["smoke_basic_os_cases"]
ctx["SMOKE_SYSCARE"] = S["smoke_syscare_cases"]
ctx["ANALYSIS_COMMIT"] = S["commit_short"]
ctx["LAST_COMMIT"] = f"{S['commit_short']} {S['last_subject']}".strip()
ctx["PCT_CHECK"] = pct(S["check_cases"], tot)
ctx["PCT_DNF"] = pct(S["dnf_cases"], tot)
ctx["PCT_SSH"] = pct(S["ssh_cases"], tot)
ctx["PCT_TIMEOUT"] = pct(S["timeout_cases"], tot)
ctx["PCT_PRE"] = pct(S["pre_test"], tot)
ctx["PCT_POST"] = pct(S["post_test"], tot)
ctx["PCT_SH"] = round(S["sh_cases"] / (S["sh_cases"] + S["py_cases"]) * 100, 2)
ctx["AVG_CASES_PER_SUITE"] = round(tot / S["suites_total"], 1)
ctx["MISSING_SECSCANNER"] = S.get("missing_top", {}).get("secscanner", 0)
ctx["MISSING_KATA"] = S.get("missing_top", {}).get("kata-containers", 0)
ctx["ORPHAN_FEATURE"] = S.get("orphan_by", {}).get("feature-test", 0)

D = S["domains"]
for name, c_ in [("CLI", "cli-test"), ("SMOKE", "smoke-test"), ("FEATURE", "feature-test"),
                 ("SYSTEM", "system-test"), ("EMBEDDED", "embedded-test"), ("DOC", "doc-test"),
                 ("SECURITY", "security_test"), ("TESTSUITE", "testsuite")]:
    ctx[f"{name}_SUITES"] = D[c_]["suites"]
    ctx[f"{name}_CASES"] = D[c_]["cases"]

T = S["types"]
for key, label in [("TYPE_FUNC", "功能/命令测试"), ("TYPE_SEC", "安全测试"), ("TYPE_CONF", "配置管理"),
                   ("TYPE_REL", "可靠性/异常恢复"), ("TYPE_COMPAT", "兼容性/多版本"), ("TYPE_PERF", "性能/压测")]:
    ctx[key] = T.get(label, 0)
    ctx[key + "_PCT"] = pct(T.get(label, 0), tot)

CS, CC = S["cons_suite"], S["cons_case"]
ctx["CONS_SUITE_MN"] = CS.get("machine num", 0)
ctx["CONS_SUITE_MT"] = CS.get("machine type", 0)
ctx["CONS_SUITE_AD"] = CS.get("add disk", 0)
ctx["CONS_SUITE_NIC"] = CS.get("add network interface", 0)
ctx["CONS_CASE_MN"] = CC.get("machine num", 0)
ctx["CONS_CASE_MT"] = CC.get("machine type", 0)
ctx["CONS_CASE_AD"] = CC.get("add disk", 0)
ctx["CONS_CASE_NIC"] = CC.get("add network interface", 0)
ctx["PCT_CASE_MN"] = pct(CC.get("machine num", 0), tot)
ctx["PCT_CASE_MT"] = pct(CC.get("machine type", 0), tot)
ctx["PCT_CASE_AD"] = pct(CC.get("add disk", 0), tot)
ctx["PCT_CASE_NIC"] = pct(CC.get("add network interface", 0), tot)

SUBJ = S["subject_repo"]
subj_key = {
    "编译器与开发工具": "SUBJ_DEV", "安全与认证": "SUBJ_SEC", "文件系统与存储": "SUBJ_FS",
    "命令行与Shell工具": "SUBJ_SHELL", "嵌入式": "SUBJ_EMB", "网络工具": "SUBJ_NET",
    "桌面与图形": "SUBJ_DESK", "监控与运维": "SUBJ_MON", "DNS与网络服务": "SUBJ_DNS",
    "数据库": "SUBJ_DB", "虚拟化与容器": "SUBJ_VIRT", "分布式与集群": "SUBJ_CLUSTER",
    "Web服务器与应用": "SUBJ_WEB", "系统服务与初始化": "SUBJ_SYS", "系统管理工具": "SUBJ_ADMIN",
    "包管理与仓库工具": "SUBJ_PKG", "文本处理": "SUBJ_TEXT", "内核与驱动": "SUBJ_KERNEL",
    "多媒体": "SUBJ_MEDIA", "驱动专项(driver_test)": "SUBJ_DRV", "办公与文档": "SUBJ_OFFICE",
    "办公/图形混合-其他": "SUBJ_MIX", "其他/第三方软件包": "SUBJ_OTHER",
}
for k, v in subj_key.items():
    ctx[v] = SUBJ.get(k, 0)

# ---------- 表格串 ----------
TAB = {}

# 00 章: 测试域规模表
def domain_row00(name, su, ca, desc):
    return f"| {name} | {su} | {ca} | {desc} |"
rows = [
    ("cli-test", ctx["CLI_SUITES"], ctx["CLI_CASES"], "软件包/命令行/服务"),
    ("smoke-test", ctx["SMOKE_SUITES"], ctx["SMOKE_CASES"], f"OS 冒烟回归（含 `smoke` 全量集合 {ctx['SMOKE_SET']} 例、`smoke-syscare`）"),
    ("feature-test", ctx["FEATURE_SUITES"], ctx["FEATURE_CASES"], "openEuler 特性"),
    ("system-test", ctx["SYSTEM_SUITES"], ctx["SYSTEM_CASES"], "文件系统/网络/存储/内核等"),
    ("embedded-test", ctx["EMBEDDED_SUITES"], ctx["EMBEDDED_CASES"], "openEuler Embedded"),
    ("doc-test", ctx["DOC_SUITES"], ctx["DOC_CASES"], "官方指南验证"),
    ("security_test", ctx["SECURITY_SUITES"], ctx["SECURITY_CASES"], f"安全加固（实际脚本按 {ctx['SECURITY_THEMES']} 个安全主题目录组织）"),
    ("testsuite", ctx["TESTSUITE_SUITES"], ctx["TESTSUITE_CASES"], "框架模板示例"),
    ("driver_test", "—", "—", "Excel 驱动的驱动用例（未走 suite2cases 注册）"),
]
TAB["DOMAIN_TABLE_00"] = "\n".join([domain_row00(*r) for r in rows])

# 06 章: 域规模表(带目录与合计)
def domain_row06(name, dname, su, ca, desc):
    return f"| **{name}** | `testcases/{dname}/` | {su} | {ca} | {desc} |"
rows6 = [
    ("cli-test", "cli-test", ctx["CLI_SUITES"], ctx["CLI_CASES"], "**主体域**：以\"一个软件包/组件 = 一个套件\"组织的命令行/服务/配置测试"),
    ("smoke-test", "smoke-test", ctx["SMOKE_SUITES"], ctx["SMOKE_CASES"], f"冒烟测试：最小可引导系统 + 关键组件冒烟（含 `smoke` 全量集合 {ctx['SMOKE_SET']} 例、`smoke-syscare`）"),
    ("feature-test", "feature-test", ctx["FEATURE_SUITES"], ctx["FEATURE_CASES"], "特性专项（pkgship/A-Tune/gazelle/atune 等系统级特性）"),
    ("system-test", "system-test", ctx["SYSTEM_SUITES"], ctx["SYSTEM_CASES"], "系统级/集成测试（文件系统 FS_* 系列、多机集群、内核）"),
    ("embedded-test", "embedded-test", ctx["EMBEDDED_SUITES"], ctx["EMBEDDED_CASES"], "openEuler Embedded 嵌入式（QEMU/板卡）"),
    ("doc-test", "doc-test", ctx["DOC_SUITES"], ctx["DOC_CASES"], "文档与软件包配套示例测试（admin_guide 等）"),
    ("security_test", "security_test", ctx["SECURITY_SUITES"], ctx["SECURITY_CASES"], f"安全专题（按 {ctx['SECURITY_THEMES']} 个主题子目录组织，见 08 章）"),
    ("testsuite", "testsuite", ctx["TESTSUITE_SUITES"], ctx["TESTSUITE_CASES"], "新套件开发模板（sh/py/bash 三种样例）"),
    ("driver_test", "driver_test", "—", "—", "驱动测试素材（无 suite2cases，由 Excel 生成，见 10 章）"),
]
TAB["DOMAIN_TABLE_06"] = "\n".join([domain_row06(*r) for r in rows6])
TAB["DOMAIN_TABLE_06_SUM"] = f"| **合计** | | **{ctx['SUITES_TOTAL']}** | **{ctx['CASES_TOTAL']}** | 唯一用例名 {ctx['UNIQUE_CASES']}，重复 {ctx['DUP_NAMES']} |"

# 07 章: 类型表
type_rows = [
    ("功能/命令测试", ctx["TYPE_FUNC"], ctx["TYPE_FUNC_PCT"], "绝大多数字符串：命令选项、配置文件、服务启停、API 行为"),
    ("安全测试", ctx["TYPE_SEC"], ctx["TYPE_SEC_PCT"], "权限(ACL/PAM/SELinux)、加密(TLS/OpenSSL/加密套件)、审计(audit)、密钥管理"),
    ("配置管理", ctx["TYPE_CONF"], ctx["TYPE_CONF_PCT"], "config 子命令、配置文件合法性、服务 reload"),
    ("可靠性/异常恢复", ctx["TYPE_REL"], ctx["TYPE_REL_PCT"], "异常输入、进程崩溃、重启恢复、错误路径（FS_Negative 全套即此类型）"),
    ("兼容性/多版本", ctx["TYPE_COMPAT"], ctx["TYPE_COMPAT_PCT"], "版本变体套件、多架构断言、新旧命令对照"),
    ("性能/压测", ctx["TYPE_PERF"], ctx["TYPE_PERF_PCT"], "LTP/UNIXBENCH/sysbench、fio/iozone、webbench/iperf/qperf"),
]
TAB["TYPE_TABLE"] = "\n".join(
    f"| {n} | {v} | {p}% | {d} |" for n, v, p, d in type_rows)

# 07 章: 主题分类表
subj_rows = [
    ("编译器与开发工具", ctx["SUBJ_DEV"], "gcc/binutils/glibc/cmake/valgrind/python", "多为 cli-test"),
    ("安全与认证", ctx["SUBJ_SEC"], "audit/openssl/cryptsetup/clevis/crypto-policies", "多为 cli-test"),
    ("文件系统与存储", ctx["SUBJ_FS"], "FS_Device/FS_File/FS_FileSystem/FS_IO/FS_Negative", "system-test"),
    ("命令行与 Shell 工具", ctx["SUBJ_SHELL"], "coreutils/bash/curl/diffutils/util-linux", "cli-test"),
    ("嵌入式", ctx["SUBJ_EMB"], "embedded_os_basic_test/embedded_mcs_rpi4_test", "embedded-test"),
    ("网络工具", ctx["SUBJ_NET"], "NetworkManager/bridge-utils/arptables/bluez", "cli-test"),
    ("桌面与图形", ctx["SUBJ_DESK"], "ImageMagick/GraphicsMagick/fontconfig/OpenEXR", "cli-test"),
    ("监控与运维", ctx["SUBJ_MON"], "grafana/cockpit/htop/alertmanager/aops", "cli-test"),
    ("DNS 与网络服务", ctx["SUBJ_DNS"], "bind/chrony/dnsmasq/libiscsi/samba", "cli-test"),
    ("数据库", ctx["SUBJ_DB"], "mariadb/mysql/etcd/leveldb/redis/389-ds-base", "cli-test"),
    ("虚拟化与容器", ctx["SUBJ_VIRT"], "containerd/cri-o/criu/libvirt/lxc", "cli-test"),
    ("分布式与集群", ctx["SUBJ_CLUSTER"], "corosync/dlm/hadoop/kubernetes/pacemaker", "cli-test/system-test"),
    ("Web 服务器与应用", ctx["SUBJ_WEB"], "httpd/haproxy/jetty/lighttpd", "cli-test"),
    ("系统服务与初始化", ctx["SUBJ_SYS"], "dbus/polkit/irqbalance/syscare", "cli-test"),
    ("系统管理工具", ctx["SUBJ_ADMIN"], "anaconda/dmidecode/hwloc/pam", "cli-test"),
    ("包管理与仓库", ctx["SUBJ_PKG"], "dnf/createrepo_c/libreport/PackageKit", "cli-test"),
    ("文本处理", ctx["SUBJ_TEXT"], "asciidoc/jq/poppler/qpdf", "cli-test"),
    ("内核与驱动", ctx["SUBJ_KERNEL"], "kernel/etmem/elasticMem", "system-test"),
    ("多媒体", ctx["SUBJ_MEDIA"], "ffmpeg/flac/wavpack", "cli-test"),
    ("驱动专项", ctx["SUBJ_DRV"], "leptonica（+driver_test 素材域）", "driver_test"),
    ("办公与文档", ctx["SUBJ_OFFICE"], "texlive", "doc-test"),
    ("**其他/第三方软件包**", ctx["SUBJ_OTHER"], "389-ds-base/A-Tune/Kmesh/ModemManager...", "逐包一特性"),
]
TAB["SUBJECT_TABLE"] = "\n".join(f"| {n} | {v} | {r} | {q} |" for n, v, r, q in subj_rows)

# 07 章: 约束表
TAB["CONSTRAINT_TABLE"] = "\n".join([
    f"| `machine num` | 需要的机器数（≥2 即多机） | {ctx['CONS_SUITE_MN']} 套件 | {ctx['CONS_CASE_MN']} 用例 | {ctx['PCT_CASE_MN']}% |",
    f"| `machine type` | 机器类型要求（physical/kvm） | {ctx['CONS_SUITE_MT']} 套件 | {ctx['CONS_CASE_MT']} 用例 | {ctx['PCT_CASE_MT']}% |",
    f"| `add disk` | 需要额外（未挂载）磁盘 | {ctx['CONS_SUITE_AD']} 套件 | {ctx['CONS_CASE_AD']} 用例 | {ctx['PCT_CASE_AD']}% |",
    f"| `add network interface` | 需要额外网卡 | {ctx['CONS_SUITE_NIC']} 套件 | {ctx['CONS_CASE_NIC']} 用例 | {ctx['PCT_CASE_NIC']}% |",
])

# 07 章: 手法因子表
TAB["TOOL_TABLE_07"] = "\n".join([
    "| CHECK_RESULT 断言 | " + str(ctx["CHECK_CASES"]) + " | 断言验收：命令退出码/文件内容/服务状态 |",
    "| DNF_INSTALL 前置装包 | " + str(ctx["DNF_CASES"]) + " | 先装被测包再测（无依赖则跳过） |",
    f"| pre_test/post_test | {ctx['PRE_TEST']}/{ctx['POST_TEST']} | 环境准备与清理（回滚安装、删文件、重启服务） |",
    "| SSH 远端操作 | " + str(ctx["SSH_CASES"]) + " | 多机/嵌入式/主备测试 |",
    "| config_params 参数化 | " + str(ctx["CONFIG_PARAMS"]) + " | 同一脚本多配置复用 |",
    "| EXECUTE_T 超时覆盖 | " + str(ctx["TIMEOUT_CASES"]) + " | 长任务（压测/编译/大文件拷贝） |",
])

# 08 章: L1→L2 表
spd = S["subject_per_domain"]
def fmt_l2(c):
    return "、".join(f"{k}({v})" for k, v in spd.get(c, {}).items()) or "—"
cli_l2 = fmt_l2("cli-test")
sys_l2 = fmt_l2("system-test")
emb_l2 = fmt_l2("embedded-test")
sys_other = spd.get("system-test", {}).get("其他/第三方软件包", 0)
fs_sys = spd.get("system-test", {}).get("文件系统与存储", 0)
emb_subj = spd.get("embedded-test", {}).get("嵌入式", 0)
emb_other = spd.get("embedded-test", {}).get("其他/第三方软件包", 0)
feat_net = spd.get("feature-test", {}).get("网络工具", 0)
feat_emb = spd.get("feature-test", {}).get("嵌入式", 0)
feat_other = spd.get("feature-test", {}).get("其他/第三方软件包", 0)
TAB["L2_TABLE"] = "\n".join([
    f"| cli-test（{ctx['CLI_SUITES']}） | {cli_l2} |",
    f"| system-test（{ctx['SYSTEM_SUITES']}） | 文件系统与存储({fs_sys})、其他/第三方软件包({sys_other})（LTP/POSIX/网络/存储等系统级套件，关键词未命中） |",
    f"| feature-test（{ctx['FEATURE_SUITES']}） | 系统特性专项：pkgship(8 子套件)、gazelle、A-Tune、StratoVirt、sysSentry、secscanner 等（按关键词仅命中 2：网络工具 {feat_net}、嵌入式 {feat_emb}，其余 {feat_other} 归其他） |",
    f"| embedded-test（{ctx['EMBEDDED_SUITES']}） | 嵌入式({emb_subj})、其他({emb_other}) |",
    f"| smoke-test（{ctx['SMOKE_SUITES']}） | 最小系统冒烟：baseinfo/ssh/分区/系统运行级（含 `smoke` 全量集合 {ctx['SMOKE_SET']} 例、`smoke-syscare`；{ctx['SMOKE_SUITES']} 套件均未命中 L2 关键词，归其他） |",
    f"| doc-test（{ctx['DOC_SUITES']}） | 文档示例（admin_guide 92 例等；按关键词归其他） |",
    f"| security_test（1 套件 71 例） | 安全专题（{ctx['SECURITY_THEMES']} 主题目录；套件名未命中关键词） |",
    "| testsuite（1） | 模板样例 |",
    "| driver_test | 驱动素材（Excel→JSON 生成，无 suite2cases） |",
])

# 11 章: 孤儿按域表
_orphan_order = ["feature-test", "cli-test", "smoke-test", "embedded-test",
                 "system-test", "doc-test", "security_test", "testsuite"]
TAB["ORPHAN_TABLE"] = "\n".join(
    f"| {k} | {S['orphan_by'].get(k, 0)} |" for k in _orphan_order)

# ---------- 渲染 ----------
TPL_FILES = ["README.md", "00-项目总览.md", "06-测试自动化总览.md",
             "07-多维度测试分析.md", "08-测试特性树.md",
             "10-新用例与新测试套贡献指南.md", "11-代码扫描问题汇总.md"]

def render(tpl_name, out_name):
    with open(os.path.join(TPL, tpl_name), encoding="utf-8") as fh:
        t = fh.read()
    out = t
    for k, v in ctx.items():
        out = out.replace("{{" + k + "}}", str(v))
    for k, v in TAB.items():
        out = out.replace("{{" + k + "}}", v)
    leftovers = re.findall(r"\{\{[A-Z0-9_]+\}\}", out)
    if leftovers:
        print(f"WARN [{tpl_name}] 未替换占位符: {sorted(set(leftovers))}")
    with open(os.path.join(DOC, out_name), "w", encoding="utf-8") as fh:
        fh.write(out)
    print(f"rendered {out_name}")

for fn in TPL_FILES:
    render(fn, fn)

print("done.")
