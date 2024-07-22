/**
 * @ttitle:测试SendBytes字节流数据传输能力函数，TestRes函数第二个入参为1时是正常测试，为0时是异常测试
 */
#include "dsoftbus_common.h"

void com_send(int sessionId)
{
    char *interface_name = "SendBytesInterface";

    char cData[] = "hello world test";
    int ret = SendBytes(sessionId, cData, strlen(cData) + 1);
    TestRes(ret, 1, interface_name, 1);

    ret = SendBytes(0, cData, strlen(cData) + 1);
    TestRes(ret, 0, interface_name, 2);

    ret = SendBytes(-1, cData, strlen(cData) + 1);
    TestRes(ret, 0, interface_name, 3);

    ret = SendBytes(999, cData, strlen(cData) + 1);
    TestRes(ret, 0, interface_name, 4);

    char cData1[] = "";
    ret = SendBytes(sessionId, cData1, strlen(cData1) + 1);
    TestRes(ret, 1, interface_name, 5);

    char cData2[] = "    ";
    ret = SendBytes(sessionId, cData2, strlen(cData2) + 1);
    TestRes(ret, 1, interface_name, 6);

    ret = SendBytes(sessionId, cData, 0);
    TestRes(ret, 0, interface_name, 7);

    ret = SendBytes(sessionId, cData, -1);
    TestRes(ret, 0, interface_name, 8);

    ret = SendBytes(sessionId, cData, 9999);
    TestRes(ret, 1, interface_name, 9);

    ret = SendBytes(0, cData1, 0);
    TestRes(ret, 0, interface_name, 10);
}

void ComTest()
{
    NodeBasicInfo *dev = NULL;
    int dev_num, sessionId;
    int timeout = 5;

    dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        return;
    }

    SetGlobalSessionId(-1);
    sessionId = OpenSessionInterface(dev[0].networkId);
    if (sessionId < 0) {
        printf("OpenSessionInterface fail, ret=%d\n", sessionId);
        goto err_OpenSessionInterface;
    }

    while (timeout) {
        if (sessionId == GetGlobalSessionId()) {
            com_send(sessionId);
            break;
        }
        timeout--;
        sleep(1);
    }

    CloseSessionInterface(sessionId);
err_OpenSessionInterface:
    FreeNodeInfoInterface(dev);
}

int main(int argc, char **argv)
{
    PreEnv();
    CommunicationLoop();

    return 0;
}
