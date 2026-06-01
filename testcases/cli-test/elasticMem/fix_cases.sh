#!/usr/bin/bash
# elasticMem mugen 用例批量修复脚本
# 修复内容：
# 1. run_test() 开头添加环境守卫 (em_check_env || return 1)
# 2. taskset 使用加 LC_ALL=C 强制英文输出
# 3. 其他已知问题

set -e
DIR="/root/xys/gitcode/test/mugen/testcases/cli-test/elasticMem"

echo "=== 1. 添加 run_test 环境守卫 ==="
for f in "$DIR"/oe_test_*.sh; do
    # 检查是否需要环境守卫（pre_test 有 em_check_env 的用例）
    if grep -q "em_check_env" "$f"; then
        # 检查 run_test 是否已有环境守卫
        if ! grep -A 5 "^function run_test()" "$f" | grep -q "em_check_env"; then
            # 在 LOG_INFO "Start testing..." 后插入
            awk '
/^function run_test\(\)/ { found=1 }
found && /LOG_INFO "Start testing\.\.\."/ { print; print "    em_check_env || return 1"; found=0; next }
{ print }
' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
            echo "  + environment guard: $(basename $f)"
        fi
    fi
done

echo ""
echo "=== 2. 修复 taskset locale 问题 ==="
for f in "$DIR"/oe_test_*.sh; do
    if grep -q "taskset -p" "$f"; then
        sed -i 's/taskset -p/LC_ALL=C taskset -p/g' "$f"
        echo "  + LC_ALL=C: $(basename $f)"
    fi
done

echo ""
echo "=== 3. 修复 Spark 用例前置检查 ==="
for f in "$DIR"/oe_test_elasticMem_spark_fun_*.sh; do
    # 在 pre_test 添加 spark 检查（如果没有）
    if ! grep -q "em_require_spark" "$f"; then
        awk '
/^function pre_test\(\)/ { found=1 }
found && /LOG_INFO "Start environmental preparation\.\."/ { print; print "    em_require_spark || return 1"; found=0; next }
{ print }
' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
        echo "  + spark guard: $(basename $f)"
    fi
done

echo ""
echo "=== 4. 修复 resource_ras_001 bc 计算 ==="
f="$DIR/oe_test_elasticMem_resource_ras_001.sh"
if grep -q "cpu=$(ps" "$f" && ! grep -q "em_require_bc" "$f"; then
    sed -i '/em_require_stress_ng$/a\    em_require_bc' "$f"
    echo "  + bc requirement: $(basename $f)"
fi

echo ""
echo "=== 5. 验证修复结果 ==="
echo "taskset 使用数:"
grep -c "LC_ALL=C taskset" "$DIR"/oe_test_*.sh | grep -v ":0$" | wc -l

echo ""
echo "环境守卫添加数:"
grep -c "em_check_env || return 1" "$DIR"/oe_test_*.sh | grep -v ":0$" | wc -l

echo ""
echo "=== 修复完成 ==="
echo "所有用例已更新，可以重新运行测试"