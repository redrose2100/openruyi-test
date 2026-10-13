# -*- coding: utf-8 -*-
"""collect.py — 扫描仓库，重新生成 doc/learning/tools/data/ 下全部数据快照。
产物:
  case_extract.json          逐用例事实(@Desc/函数/断言/命令/约束)
  suite_catalog_expanded.json 逐套件(路径/域/用例名)
  subject_map.json           全库+按域 主题分类
  stats.json                 全部聚合统计(供 render.py 填模板)
说明: 与 doc/learning 配套的可复现流水线; 修改本仓库(testcases/suite2cases/libs)后重跑。
"""
import json, os, re, collections, glob

REPO = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", ".."))  # 仓库根 doc/learning/tools -> ../../..
DATA_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data")
os.makedirs(DATA_DIR, exist_ok=True)

SUITE_DIR = os.path.join(REPO, "suite2cases")
TESTCASES = os.path.join(REPO, "testcases")

# ---------------- 1. 扫描套件 JSON ----------------
suite_files = sorted(glob.glob(os.path.join(SUITE_DIR, "*.json")))
catalog = []
for sf in suite_files:
    with open(sf, encoding="utf-8") as fh:
        j = json.load(fh)
    name = os.path.splitext(os.path.basename(sf))[0]
    path = j.get("path", "$OET_PATH/testcases")
    cases = []
    for c in j.get("cases", []):
        if isinstance(c, dict):
            cases.append({"name": c.get("name", "")})
        else:
            cases.append({"name": c})
    cons = {k: v for k, v in j.items() if k not in ("path", "cases")}
    # 域: path 中 testcases/ 后的首段
    m = re.search(r"testcases/([^/$]+)", path)
    cat = m.group(1) if m else "?"
    catalog.append({
        "suite": name, "file": sf, "path": path,
        "path_expanded": path.replace("$OET_PATH", REPO).replace("${OET_PATH}", REPO).replace("\\", "/"),
        "category": cat, "n_cases": len(cases), "cases": [c["name"] for c in cases],
        "constraints": cons,
    })

# ---------------- 2. 脚本索引 ----------------
file_index = collections.defaultdict(list)
all_script_files = []
for root, dirs, fs in os.walk(TESTCASES):
    for f in fs:
        if f.endswith((".sh", ".py", ".bash")):
            fp = os.path.join(root, f).replace("\\", "/")
            all_script_files.append(fp)
            file_index[os.path.splitext(f)[0]].append(fp)

# ---------------- 3. 逐用例抽取 ----------------
def extract_case(path):
    try:
        with open(path, encoding="utf-8", errors="ignore") as fh:
            text = fh.read()
    except Exception:
        return None
    info = {}
    d = re.search(r"@Desc\s*:\s*(.+)", text)
    if d:
        info["desc"] = d.group(1).strip()
    info["functions"] = re.findall(r"function\s+(\w+)\s*\(\)", text)
    info["checks"] = [c.strip() for c in re.findall(r"CHECK_RESULT\s+[^\n]*", text)]
    known = re.findall(r"(?:^|\n)\s*(?:[a-zA-Z0-9_\-./]+\s*\|)?\s*([a-zA-Z][a-zA-Z0-9_\-./]{2,})\s+-(?=[a-zA-Z0-9])", text)
    info["cmds_hint"] = list(collections.Counter(k for k in known if k not in ("echo",)).most_common(12))
    info["py_ret_checks"] = len(re.findall(r"if\s+(\w+)\s*!=\s*0\s*:", text))
    info["has_main"] = "main" in text
    info["size"] = len(text.splitlines())
    info["dnf_install"] = "DNF_INSTALL" in text
    info["ssh_use"] = ("P_SSH_CMD" in text) or ("SSH_CMD" in text) or ("ssh_cmd" in text)
    info["timeout"] = re.findall(r'EXECUTE_T="?([^"\n]+)"?', text)
    return info

