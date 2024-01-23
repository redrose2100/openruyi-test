import numpy as np
from scipy import linalg

# 创建一个测试矩阵
test_matrix = np.array([[1, 2], [3, 4]])

# 使用 Scipy 的 linalg 模块计算矩阵的行列式
det = linalg.det(test_matrix)

# 验证行列式的计算结果是否符合预期
expected_det = -2.0  # 设置预期结果
assert det == expected_det, f"行列式计算错误，预期结果为 {expected_det}，实际结果为 {det}"

print("测试通过！")
