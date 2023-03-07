/**
 * @title:测试CreateSessionServer创建session服务端函数，
 *   入参PACKAGE_NAME为123456、LOCAL_SESSION_NAME为正常、&sessionCB为正常
 */
#include "dsoftbus_common.h"

static int CreateSessionServer_PackageName123456(void)
{
    const ISessionListener sessionCB = {
        .OnSessionOpened = SessionOpened,
        .OnSessionClosed = SessionClosed,
        .OnBytesReceived = ByteRecived,
        .OnMessageReceived = MessageReceived,
    };

    return CreateSessionServer(123456, LOCAL_SESSION_NAME, &sessionCB);
}

int main(int argc, char **argv)
{
    int ret = CreateSessionServer_PackageName123456();
    if (ret) {
        printf("CreateSessionServer fail:%d\n", ret);
        return 1;
    }
    printf("CreateSessionServer success:%d\n", ret);
    return 0;
}