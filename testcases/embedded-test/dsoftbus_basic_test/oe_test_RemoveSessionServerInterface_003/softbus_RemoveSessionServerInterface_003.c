/**
 * @title:测试RemoveSessionServer移除session服务端函数，
 *    入参RE_PACKAGE_NAME为NULL、RE_LOCAL_SESSION_NAME为正常
 */
#include "dsoftbus_common.h"

#define RE_PACKAGE_NAME NULL
#define RE_LOCAL_SESSION_NAME "session_test"

int main(int argc, char **argv)
{
    int ret;

    ret = CreateSessionServerInterface();
    if (ret) {
        printf("CreateSessionServer fail, ret=%d\n", ret);
        return 1;
    }

    ret = RemoveSessionServer(RE_PACKAGE_NAME, RE_LOCAL_SESSION_NAME);
    if (ret) {
        printf("RemoveSessionServer fail:%d\n", ret);
        return 1;
    }
    else {
        printf("RemoveSessionServer success:%d\n", ret);
        return 0;
    }
}
