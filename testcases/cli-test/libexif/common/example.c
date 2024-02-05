#include <stdio.h>
#include <stdlib.h>
#include <libexif/exif-data.h>

int main() {
    const char* filename = "example.jpg";
    ExifData *exifData;
    ExifEntry *entry;

    // 加载图像的EXIF数据
    exifData = exif_data_new_from_file(filename);
    if (!exifData) {
        fprintf(stderr, "无法加载EXIF数据\n");
        return 1;
    }

    // 获取图像的宽度和高度信息
    entry = exif_data_get_entry(exifData, EXIF_TAG_PIXEL_X_DIMENSION);
    if (entry) {
        printf("宽度: %d\n", exif_get_long(entry->data, exif_data_get_byte_order(exifData)));
    }

    entry = exif_data_get_entry(exifData, EXIF_TAG_PIXEL_Y_DIMENSION);
    if (entry) {
        printf("高度: %d\n", exif_get_long(entry->data, exif_data_get_byte_order(exifData)));
    }

    // 释放资源
    exif_data_unref(exifData);

    return 0;
}
