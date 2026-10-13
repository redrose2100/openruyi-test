#!/usr/bin/bash
# ============================================================================
# update_docs.sh — doc/learning 学习文档自动刷新一站式脚本
#
# 功能（可组合）:
#   --all         同步上游 + 重新生成 + 提交 + 推送 fork（默认; 供手动/计划任务）
#   --prepush     同步上游 + 重新生成 + 提交（供 git pre-push 钩子; 不推送, 避免递归）
#   --regen-only  仅重新生成 + 提交（不联网）
#   --sync        仅同步上游到本地（不重新生成）
#   --regen       仅重新生成（不提交）
#
# 环境变量（可选）:
#   UPSTREAM_REMOTE  上游远端名（默认 upstream）
#   FORK_REMOTE      个人 fork 远端名（默认 origin）
#   BRANCH           本地分支（默认 master）
#
# 依赖: git / python（Windows 下用 git-bash 运行）
# ============================================================================
set -u

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT" || exit 1

MODE="${1:---all}"
UPSTREAM="${UPSTREAM_REMOTE:-upstream}"
FORK="${FORK_REMOTE:-origin}"
BRANCH="${BRANCH:-master}"
FW_DIFF=""

log() { echo "[update-docs] $*"; }

# ---- 1. 同步上游 ----------------------------------------------------------
sync_upstream() {
    if ! git remote get-url "$UPSTREAM" >/dev/null 2>&1; then
        log "上游远端 '$UPSTREAM' 未配置，跳过同步（运行 tools/setup_automation.ps1 或: git remote add $UPSTREAM <源仓库URL>）"
        return 0
    fi
    log "fetch $UPSTREAM/$BRANCH ..."
    git fetch "$UPSTREAM" "$BRANCH" || { log "WARN fetch 失败，跳过同步"; return 0; }
    if ! git rev-parse --verify -q "$UPSTREAM/$BRANCH" >/dev/null 2>&1; then
        log "WARN 无 $UPSTREAM/$BRANCH，跳过同步"; return 0
    fi
    BEHIND=$(git rev-list --count HEAD.."$UPSTREAM/$BRANCH")
    AHEAD=$(git rev-list --count "$UPSTREAM/$BRANCH"..HEAD)
    if [ "$BEHIND" -eq 0 ]; then
        log "上游无新提交，无需合并"
        return 0
    fi
    log "本地落后上游 $BEHIND 提交 / 领先 $AHEAD 提交，执行 merge 合并 ..."
    BEFORE=$(git rev-parse HEAD)
    git merge "$UPSTREAM/$BRANCH" --no-edit \
        -m "merge: 同步上游 openEuler/mugen 最新提交（docs 自动刷新前）" || {
        log "ERROR merge 冲突，请手工解决后重试。"; exit 1; }
    AFTER=$(git rev-parse HEAD)
    # 框架层文件是否随合并变化（供人工复核提示）
    if [ "$BEFORE" != "$AFTER" ]; then
        if ! git diff --quiet "$BEFORE" HEAD -- libs mugen.sh runoet.sh combination.sh \
            qemu_ctl.sh dep_install.sh check_casename.py config.json; then
            FW_DIFF="框架层代码(libs/引擎脚本)随上游更新，01-05 章结构分析可能过时，需人工复核 tools/README.md"
        fi
    fi
    log "合并完成 → $(git rev-parse --short HEAD)"
}

# ---- 2. 重新生成全部 doc/learning ---------------------------------------
regen_docs() {
    log "重新生成 doc/learning（collect → render → 附录 → features → 校验）..."
    cd doc/learning/tools || exit 1
    python collect.py && python render.py && python gen_appendix.py && python gen_features.py && python verify_render.py
    rc=$?
    cd "$ROOT"
    if [ $rc -ne 0 ]; then
        log "ERROR 重新生成失败（rc=$rc）"
        return $rc
    fi
    log "重新生成完成。"
}

# ---- 3. 提交（仅 doc/learning）------------------------------------------
commit_docs() {
    if [ -z "$(git status --porcelain doc/learning)" ]; then
        log "doc/learning 无变化，无需提交。"
        return 0
    fi
    MSG="docs(learning): 自动刷新学习文档（数据快照同步上游最新状态）"
    if [ -n "$FW_DIFF" ]; then
        MSG="$MSG%0A%0A⚠ $FW_DIFF"
    fi
    git add doc/learning || return 1
    git commit -m "$MSG" || return 1
    log "已提交: $(git rev-parse --short HEAD)  $MSG"
}

# ---- 4. 推送 fork --------------------------------------------------------
push_fork() {
    log "push $FORK $BRANCH ..."
    git push "$FORK" "HEAD:$BRANCH" || { log "ERROR push 失败"; exit 1; }
    log "push 完成。"
}

case "$MODE" in
    --prepush)
        sync_upstream
        regen_docs || log "WARN 重新生成失败，不阻塞推送（文档可能滞后）"
        commit_docs
        ;;
    --all)
        sync_upstream
        regen_docs || exit 1
        commit_docs || exit 1
        push_fork
        ;;
    --regen-only)
        regen_docs || exit 1
        commit_docs
        ;;
    --sync)
        sync_upstream
        ;;
    --regen)
        regen_docs
        ;;
    *)
        log "用法: $0 [--all|--prepush|--regen-only|--sync|--regen]"
        exit 1
        ;;
esac
