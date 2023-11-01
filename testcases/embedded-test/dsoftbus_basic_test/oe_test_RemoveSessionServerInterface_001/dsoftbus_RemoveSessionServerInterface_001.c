/**
 * @ttitle:测试RemoveSessionServer移除session服务端函数，TestRes函数第二个入参为1时是正常测试，为0时是异常测试
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

    CreateSessionServerInterface();
    int ret = RemoveSessionServer(PACKAGE_NAME, LOCAL_SESSION_NAME);
    TestRes(ret, 1, interface_name, 1);

    CreateSessionServer("", LOCAL_SESSION_NAME, &sessionCB);
    ret = RemoveSessionServer("", LOCAL_SESSION_NAME);
    TestRes(ret, 1, interface_name, 2);

    CreateSessionServer("    ", LOCAL_SESSION_NAME, &sessionCB);
    ret = RemoveSessionServer("    ", LOCAL_SESSION_NAME);
    TestRes(ret, 1, interface_name, 3);

    ret = RemoveSessionServer(NULL, LOCAL_SESSION_NAME);
    TestRes(ret, 0, interface_name, 4);

    CreateSessionServer(PACKAGE_NAME, "", &sessionCB);
    ret = RemoveSessionServer(PACKAGE_NAME, "");
    TestRes(ret, 1, interface_name, 5);

    CreateSessionServer(PACKAGE_NAME, "    ", &sessionCB);
    ret = RemoveSessionServer(PACKAGE_NAME, "    ");
    TestRes(ret, 1, interface_name, 6);

    ret = RemoveSessionServer(PACKAGE_NAME, NULL);
    TestRes(ret, 0, interface_name, 7);

    ret = RemoveSessionServer(NULL, NULL);
    TestRes(ret, 0, interface_name, 8);
}

int main(int argc, char **argv)
{
    ComTest();
    return 0;
}
