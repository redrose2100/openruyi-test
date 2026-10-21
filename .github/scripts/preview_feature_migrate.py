# -*- coding: utf-8 -*-
"""收集 feature-test -> pkgs-test 迁移数据（预览用）"""
import os, json

SRC = 'testcases/function-test/feature-test'
DST = 'testcases/function-test/pkgs-test'
SJ = 'suite2cases/function-test/feature-test'
DJ = 'suite2cases/function-test/pkgs-test'

mapping = {
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
    'sysmonitor': 'sysmonitor-kmod',
    'sysSentry': 'sysSentry',
    'ubackup': 'com.deepin.backup',
}

def walk_files(sp):
    out = []
    for root, dirs, fns in os.walk(sp):
        for fn in fns:
            rel = os.path.relpath(os.path.join(root, fn), sp).replace('\\', '/')
            out.append(rel)
    return sorted(out)

for s, d in mapping.items():
    sp = os.path.join(SRC, s)
    dp = os.path.join(DST, d)
    files = walk_files(sp)
    print('== %s -> %s (文件数 %d)' % (s, d, len(files)))
    print('   目标目录已存在:', os.path.isdir(dp))
    # json 查找
    jj = os.path.join(SJ, s + '.json')
    if os.path.exists(jj):
        jd = json.load(open(jj, encoding='utf-8'))
        print('   json: %s.json cases=%d' % (s, len(jd.get('cases', []))))
    else:
        pj = sorted(f for f in os.listdir(SJ) if f.startswith(s))
        total = 0
        for f in pj:
            jd = json.load(open(os.path.join(SJ, f), encoding='utf-8'))
            total += len(jd.get('cases', []))
        print('   json: %s (共%d个json, cases=%d)' % (pj, len(pj), total))
    # 目标 json
    dj2 = os.path.join(DJ, d + '.json')
    if os.path.exists(dj2):
        jd = json.load(open(dj2, encoding='utf-8'))
        print('   !! 目标json已存在: %s.json cases=%d' % (d, len(jd.get('cases', []))))
    if files:
        print('   前6个文件: %s' % files[:6])
