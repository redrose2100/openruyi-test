/**
 * @title:测试CreateSessionServer创建session服务端函数，
 *   入参PACKAGE_NAME为正常、LOCAL_SESSION_NAME为123456、&sessionCB为正常
 */
#include "dsoftbus_common.h"

static int CreateSessionServer_SessionName123456(void)
{
    const ISessionListener sessionCB = {
        .OnSessionOpened = SessionOpened,
        .OnSessionClosed = SessionClosed,
        .OnBytesReceived = ByteRecived,
        .OnMessageReceived = MessageReceived,
    };

    return CreateSessionServer(PACKAGE_NAME, 123456, &sessionCB);
}

int main(int argc, char **argv)
{
    int ret = CreateSessionServer_SessionName123456();
    if (ret) {
        printf("CreateSessionServer fail:%d\n", ret);
        return 1;
    }
    printf("CreateSessionServer success:%d\n", ret);
    return 0;
}