per_suite = []
missing = []
for c in catalog:
    path = c["path_expanded"]
    rec = {"suite": c["suite"], "category": c["category"], "path": c["path"],
           "n_cases": c["n_cases"], "constraints": c["constraints"], "cases": []}
    jdata = {}
    with open(c["file"], encoding="utf-8") as fh:
        jdata = json.load(fh)
    for cn in c["cases"]:
        case_rec = {"name": cn}
        hits = [fp for fp in file_index.get(cn, []) if fp.startswith(path)]
        if hits:
            case_rec["file"] = hits[0]
            ex = extract_case(hits[0])
            if ex:
                case_rec.update(ex)
        else:
            case_rec["file"] = None
            missing.append((c["suite"], cn))
        for cj in jdata.get("cases", []):
            if isinstance(cj, dict) and cj.get("name") == cn:
                cc = {k: v for k, v in cj.items() if k != "name"}
                if cc:
                    case_rec["case_constraints"] = cc
                break
        rec["cases"].append(case_rec)
    per_suite.append(rec)

with open(os.path.join(DATA_DIR, "case_extract.json"), "w", encoding="utf-8") as fh:
    json.dump(per_suite, fh, ensure_ascii=False, indent=1)
with open(os.path.join(DATA_DIR, "suite_catalog_expanded.json"), "w", encoding="utf-8") as fh:
    json.dump(catalog, fh, ensure_ascii=False, indent=1)

# ---------------- 4. 聚合统计 ----------------
S = collections.defaultdict(lambda: [0, 0])   # 域 -> [套件, 用例]
for c in catalog:
    S[c["category"]][0] += 1
    S[c["category"]][1] += c["n_cases"]

names = collections.Counter(cn for c in catalog for cn in c["cases"])
dups = {k: v for k, v in names.items() if v > 1}

# 类型粗分(与 07 章口径一致: stats_dim.py 的关键词顺序匹配)
TYPE_KW = {
    "功能/命令测试": ["test", "check", "command", "cmd"],
    "性能/压测": ["perf", "performance", "benchmark", "stress", "ltp", "sysbench", "stress-ng", "fio", "iozone"],
    "可靠性/异常恢复": ["fail", "error", "exception", "recovery", "crash", "reboot", "resume", "abnormal", "negative"],
    "安全测试": ["security", "acl", "pam", "selinux", "audit", "tls", "ssl", "crypto", "encrypt", "fips", "vuln"],
    "配置管理": ["config", "conf"],
    "兼容性/多版本": ["compat", "version", "multi", "arch"],
}
def type_of(desc, suite):
    low = (desc + " " + suite).lower()
    for t, kws in TYPE_KW.items():
        for kw in kws:
            if kw in low:
                return t
    return "功能/命令测试"
type_cnt = collections.Counter()
for s in per_suite:
    for c in s["cases"]:
        type_cnt[type_of(c.get("desc", ""), s["suite"])] += 1

fn_cnt = collections.Counter()
tool_cnt = collections.Counter()
desc_cases = check_cases = dnf_cases = ssh_cases = to_cases = 0
for s in per_suite:
    for c in s["cases"]:
        for f in c.get("functions", []):
            fn_cnt[f] += 1
        if c.get("dnf_install"): dnf_cases += 1
        if c.get("ssh_use"): ssh_cases += 1
        if c.get("timeout"): to_cases += 1
        if c.get("desc"): desc_cases += 1
        if c.get("checks"): check_cases += 1

# 约束计数(套件级顶层 + 用例级)
cons_suite = collections.Counter()
cons_case = collections.Counter()
for c in catalog:
    for k in c["constraints"]:
        cons_suite[k] += 1
for s in per_suite:
    for c in s["cases"]:
        for k in (c.get("case_constraints") or {}):
            cons_case[k] += 1

# 孤儿(脚本名不在任何注册用例名集合中)
referenced = set(names)
orphans = [f for f in all_script_files if os.path.splitext(os.path.basename(f))[0] not in referenced]
orphan_case = orphan_lib = 0
re_fn = re.compile(r"^function\s+(\w+)\s*\(\)", re.M)
for fp in orphans:
    try:
        txt = open(fp, encoding="utf-8", errors="ignore").read()
    except Exception:
        txt = ""
    if "run_test" in re_fn.findall(txt):
        orphan_case += 1
    else:
        orphan_lib += 1
