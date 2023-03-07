/**
 * @title:测试CreateSessionServer创建session服务端函数，
 *    入参PACKAGE_NAME为正常、LOCAL_SESSION_NAME为NULL、&sessionCB为正常
 */
#include "dsoftbus_common.h"

static int CreateSessionServer_SessionNameNull(void)
{
    const ISessionListener sessionCB = {
        .OnSessionOpened = SessionOpened,
        .OnSessionClosed = SessionClosed,
        .OnBytesReceived = ByteRecived,
        .OnMessageReceived = MessageReceived,
    };

    return CreateSessionServer(PACKAGE_NAME, NULL, &sessionCB);
}


int main(int argc, char **argv)
{
    int ret = CreateSessionServer_SessionNameNull();
    if (ret) {
        printf("CreateSessionServer fail:%d\n", ret);
        return 1;
    }
    printf("CreateSessionServer success:%d\n", ret);
    return 0;
}