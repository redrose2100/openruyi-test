#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <png.h>

static void write_png_file(const char *filename, png_bytep *row_pointers, int width, int height, int channels) {
    FILE *fp = fopen(filename, "wb");
    if (!fp) return;

    png_structp png = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png) { fclose(fp); return; }

    png_infop info = png_create_info_struct(png);
    if (!info) { png_destroy_write_struct(&png, NULL); fclose(fp); return; }

    if (setjmp(png_jmpbuf(png))) { png_destroy_write_struct(&png, &info); fclose(fp); return; }

    png_init_io(png, fp);

    int bit_depth = 8;
    int color_type;
    if (channels == 1) color_type = PNG_COLOR_TYPE_GRAY;
    else if (channels == 3) color_type = PNG_COLOR_TYPE_RGB;
    else if (channels == 4) color_type = PNG_COLOR_TYPE_RGB_ALPHA;
    else if (channels == 0) {
        color_type = PNG_COLOR_TYPE_PALETTE;
        bit_depth = 8;
    } else {
        png_destroy_write_struct(&png, &info); fclose(fp); return;
    }

    png_set_IHDR(png, info, width, height, bit_depth, color_type,
                 PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);

    if (color_type == PNG_COLOR_TYPE_PALETTE) {
        png_color palette[256];
        for (int i = 0; i < 256; i++) {
            palette[i].red = i;
            palette[i].green = (i * 2) % 256;
            palette[i].blue = (i * 3) % 256;
        }
        png_set_PLTE(png, info, palette, 256);
    }

    png_write_info(png, info);
    png_write_image(png, row_pointers);
    png_write_end(png, NULL);

    png_destroy_write_struct(&png, &info);
    fclose(fp);
}

