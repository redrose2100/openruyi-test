#include <stdio.h>
#include <stdlib.h>
#include <unistr.h>
#include <unictype.h>
 
size_t n_of_utf8_chars(const uint8_t *s)
{
        ucs4_t c;
        size_t n = 0;
        for (const uint8_t *it = s; it;it = u8_next(&c, it)) n++;
        n--; /* 不计结尾的 NUL 字符 */
        return n;
}
 
int main(void)
{
        const uint8_t *s = (uint8_t *)"      葫  \t芦\n娃";
        size_t  n = n_of_utf8_chars(s);
        int *p = malloc(n * sizeof(int));
        const uint8_t *it = s;
        for (size_t i = 0; i < n; i++) {
                ucs4_t c;
                it = u8_next(&c, it);
                if (uc_is_property_white_space(c)) p[i] = 0;
                else p[i] = 1;
        }
        for (size_t i = 0; i < n; i++) {
                printf("%d", p[i]);
        }
        printf("\n");
        return 0;
}
