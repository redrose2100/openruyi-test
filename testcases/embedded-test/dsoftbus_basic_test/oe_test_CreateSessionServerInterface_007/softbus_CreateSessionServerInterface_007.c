/**
 * @title:测试CreateSessionServer创建session服务端函数，
 *  入参PACKAGE_NAME为正常、LOCAL_SESSION_NAME为正常、&sessionCB为空
 */
#include "dsoftbus_common.h"
#include "session.h"

static int CreateSessionServer_SessioinNullCB(void)
{
    const ISessionListener sessionCB = {
    };

    return CreateSessionServer(PACKAGE_NAME, LOCAL_SESSION_NAME, &sessionCB);
}

int main(int argc, char **argv)
{
    int ret = CreateSessionServer_SessioinNullCB();
    if (ret) {
        printf("CreateSessionServer fail:%d\n", ret);
        return 1;
    }
    else {
        printf("CreateSessionServer success:%d\n", ret);
        return 0;
    }
}