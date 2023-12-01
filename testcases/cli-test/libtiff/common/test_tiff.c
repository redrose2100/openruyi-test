#include <stdio.h>
#include <tiffio.h>

int main()
{
    TIFF* tiff = TIFFOpen("example.tif", "r"); // 打开TIFF文件进行读取
    if (tiff)
    {
        uint32 width, height;
        uint32* raster;

        // 获取图像的宽度和高度
        TIFFGetField(tiff, TIFFTAG_IMAGEWIDTH, &width);
        TIFFGetField(tiff, TIFFTAG_IMAGELENGTH, &height);

        raster = (uint32*)_TIFFmalloc(width * height * sizeof(uint32)); // 分配内存

        // 从TIFF文件中读取像素数据
        if (raster != NULL && TIFFReadRGBAImage(tiff, width, height, raster, 0))
        {
            // 在这里可以对图像进行处理或分析

            // 例如，输出图像的尺寸信息
            printf("Image Width: %d\n", width);
            printf("Image Height: %d\n", height);

            // 释放内存
            _TIFFfree(raster);
        }

        TIFFClose(tiff); // 关闭TIFF文件
    }
    else
    {
        printf("Failed to open TIFF file.\n");
    }

    return 0;
}