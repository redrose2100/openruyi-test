/**
 * @title:测试CreateSessionServer创建session服务端函数，
 *    入参PACKAGE_NAME为NULL、LOCAL_SESSION_NAME为正常、&sessionCB为正常
 */
#include "dsoftbus_common.h"

static int CreateSessionServer_PackageNameNull(void)
{
    const ISessionListener sessionCB = {
        .OnSessionOpened = SessionOpened,
        .OnSessionClosed = SessionClosed,
        .OnBytesReceived = ByteRecived,
        .OnMessageReceived = MessageReceived,
    };

    return CreateSessionServer(NULL, LOCAL_SESSION_NAME, &sessionCB);
}

int main(int argc, char **argv)
{
    int ret = CreateSessionServer_PackageNameNull();
    if (ret) {
        printf("CreateSessionServer fail:%d\n", ret);
        return 1;
    }
    printf("CreateSessionServer success:%d\n", ret);
    return 0;
}