orphan_by = collections.Counter()
for fp in orphans:
    rel = fp[len(REPO.replace("\\", "/")) + 1:]
    parts = rel.split("/")
    orphan_by[parts[1] if len(parts) > 1 else "(testcases根)"] += 1

# smoke 重叠
def set_of(suite_name):
    for s in per_suite:
        if s["suite"] == suite_name:
            return set(c["name"] for c in s["cases"])
    return set()
smoke_overlap = len(set_of("smoke") & set_of("smoke-basic-os"))

# 主题分类
SUBJECTS = [
    ("数据库", ["389-ds", "postgresql", "mariadb", "mysql", "sqlite", "redis", "mongodb", "gaussdb", "influxdb", "cassandra", "tdengine", "opengauss", "etcd", "leveldb", "lmdb", "memcached", "libmemcached"]),
    ("Web服务器与应用", ["httpd", "nginx", "apache", "haproxy", "squid", "tomcat", "jetty", "libmicrohttpd", "lighttpd", "wordpress", "flask", "django"]),
    ("DNS与网络服务", ["bind", "dnsmasq", "named", "dhcp", "tftp", "vsftpd", "pure-ftpd", "samba", "libiscsi", "iscsitarget", "open-iscsi", "rpcbind", "chrony", "ntpdate", "libnfs", "nfs-utils"]),
    ("包管理与仓库工具", ["dnf", "createrepo", "yum", "rpmbuild", "rpmdevtools", "libreport", "packagekit", "lsb", "euler"]),
    ("系统服务与初始化", ["systemd", "udev", "crontab", "anacron", "irqbalance", "accountsservice", "polkit", "dbus", "logind", "sysv", "busybox", "syscare"]),
    ("命令行与Shell工具", ["coreutils", "gawk", "grep", "findutils", "util-linux", "which", "wget", "curl", "bash", "zsh", "ksh", "dash", "diffutils", "patch", "cpio", "unzip", "zip", "xz", "zstd", "lz4", "mlocate", "expect", "tcpdump", "iptables", "nftables", "firewalld"]),
    ("文本处理", ["asciidoc", "docbook", "linuxdoc", "qpdf", "poppler", "groff", "jq", "xslt", "libxml", "xmlstarlet", "yaml"]),
    ("安全与认证", ["selinux", "policycoreutils", "openssl", "openldap", "ldap", "krb5", "certmonger", "audit", "keyutils", "sssd", "tpm", "pkey", "ecryptfs", "cryptsetup", "luks", "clevis", "e2fsprogs", "shadow-utils", "sudo", "nss", "gnutls", "libgcrypt", "fips", "seccomp", "apparmor", "gnupg", "openssh", "cyrus-sasl", "nss_wrapper", "strongswan", "ipsec", "vpn", "scap", "libcap", "crypto-policies", "mcstrans"]),
    ("文件系统与存储", ["ext4", "xfs", "btrfs", "lvm", "multipath", "fio", "smartmontools", "smartctl", "autofs", "glusterfs", "nbd", "mdadm", "raid", "scsi", "nvme", "storcli", "e2fsprogs", "gfs", "dm-", "ceph", "blkid", "lsblk", "parted", "fdisk", "gdisk", "sfdisk", "wipefs", "hdparm", "resize2fs", "tune2fs", "fsck", "mkfs", "mount"]),
    ("虚拟化与容器", ["qemu", "kvm", "libvirt", "docker", "podman", "containerd", "cri-o", "criu", "lxc", "runc", "containernetworking", "cni", "strato", "kata", "gvisor", "guestfs", "hvisor", "iSula"]),
    ("内核与驱动", ["kernel", "driver", "kexec", "kdump", "hugepage", "zram", "etmem", "elasticMem", "irq", "numa", "sysctl"]),
    ("编译器与开发工具", ["gcc", "golang", "go-", "python", "perl", "php", "ruby", "java", "nodejs", "node-", "clang", "rust", "lua", "tcl", "cmake", "automake", "autoconf", "meson", "ninja", "git", "llvm", "glibc", "musl", "jsoncpp", "libevent", "libcurl", "libxml2", "zlib", "boost", "fmt", "spdlog", "gtest", "gperf", "gperftools", "valgrind", "strace", "ltrace", "gdb", "binutils", "objdump", "readelf", "sdk", "abseil", "assimp", "augeas", "libtool", "bison", "flex", "pkgconf", "pkg-config", "swig", "make", "libffi", "jemalloc", "libaio", "openmpi", "mpi"]),
    ("监控与运维", ["prometheus", "grafana", "zabbix", "telegraf", "aops", "sosreport", "htop", "sysstat", "sar", "webbench", "ab", "iperf", "qperf", "systemtap", "opentelemetry", "alertmanager", "amanda", "cockpit", "netdata", "nmon", "logstash", "filebeat", "snoopy", "iptraf"]),
    ("网络工具", ["NetworkManager", "nmcli", "bridge-utils", "brctl", "gazelle", "openipmi", "freeipmi", "ipmitool", "nmap", "hostname", "hostnamectl", "wpa", "wireless", "bluetooth", "bluez", "arptables", "ebtables", "keepalived", "mtr", "traceroute", "radvd", "openvswitch", "ovs", "vlan"]),
    ("桌面与图形", ["gtk", "qt5", "qt", "x11", "xorg", "gnome", "kde", "wayland", "cairo", "pango", "fontconfig", "fontforge", "freetype", "harfbuzz", "imagemagick", "graphicsmagick", "opencv", "libpng", "libjpeg", "libtiff", "gdk-pixbuf", "weston", "mutter", "gnome-shell", "libX", "xcb", "xrandr", "libdrm", "mesa", "openexr", "libwebp", "sdl", "gtkmm"]),
    ("办公与文档", ["libreoffice", "wps", "pdf", "epub", "docx", "abiword", "evince", "texlive", "latex"]),
    ("多媒体", ["alsa", "pulse", "jack", "ffmpeg", "gstreamer", "libogg", "libvorbis", "opencore", "wavpack", "flac", "mpv", "vlc", "sound", "audio"]),
    ("分布式与集群", ["corosync", "pacemaker", "pcs", "glusterfs", "dlm", "fence", "stonith", "kubernetes", "kube", "helm", "zookeeper", "kafka", "rabbitmq", "zeromq", "hadoop", "spark", "tomcat"]),
    ("嵌入式", ["embedded", "tiny", "busybox", "uniproton", "mcs", "rpi", "raspi", "dsoftbus", "liteos", "openharmony", "oeaware", "unixbench"]),
    ("驱动专项(driver_test)", ["pcie", "roce", "sas", "sata", "nvme", "nic", "wayca", "hikptool", "dpdk", "perf", "minios", "spdk", "leptonica"]),
    ("系统管理工具", ["anaconda", "cockpit", "dmidecode", "hwloc", "lspci", "pciutils", "usbutils", "lsusb", "lshw", "smartctl", "lsscsi", "pam", "shadow", "chkconfig", "services"]),
    ("办公/图形混合-其他", ["hdf5", "libjpeg-turbo", "libtiff", "ImageMagick"]),
]
rx_list = []
for subj, kws in SUBJECTS:
    for kw in kws:
        rx_list.append((subj, re.compile(r"(?<![A-Za-z0-9_-])" + re.escape(kw) + r"(?![A-Za-z0-9_-])", re.IGNORECASE)))
