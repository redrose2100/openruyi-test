#include <stdio.h>
#include <yajl/yajl_tree.h>
#include <stdlib.h>

int main(void) {
    const char * filePath = "test.json";
    FILE * file = fopen(filePath, "r");
    if (file == NULL) {
        fprintf(stderr, "Unable to open file %s\n", filePath);
        return 1;
    }

    fseek(file, 0, SEEK_END);
    size_t size = (size_t)ftell(file);
    fseek(file, 0, SEEK_SET);

    char * fileData = (char *)malloc(size + 1);
    fread(fileData, 1, size, file);
    fileData[size] = 0;

    fclose(file);

    yajl_val node = yajl_tree_parse((const char *)fileData, NULL, 0);
    if (node == NULL) {
        fprintf(stderr, "Error parsing JSON data\n");
        free(fileData);
        return 1;
    }

    const char * path[] = { "name", (const char *) 0 };
    yajl_val v = yajl_tree_get(node, path, yajl_t_string);
    if (v) {
        printf("Name: %s\n", YAJL_GET_STRING(v));
    } else {
        printf("Name not found.\n");
    }

    yajl_tree_free(node);
    free(fileData);

    return 0;
}
