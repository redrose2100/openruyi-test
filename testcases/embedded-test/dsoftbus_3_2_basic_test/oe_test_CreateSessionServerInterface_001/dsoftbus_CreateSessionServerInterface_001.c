/**
 * @ttitle:测试CreateSessionServer创建session服务端函数，TestRes函数第二个入参为1时是正常测试，为0时是异常测试
 */
#include "dsoftbus_common.h"
#define PACKAGE_NAME "softbus_sample"
#define LOCAL_SESSION_NAME "session_test"

void ComTest()
{
    char *interface_name = "CreateSessionServerInterface";

    ISessionListener sessionCB = {
        .OnSessionOpened = SessionOpened,
        .OnSessionClosed = SessionClosed,
        .OnBytesReceived = ByteRecived,
        .OnMessageReceived = MessageReceived,
    };

    int ret = CreateSessionServer(PACKAGE_NAME, LOCAL_SESSION_NAME, &sessionCB);
    TestRes(ret, 1, interface_name, 1);
    RemoveSessionServer(PACKAGE_NAME, LOCAL_SESSION_NAME);

    ret = CreateSessionServer("", LOCAL_SESSION_NAME, &sessionCB);
    TestRes(ret, 1, interface_name, 2);
    RemoveSessionServer("", LOCAL_SESSION_NAME);

    ret = CreateSessionServer("    ", LOCAL_SESSION_NAME, &sessionCB);
    TestRes(ret, 1, interface_name, 3);
    RemoveSessionServer("    ", LOCAL_SESSION_NAME);

    ret = CreateSessionServer(NULL, LOCAL_SESSION_NAME, &sessionCB);
    TestRes(ret, 0, interface_name, 4);
    RemoveSessionServer(NULL, LOCAL_SESSION_NAME);

    ret = CreateSessionServer(PACKAGE_NAME, "", &sessionCB);
    TestRes(ret, 1, interface_name, 5);
    RemoveSessionServer(PACKAGE_NAME, "");

    ret = CreateSessionServer(PACKAGE_NAME, "    ", &sessionCB);
    TestRes(ret, 1, interface_name, 6);
    RemoveSessionServer(PACKAGE_NAME, "    ");

    ret = CreateSessionServer(PACKAGE_NAME, NULL, &sessionCB);
    TestRes(ret, 0, interface_name, 7);
    RemoveSessionServer(PACKAGE_NAME, NULL);

    ISessionListener worng_sessionCB = {};
    ret = CreateSessionServer(PACKAGE_NAME, LOCAL_SESSION_NAME, &worng_sessionCB);
    TestRes(ret, 0, interface_name, 8);
    RemoveSessionServer(PACKAGE_NAME, LOCAL_SESSION_NAME);

    ret = CreateSessionServer(NULL, NULL, &worng_sessionCB);
    TestRes(ret, 0, interface_name, 9);
    RemoveSessionServer(NULL, NULL);
}

int main(int argc, char **argv)
{
    ComTest();
    return 0;
}