rx_list.sort(key=lambda x: -len(x[1].pattern))

def subject_of(name):
    for subj, rx in rx_list:
        if rx.search(name):
            return subj
    if name.lower().startswith("fs_"):
        return "文件系统与存储"
    if name.lower().startswith("embedded"):
        return "嵌入式"
    return "其他/第三方软件包"

subject_repo = collections.Counter()
subject_per_domain = collections.defaultdict(collections.Counter)
subject_suites = collections.defaultdict(list)
for c in catalog:
    sub = subject_of(c["suite"])
    subject_repo[sub] += 1
    subject_per_domain[c["category"]][sub] += 1
    subject_suites[sub].append(c["suite"])
for k in subject_suites:
    subject_suites[k].sort()

json.dump({sub: sorted(subject_suites[sub]) for sub, n in subject_repo.most_common()},
          open(os.path.join(DATA_DIR, "subject_map.json"), "w", encoding="utf-8"),
          ensure_ascii=False, indent=1)

# ---------------- 4.5 额外统计 ----------------
def suite_cases(suite_name):
    for c in catalog:
        if c["suite"] == suite_name:
            return c["n_cases"]
    return 0

def count_subdirs(base):
    if not os.path.isdir(base):
        return 0
    return sum(1 for d in os.listdir(base) if os.path.isdir(os.path.join(base, d)))

