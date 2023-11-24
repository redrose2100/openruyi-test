%{
#include <stdio.h>
%}

%%
[0-9]+     printf("Matched number:%s\n",yytext);
.          /* 忽略其他字符 */

%%

int main(){
    yylex();   /* 调用词法分析器 */
    return 0;
}
