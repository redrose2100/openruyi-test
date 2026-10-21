#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <png.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: gen_itxt <output_file>\n");
        return 1;
    }

    const char *output_file = argv[1];
    int width = 10, height = 10;
    int channels = 3;

    png_bytep *row_pointers = (png_bytep*)calloc(height, sizeof(png_bytep));
    if (!row_pointers) return 1;

    for (int i = 0; i < height; i++) {
        row_pointers[i] = (png_bytep)malloc(width * channels);
        if (!row_pointers[i]) break;
        for (int j = 0; j < width; j++) {
            row_pointers[i][j * channels] = 128;
            row_pointers[i][j * channels + 1] = 64;
            row_pointers[i][j * channels + 2] = 32;
        }
    }

    FILE *fp = fopen(output_file, "wb");
    if (!fp) {
        for (int i = 0; i < height; i++) free(row_pointers[i]);
        free(row_pointers);
        return 1;
    }

    png_structp png = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png) { fclose(fp); return 1; }

    png_infop info = png_create_info_struct(png);
    if (!info) { png_destroy_write_struct(&png, NULL); fclose(fp); return 1; }

    if (setjmp(png_jmpbuf(png))) {
        png_destroy_write_struct(&png, &info);
        fclose(fp);
        return 1;
    }

    png_init_io(png, fp);

    png_set_IHDR(png, info, width, height, 8, PNG_COLOR_TYPE_RGB,
                 PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);

    png_text itxt;
    itxt.key = (png_charp)"Description";
    itxt.text = (png_charp)"Test international text";
    itxt.lang = (png_charp)"en";
    itxt.lang_key = (png_charp)"";
    itxt.compression = PNG_TEXT_COMPRESSION_NONE;
    png_set_text(png, info, &itxt, 1);

    png_write_info(png, info);

    png_write_image(png, row_pointers);
    png_write_end(png, NULL);

    png_destroy_write_struct(&png, &info);
    for (int i = 0; i < height; i++) free(row_pointers[i]);
    free(row_pointers);
    fclose(fp);

    printf("ITXT_PNG_OK\n");
    return 0;
}

