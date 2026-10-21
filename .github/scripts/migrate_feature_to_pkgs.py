# -*- coding: utf-8 -*-
"""feature-test 软件包测试套件迁移到 pkgs-test。

处理：
1. git mv 目录到目标位置（改名）
2. MERGE 到已有目录（sysmonitor-kmod / sysSentry）
3. secure_conf 拆分（secScanner 并入 + openscap 新建）
4. 替换脚本内 feature-test 路径引用为 pkgs-test
5. suite2cases json 迁移/MERGE/改名 + path 改写
"""
import os
import json
import subprocess
import sys

REPO = os.path.abspath('.')
SRC = 'testcases/function-test/feature-test'
DST = 'testcases/function-test/pkgs-test'
SJ = 'suite2cases/function-test/feature-test'
DJ = 'suite2cases/function-test/pkgs-test'

# 套件 -> 目标目录
MOVE = {
    'da-tool': 'da-tool',
    'gazelle': 'gazelle',
    'k3s': 'k3s',
    'kconfigDetector': 'kconfigDetector',
    'oedp': 'oedp',
    'pkgship': 'pkgship',
    'sysboost': 'sysboost',
    'sysmaster': 'sysmaster',
    'oeaware': 'oeAware-manager',
    'powerapi_interface': 'powerapi-devel',
    'secscanner': 'secScanner',
    'sysmonitor': 'sysmonitor-kmod',   # MERGE
    'sysSentry': 'sysSentry',          # MERGE
}

# 脚本内路径替换（原 feature-test 路径 -> pkgs-test 路径）
PATH_FIX = {
    'testcases/function-test/feature-test/oeaware': 'testcases/function-test/pkgs-test/oeAware-manager',
    'testcases/function-test/feature-test/sysmonitor': 'testcases/function-test/pkgs-test/sysmonitor-kmod',
    'testcases/function-test/feature-test/pkgship': 'testcases/function-test/pkgs-test/pkgship',
}