static int read_png_file(const char *filename, int *width, int *height, int *channels) {
    FILE *fp = fopen(filename, "rb");
    if (!fp) return 0;

    unsigned char sig[8];
    fread(sig, 1, 8, fp);
    if (!png_check_sig(sig, 8)) { fclose(fp); return 0; }

    png_structp png = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png) { fclose(fp); return 0; }

    png_infop info = png_create_info_struct(png);
    if (!info) { png_destroy_read_struct(&png, NULL, NULL); fclose(fp); return 0; }

    if (setjmp(png_jmpbuf(png))) { png_destroy_read_struct(&png, &info, NULL); fclose(fp); return 0; }

    png_init_io(png, fp);
    png_set_sig_bytes(png, 8);
    png_read_info(png, info);

    *width = png_get_image_width(png, info);
    *height = png_get_image_height(png, info);
    int color_type = png_get_color_type(png, info);

    if (color_type == PNG_COLOR_TYPE_GRAY) *channels = 1;
    else if (color_type == PNG_COLOR_TYPE_RGB) *channels = 3;
    else if (color_type == PNG_COLOR_TYPE_RGB_ALPHA) *channels = 4;
    else if (color_type == PNG_COLOR_TYPE_PALETTE) *channels = 1;
    else *channels = 1;

    png_destroy_read_struct(&png, &info, NULL);
    fclose(fp);
    return 1;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: libpng_test <test_type>\n");
        return 1;
    }

    const char *test_type = argv[1];

    if (strcmp(test_type, "version") == 0) {
        printf("LIBPNG_VERSION_OK\n");
        printf("Version: %s\n", PNG_LIBPNG_VER_STRING);
    } else if (strcmp(test_type, "create_rgb") == 0) {
        int width = 100, height = 100, channels = 3;
        png_bytep *row_pointers = (png_bytep*)malloc(height * sizeof(png_bytep));
        for (int i = 0; i < height; i++) {
            row_pointers[i] = (png_bytep)malloc(width * channels);
            for (int j = 0; j < width; j++) {
                row_pointers[i][j * channels] = (i * j) % 256;
                row_pointers[i][j * channels + 1] = ((i + j) * 2) % 256;
                row_pointers[i][j * channels + 2] = ((i * j) / 2) % 256;
            }
        }
        write_png_file("/tmp/libpng_test_rgb.png", row_pointers, width, height, channels);
        for (int i = 0; i < height; i++) free(row_pointers[i]);
        free(row_pointers);
        FILE *fp = fopen("/tmp/libpng_test_rgb.png", "rb");
        if (fp) { fclose(fp); printf("LIBPNG_CREATE_RGB_OK\n"); }
    } else if (strcmp(test_type, "create_gray") == 0) {
        int width = 100, height = 100, channels = 1;
        png_bytep *row_pointers = (png_bytep*)malloc(height * sizeof(png_bytep));
        for (int i = 0; i < height; i++) {
            row_pointers[i] = (png_bytep)malloc(width * channels);
            for (int j = 0; j < width; j++) {
                row_pointers[i][j] = (i + j) % 256;
            }
        }
        write_png_file("/tmp/libpng_test_gray.png", row_pointers, width, height, channels);
        for (int i = 0; i < height; i++) free(row_pointers[i]);
        free(row_pointers);
        FILE *fp = fopen("/tmp/libpng_test_gray.png", "rb");
        if (fp) { fclose(fp); printf("LIBPNG_CREATE_GRAY_OK\n"); }
    } else if (strcmp(test_type, "create_rgba") == 0) {
        int width = 100, height = 100, channels = 4;
        png_bytep *row_pointers = (png_bytep*)malloc(height * sizeof(png_bytep));
        for (int i = 0; i < height; i++) {
            row_pointers[i] = (png_bytep)malloc(width * channels);
            for (int j = 0; j < width; j++) {
                row_pointers[i][j * channels] = (i * j) % 256;
                row_pointers[i][j * channels + 1] = ((i + j) * 2) % 256;
                row_pointers[i][j * channels + 2] = ((i * j) / 2) % 256;
                row_pointers[i][j * channels + 3] = (i + j) % 256;
            }
        }
        write_png_file("/tmp/libpng_test_rgba.png", row_pointers, width, height, channels);
        for (int i = 0; i < height; i++) free(row_pointers[i]);
        free(row_pointers);
        FILE *fp = fopen("/tmp/libpng_test_rgba.png", "rb");
        if (fp) { fclose(fp); printf("LIBPNG_CREATE_RGBA_OK\n"); }
    } else if (strcmp(test_type, "create_palette") == 0) {
        int width = 100, height = 100, channels = 0;
        png_bytep *row_pointers = (png_bytep*)malloc(height * sizeof(png_bytep));
        for (int i = 0; i < height; i++) {
            row_pointers[i] = (png_bytep)malloc(width);
            for (int j = 0; j < width; j++) {
                row_pointers[i][j] = (i + j) % 256;
            }
        }
        write_png_file("/tmp/libpng_test_palette.png", row_pointers, width, height, channels);
        for (int i = 0; i < height; i++) free(row_pointers[i]);
        free(row_pointers);
        FILE *fp = fopen("/tmp/libpng_test_palette.png", "rb");
        if (fp) { fclose(fp); printf("LIBPNG_CREATE_PALETTE_OK\n"); }
    } else if (strcmp(test_type, "read_image") == 0) {
        int width, height, channels;
        if (read_png_file("/tmp/libpng_test_rgb.png", &width, &height, &channels)) {
            printf("LIBPNG_READ_OK\n");
            printf("Width: %d, Height: %d, Channels: %d\n", width, height, channels);
        }
    } else if (strcmp(test_type, "compression") == 0) {
        int width = 200, height = 200, channels = 3;
        png_bytep *row_pointers = (png_bytep*)malloc(height * sizeof(png_bytep));
        for (int i = 0; i < height; i++) {
            row_pointers[i] = (png_bytep)malloc(width * channels);
            memset(row_pointers[i], 128, width * channels);
        }
        write_png_file("/tmp/libpng_test_compression.png", row_pointers, width, height, channels);
        for (int i = 0; i < height; i++) free(row_pointers[i]);
        free(row_pointers);
        FILE *fp = fopen("/tmp/libpng_test_compression.png", "rb");
        if (fp) {
            fseek(fp, 0, SEEK_END);
            long size = ftell(fp);
            fclose(fp);
            if (size > 0 && size < width * height * channels) {
                printf("LIBPNG_COMPRESSION_OK\n");
                printf("Compressed size: %ld bytes\n", size);
            }
        }
    } else if (strcmp(test_type, "bad_file") == 0) {
        FILE *fp = fopen("/tmp/libpng_test_bad.png", "wb");
        if (fp) {
            fprintf(fp, "NOT_A_PNG_FILE");
            fclose(fp);
        }
        int width, height, channels;
        if (!read_png_file("/tmp/libpng_test_bad.png", &width, &height, &channels)) {
            printf("LIBPNG_BAD_FILE_OK\n");
        }
    }

    return 0;
}
