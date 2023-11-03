#include <yajl/yajl_gen.h>
#include <stdio.h>
#include <string.h>

int main() {
    yajl_gen g = yajl_gen_alloc(NULL);
    yajl_gen_map_open(g);                   // 开始一个 JSON 对象
    yajl_gen_string(g, (const unsigned char *) "name", strlen("name"));  // name 字段
    yajl_gen_string(g, (const unsigned char *) "Alice", strlen("Alice"));  // name 字段的值
    yajl_gen_string(g, (const unsigned char *) "age", strlen("age"));    // age 字段
    yajl_gen_integer(g, 30);                 // age 字段的值
    yajl_gen_map_close(g);                  // 结束 JSON 对象
    const unsigned char *json;
    size_t len;
    yajl_gen_get_buf(g, &json, &len);
    fwrite(json, 1, len, stdout);            // 输出 JSON 数据到控制台
    yajl_gen_free(g);
    return 0;
}
