import sys
from gi.repository import GdkPixbuf

# 读取输入图像文件
input_file = sys.argv[1]
pixbuf = GdkPixbuf.Pixbuf.new_from_file(input_file)

# 旋转图像
rotated_pixbuf = pixbuf.rotate_simple(GdkPixbuf.PixbufRotation.COUNTERCLOCKWISE)

# 保存旋转后的图像到输出文件
output_file = sys.argv[2]
rotated_pixbuf.savev(output_file, "jpeg", [], [])

print("图片旋转完成")
