#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <errno.h>
#include </usr/include/pixman-1/pixman.h>

#define MAX_WATERMARK_LEN 100

#pragma pack(2)

typedef struct BITMAPFILEHEADER
{
    uint16_t bfType;
    uint32_t bfSize;
    uint16_t bfReserved1;
    uint16_t bfReserved2;
    uint32_t bfOffBits;
}BITMAPFILEHEADER;

typedef struct BITMAPINFOHEADER
{
    uint32_t biSize;
    uint32_t biWidth;
    uint32_t biHeight;
    uint16_t biPlanes;
    uint16_t biBitCount;
    uint32_t biCompression;
    uint32_t biSizeImage;
    uint32_t biXPelsPerMeter;
    uint32_t biYPelsPerMeter;
    uint32_t biClrUsed;
    uint32_t biClrImportant;
}BITMAPINFOHEADER;

void add_watermark(pixman_image_t *dst_image, uint8_t *src_data, int src_width, int src_height, int dst_x, int dst_y, int w, int h)
{

    int reverse_watermark = 1;
    uint8_t *reverse_data = NULL;
    pixman_image_t *src_image = NULL;

    int stride = (src_width* 4 + 3) / 4 * 4;

    if(reverse_watermark)
    {
        uint8_t *p = src_data + (src_height - 1) * stride;

        reverse_data = malloc(src_width * stride);

        for(int i = 0; i < src_height; i++)
        {
            memcpy(reverse_data + i * stride, p, stride);
            p -= stride;
        }

        src_image = pixman_image_create_bits(PIXMAN_b8g8r8a8, src_width, src_height, (uint32_t *)reverse_data,  stride);
    }
    else
    {
        src_image = pixman_image_create_bits(PIXMAN_b8g8r8a8, src_width, src_height, (uint32_t *)src_data,  stride);
    }


    pixman_image_composite32(PIXMAN_OP_ADD,
                             src_image, NULL, dst_image,
                             0, 0, // src
                             0, 0, // mask
                             dst_x, dst_y, // dst
                             w,
                             h);

    if(reverse_data)
        free(reverse_data);
}


//      set the lowest order to bit
//      x
//      bit     0 or 1
unsigned int set_low_bit(unsigned int x, int bit)
{
        return x & 0xFE | bit;
}

//      order 0 ~ 7
//      set order to bit
unsigned int set_bit(unsigned int x, int order, int bit)
{
        return x | (bit << order);
}

unsigned int get_low_bit(unsigned int x)
{
        return x & 0x1;
}


char *get_text(uint8_t *data, int width, int height)
{
        char *str = malloc(MAX_WATERMARK_LEN + 1);
        memset(str, 0, MAX_WATERMARK_LEN + 1);
        for(int i = 0; i < MAX_WATERMARK_LEN; i++)
        {
                int a = 0;
                uint8_t *p = data + i * 8;
                for(int j = 0; j < 8; j++)
                {
                        unsigned int bit = get_low_bit(p[j]);
                        printf("get_bit-[%d]\n", bit);

                        a = set_bit(a, 8 - 1 - j, bit);
                        printf("set bit over a-[%d]\n", a);
                }
                printf("\n");

                str[i] = a;
        }
        str[MAX_WATERMARK_LEN] = '\0';

        return str;
}


void add_lsb_watermark(uint8_t *rgba, char *text)
{
        int index = 0;

        for(int i = 0; i < MAX_WATERMARK_LEN; i++)
        {
                if(i > 0 && i % (strlen(text)) == 0)
                        index = 0;

                uint8_t *p = rgba + i * 8;
                for(int j = 0; j < 8; j++)
                {
                        int bit = (text[index] & (1 << 7 - j)) >> (7 - j);
                        printf("bit=[%d]", bit);
                        p[j] = set_low_bit(p[j], bit);

                }
                printf("\n");
                index++;
        }
}



int main(int argc, char *argv[])
{

        BITMAPFILEHEADER bmph2;
        BITMAPINFOHEADER infoh2;

//      printf("InfoHead=[%d]\n", sizeof(BITMAPFILEHEADER));
//      printf("InfoHead=[%d]\n", sizeof(BITMAPINFOHEADER));

        FILE *fp2 = fopen("aaa.bmp", "rb");
        fseek(fp2, 0, SEEK_END);
        int len2 = ftell(fp2);

        rewind(fp2);

        int file_head_len2 = fread(&bmph2, 1, sizeof(BITMAPFILEHEADER), fp2);
//      printf("read file head len=[%d]\n", file_head_len2);

        int info_head_len2 = fread(&infoh2, 1, sizeof(BITMAPINFOHEADER), fp2);
//      printf("read info head len=[%d]\n", info_head_len2);

        int width2 = infoh2.biWidth;
        int height2 = infoh2.biHeight;

        int data_len2 = len2 - file_head_len2 - info_head_len2;

        uint8_t *data2 = malloc(sizeof(uint8_t) *(data_len2));

        data_len2 = fread(data2, 1, len2 - 54, fp2);
        printf("read dst bitmap width-height--[%d][%d]=[%d]-bitcount=[%d]\n", data_len2, width2, height2, infoh2.biBitCount);

        add_lsb_watermark(data2, "luobo-oboul");


        FILE *ffp2 = fopen("aaa-with-watermark.bmp", "wb+");
        infoh2.biHeight = height2;
        fwrite(&bmph2, 1, file_head_len2, ffp2);
        fwrite(&infoh2, 1, info_head_len2, ffp2);
        fwrite(data2, 1, data_len2, ffp2);
        fclose(ffp2);

        char *str = get_text(data2, width2, height2);
        printf("get-text-[%s]\n", str);
        free(str);

        return 0;
}