cli_dirs = count_subdirs(os.path.join(TESTCASES, "cli-test"))
security_themes = count_subdirs(os.path.join(TESTCASES, "security_test"))

try:
    import subprocess
    commit_short = subprocess.check_output(["git", "rev-parse", "--short", "HEAD"], cwd=REPO, stderr=subprocess.DEVNULL).decode().strip()
    last_subject = subprocess.check_output(["git", "log", "-1", "--format=%s"], cwd=REPO, stderr=subprocess.DEVNULL).decode().strip()
    branch = subprocess.check_output(["git", "rev-parse", "--abbrev-ref", "HEAD"], cwd=REPO, stderr=subprocess.DEVNULL).decode().strip()
except Exception:
    commit_short = last_subject = branch = "unknown"

# ---------------- 5. stats.json ----------------
pct = lambda a, b: round(a / b * 100, 1) if b else 0
stats = {
    "suites_total": len(catalog),
    "cases_total": sum(c["n_cases"] for c in catalog),
    "unique_cases": len(names),
    "dup_names": len(dups),
    "extra_refs": sum(v - 1 for v in dups.values()),
    "script_files": len(all_script_files),
    "orphans": len(orphans),
    "orphan_case": orphan_case,
    "orphan_lib": orphan_lib,
    "orphan_by": dict(orphan_by),
    "sh_cases": sum(1 for s in per_suite for c in s["cases"] if c.get("file") and c["file"].endswith(".sh")),
    "py_cases": sum(1 for s in per_suite for c in s["cases"] if c.get("file") and c["file"].endswith(".py")),
    "desc_cases": desc_cases,
    "check_cases": check_cases,
    "dnf_cases": dnf_cases,
    "ssh_cases": ssh_cases,
    "timeout_cases": to_cases,
    "config_params": fn_cnt.get("config_params", 0),
    "pre_test": fn_cnt.get("pre_test", 0),
    "post_test": fn_cnt.get("post_test", 0),
    "run_test": fn_cnt.get("run_test", 0),
    "domains": {d: {"suites": v[0], "cases": v[1]} for d, v in S.items()},
    "types": dict(type_cnt),
    "cons_suite": dict(cons_suite),
    "cons_case": dict(cons_case),
    "suites_with_constraints": sum(1 for c in catalog if c["constraints"]),
    "smoke_overlap": smoke_overlap,
    "missing_cases": len(missing),
    "subject_repo": {k: v for k, v in subject_repo.most_common()},
    "subject_per_domain": {d: {k: v for k, v in m.most_common()} for d, m in subject_per_domain.items()},
    "missing_top": dict(collections.Counter(s for s, _ in missing).most_common(8)),
    "smoke_cases": suite_cases("smoke"),
    "smoke_basic_os_cases": suite_cases("smoke-basic-os"),
    "smoke_syscare_cases": suite_cases("smoke-syscare"),
    "cli_dirs": cli_dirs,
    "security_themes": security_themes,
    "commit_short": commit_short,
    "last_subject": last_subject,
    "branch": branch,
}
with open(os.path.join(DATA_DIR, "stats.json"), "w", encoding="utf-8") as fh:
    json.dump(stats, fh, ensure_ascii=False, indent=1)

print("suites:", len(catalog), "cases:", sum(c["n_cases"] for c in catalog))
print("missing scripts:", len(missing), "orphans:", len(orphans))
print("desc:", desc_cases, "checks:", check_cases, "dnf:", dnf_cases, "ssh:", ssh_cases, "timeout:", to_cases)
print("stats.json written.")
