/**
 * @title:测试CreateSessionServer创建session服务端函数，
 *    入参PACKAGE_NAME为正常、LOCAL_SESSION_NAME为正常、&sessionCB为正常
 *    OnSessionOpened为NULL、OnSessionClosed为NULL
 */
#include "dsoftbus_common.h"
#include "session.h"

static int CreateSessionServer_SessionCB()
{
    const ISessionListener sessionCB = {
        .OnSessionOpened = NULL,
        .OnSessionClosed = NULL,
        .OnBytesReceived = ByteRecived,
        .OnMessageReceived = MessageReceived,
    };

    return CreateSessionServer(PACKAGE_NAME, LOCAL_SESSION_NAME, &sessionCB);
}

int main(int argc, char **argv)
{
    int ret = CreateSessionServer_SessionCB();
    if (ret) {
        printf("CreateSessionServer fail:%d\n", ret);
        return 1;
    }
    else {
        printf("CreateSessionServer success:%d\n", ret);
        return 0;
    }
}