def git(*args):
    """运行 git 命令，失败抛异常。"""
    r = subprocess.run(['git', '-C', REPO] + list(args), capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError('git %s failed: %s' % (' '.join(args), r.stderr.strip()))
    return r.stdout

def git_mv(src, dst):
    # 处理源为目录的情况：git mv dir target_dir（若目标不存在则整体改名）
    git('mv', src, dst)

def fix_path_refs(suite, new_suite):
    """替换套件脚本内的 feature-test 路径引用。"""
    for root, dirs, fns in os.walk(os.path.join(DST, new_suite)):
        for fn in fns:
            if not fn.endswith('.sh'):
                continue
            p = os.path.join(root, fn)
            txt = open(p, encoding='utf-8', errors='ignore').read()
            new = txt
            for old, nw in PATH_FIX.items():
                new = new.replace(old, nw)
            if new != txt:
                with open(p, 'w', encoding='utf-8', newline='\n') as f:
                    f.write(new)
                git('add', os.path.relpath(p, REPO))

def walk_all(sp):
    out = []
    for root, dirs, fns in os.walk(sp):
        for fn in fns:
            out.append(os.path.join(root, fn))
    return out

def load_json(p):
    with open(p, encoding='utf-8') as f:
        return json.load(f)

def save_json(p, j):
    with open(p, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(j, f, ensure_ascii=False, indent=4)
        f.write('\n')
    git('add', os.path.relpath(p, REPO))

def fix_json_path(j, old_prefix, new_prefix):
    """改写 json 的 path 字段前缀。"""
    p = j.get('path', '')
    if p.startswith(old_prefix):
        j['path'] = new_prefix + p[len(old_prefix):]
    return j

def main():
    dry = '--dry' in sys.argv

    # ============ 1. 套件目录迁移 ============
    print('==== 阶段1: 套件目录迁移 ====')
    for suite, new_suite in MOVE.items():
        sp = os.path.join(SRC, suite)
        dp = os.path.join(DST, new_suite)
        if not os.path.isdir(sp):
            print('  SKIP %s (不存在)' % suite)
            continue
        if os.path.isdir(dp):
            # MERGE：目标已存在，逐个移动文件（保留目录结构）
            print('  MERGE %s -> %s' % (suite, new_suite))
            for f in walk_all(sp):
                rel = os.path.relpath(f, sp)
                tgt = os.path.join(dp, rel)
                os.makedirs(os.path.dirname(tgt), exist_ok=True)
                if not dry:
                    git_mv(f, tgt)
        else:
            print('  MOVE %s -> %s' % (suite, new_suite))
            if not dry:
                git_mv(sp, dp)
        # 路径引用替换
        if not dry and suite in ('oeaware', 'sysmonitor', 'pkgship'):
            fix_path_refs(suite, new_suite)
            print('    (替换 feature-test 路径引用)')

    # ============ 2. secure_conf 拆分 ============
    print('==== 阶段2: secure_conf 拆分 ====')
    sc_dir = os.path.join(SRC, 'secure_conf')
    if os.path.isdir(sc_dir):
        # oe_test_secscanner_034.sh -> secScanner/
        f1 = os.path.join(sc_dir, 'oe_test_secscanner_034.sh')
        t1 = os.path.join(DST, 'secScanner', 'oe_test_secscanner_034.sh')
        print('  %s -> secScanner/' % os.path.basename(f1))
        if not dry:
            os.makedirs(os.path.dirname(t1), exist_ok=True)
            git_mv(f1, t1)
        # oe_test_secureconfline_checktools.sh + common.sh -> openscap/
        osd = os.path.join(DST, 'openscap')
        for f in ('oe_test_secureconfline_checktools.sh', 'common.sh'):
            fp = os.path.join(sc_dir, f)
            if os.path.exists(fp):
                tp = os.path.join(osd, f)
                print('  %s -> openscap/' % f)
                if not dry:
                    os.makedirs(os.path.dirname(tp), exist_ok=True)
                    git_mv(fp, tp)
        # 清空 secure_conf
        rem = os.listdir(sc_dir)
        if not rem and not dry:
            # 空目录 git 不跟踪，直接 rmdir
            os.rmdir(sc_dir)
            print('  (secure_conf 目录已清空删除)')

    # ============ 3. suite2cases json ============
    print('==== 阶段3: suite2cases json ====')

    # 3a. 直接移动 + path 改写的 json
    simple = {
        'da-tool.json': 'da-tool.json',
        'gazelle.json': 'gazelle.json',
        'k3s.json': 'k3s.json',
        'kconfigDetector.json': 'kconfigDetector.json',
        'oedp.json': 'oedp.json',
        'sysboost.json': 'sysboost.json',
        'sysmaster.json': 'sysmaster.json',
        'oeaware.json': 'oeAware-manager.json',
        'powerapi_interface.json': 'powerapi-devel.json',
        'secscanner.json': 'secScanner.json',
    }
    for sf, tf in simple.items():
        sp = os.path.join(SJ, sf)
        tp = os.path.join(DJ, tf)
        if not os.path.exists(sp):
            print('  SKIP json %s (不存在)' % sf)
            continue
        j = load_json(sp)
        # path 字段：整体替换 feature-test/<旧套件名> -> pkgs-test/<新包名>
        # 兼容两种格式：$OET_PATH/... 和 ${OET_PATH}/...
        old_suite = sf[:-5]          # 去掉 .json 得旧套件名
        base = tf[:-5]               # 新包名
        p = j.get('path', '')
        oldp = 'feature-test/' + old_suite
        newp = 'pkgs-test/' + base
        if oldp in p:
            j['path'] = p.replace(oldp, newp)
        if dry:
            print('  json %s -> %s (path: %s)' % (sf, tf, j['path']))
        else:
            save_json(tp, j)
            git('rm', os.path.relpath(sp, REPO))

    # 3b. pkgship 10 个 json
    for f in sorted(os.listdir(SJ)):
        if f.startswith('pkgship_'):
            sp = os.path.join(SJ, f)
            tp = os.path.join(DJ, f)
            j = load_json(sp)
            p = j.get('path', '')
            if 'testcases/function-test/feature-test/' in p:
                j['path'] = p.replace('testcases/function-test/feature-test/',
                                      'testcases/function-test/pkgs-test/')
            if dry:
                print('  json %s -> pkgs-test/ (path: %s)' % (f, j['path']))
            else:
                save_json(tp, j)
                git('rm', os.path.relpath(sp, REPO))

    # 3c. sysSentry MERGE（sysSentry_feature.json 并入 sysSentry.json）
    fj = os.path.join(SJ, 'sysSentry_feature.json')
    tj = os.path.join(DJ, 'sysSentry.json')
    if os.path.exists(fj):
        fj_data = load_json(fj)
        tj_data = load_json(tj) if os.path.exists(tj) else {'path': '${OET_PATH}/testcases/function-test/pkgs-test/sysSentry', 'cases': []}
        # 按 name 去重合并
        existing = {c['name'] for c in tj_data.get('cases', [])}
        added = 0
        for c in fj_data.get('cases', []):
            if c['name'] not in existing:
                tj_data['cases'].append(c)
                added += 1
        tj_data['path'] = '${OET_PATH}/testcases/function-test/pkgs-test/sysSentry'
        if dry:
            print('  MERGE sysSentry_feature.json -> sysSentry.json (+%d case)' % added)
        else:
            save_json(tj, tj_data)
            git('rm', os.path.relpath(fj, REPO))

    # 3d. sysmonitor MERGE（sysmonitor.json 并入 sysmonitor-kmod.json）
    fj = os.path.join(SJ, 'sysmonitor.json')
    tj = os.path.join(DJ, 'sysmonitor-kmod.json')
    if os.path.exists(fj):
        fj_data = load_json(fj)
        tj_data = load_json(tj) if os.path.exists(tj) else {'path': '${OET_PATH}/testcases/function-test/pkgs-test/sysmonitor-kmod', 'cases': []}
        existing = {c['name'] for c in tj_data.get('cases', [])}
        added = 0
        for c in fj_data.get('cases', []):
            if c['name'] not in existing:
                tj_data['cases'].append(c)
                added += 1
        tj_data['path'] = '${OET_PATH}/testcases/function-test/pkgs-test/sysmonitor-kmod'
        if dry:
            print('  MERGE sysmonitor.json -> sysmonitor-kmod.json (+%d case)' % added)
        else:
            save_json(tj, tj_data)
            git('rm', os.path.relpath(fj, REPO))

    # 3e. secure_conf json 处理
    scj = os.path.join(SJ, 'secure_conf.json')
    if os.path.exists(scj):
        if dry:
            print('  secure_conf.json 将拆分 -> secScanner.json + openscap.json')
        else:
            sc_data = load_json(scj)
            # oe_test_secscanner_034 -> secScanner.json
            sec_tj = os.path.join(DJ, 'secScanner.json')
            sec_data = load_json(sec_tj)
            existing = {c['name'] for c in sec_data.get('cases', [])}
            for c in sc_data.get('cases', []):
                if c['name'] == 'oe_test_secscanner_034' and c['name'] not in existing:
                    sec_data['cases'].append(c)
            save_json(sec_tj, sec_data)
            # oe_test_secureconfline_checktools -> openscap.json 新建
            osc_tj = os.path.join(DJ, 'openscap.json')
            osc_data = {'path': '${OET_PATH}/testcases/function-test/pkgs-test/openscap', 'cases': []}
            for c in sc_data.get('cases', []):
                if c['name'] == 'oe_test_secureconfline_checktools':
                    osc_data['cases'].append(c)
            save_json(osc_tj, osc_data)
            git('rm', os.path.relpath(scj, REPO))
            print('  secure_conf.json 拆分 -> secScanner.json + openscap.json')

    print('==== 完成 ====')

if __name__ == '__main__':
    main()
