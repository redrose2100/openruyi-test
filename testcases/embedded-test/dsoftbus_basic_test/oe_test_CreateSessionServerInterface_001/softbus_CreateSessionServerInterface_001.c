/**
 * @title:测试CreateSessionServer创建session服务端函数，
 *   入参PACKAGE_NAME为正常、LOCAL_SESSION_NAME为正常、&sessionCB为正常
 */
#include "dsoftbus_common.h"

int main(int argc, char **argv)
{
    int ret = CreateSessionServerInterface();
    if (ret) {
        printf("CreateSessionServer fail:%d\n", ret);
        return 1;
    }
    printf("CreateSessionServer success:%d\n", ret);
    return 0;
}