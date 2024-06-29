/**
 * @ttitle:测试OpenSession创建到对端的传输连接函数，TestRes函数第二个入参为2时是正常测试，为3时是异常测试
 */
#include "dsoftbus_common.h"
#define OPEN_LOCAL_SESSION_NAME "session_test"
#define OPEN_TARGET_SESSION_NAME "session_test"
#define OPEN_DEFAULT_SESSION_GROUP "group_test"

void ComTest()
{
    char *interface_name = "OpenSessionInterface";
    NodeBasicInfo *dev = NULL;
    int dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        return;
    }

    SessionAttribute attr = {
        .dataType = TYPE_BYTES,
        .linkTypeNum = 1,
        .linkType[0] = LINK_TYPE_WIFI_WLAN_2G,
        .attr = { RAW_STREAM },
    };

    int ret = OpenSession(OPEN_LOCAL_SESSION_NAME, OPEN_TARGET_SESSION_NAME, dev[0].networkId,
        OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 2, interface_name, 1);
    CloseSessionInterface(ret);

    ret = OpenSession(NULL, OPEN_TARGET_SESSION_NAME, dev[0].networkId, OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 3, interface_name, 2);
    CloseSessionInterface(ret);

    ret = OpenSession("wrong", OPEN_TARGET_SESSION_NAME, dev[0].networkId, OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 3, interface_name, 3);
    CloseSessionInterface(ret);

    ret = OpenSession("", OPEN_TARGET_SESSION_NAME, dev[0].networkId, OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 3, interface_name, 4);
    CloseSessionInterface(ret);

    ret = OpenSession("    ", OPEN_TARGET_SESSION_NAME, dev[0].networkId, OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 3, interface_name, 5);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, NULL, dev[0].networkId, OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 3, interface_name, 6);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, "wrong", dev[0].networkId, OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 2, interface_name, 7);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, "", dev[0].networkId, OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 2, interface_name, 8);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, "    ", dev[0].networkId, OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 2, interface_name, 9);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, OPEN_TARGET_SESSION_NAME, NULL, OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 3, interface_name, 10);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, OPEN_TARGET_SESSION_NAME, "wrong", OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 3, interface_name, 11);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, OPEN_TARGET_SESSION_NAME, "", OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 3, interface_name, 12);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, OPEN_TARGET_SESSION_NAME, "    ", OPEN_DEFAULT_SESSION_GROUP, &attr);
    TestRes(ret, 3, interface_name, 13);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, OPEN_TARGET_SESSION_NAME, dev[0].networkId, NULL, &attr);
    TestRes(ret, 3, interface_name, 14);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, OPEN_TARGET_SESSION_NAME, dev[0].networkId, "wrong", &attr);
    TestRes(ret, 2, interface_name, 15);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, OPEN_TARGET_SESSION_NAME, dev[0].networkId, "", &attr);
    TestRes(ret, 2, interface_name, 16);
    CloseSessionInterface(ret);

    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, OPEN_TARGET_SESSION_NAME, dev[0].networkId, "    ", &attr);
    TestRes(ret, 2, interface_name, 17);
    CloseSessionInterface(ret);

    SessionAttribute attr1 = {};
    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, OPEN_TARGET_SESSION_NAME, dev[0].networkId, OPEN_DEFAULT_SESSION_GROUP,
        &attr1);
    TestRes(ret, 3, interface_name, 18);
    CloseSessionInterface(ret);

    SessionAttribute attr2 = {
        .linkType[0] = LINK_TYPE_WIFI_WLAN_2G,
        .attr = { RAW_STREAM },
    };
    ret = OpenSession(OPEN_LOCAL_SESSION_NAME, OPEN_TARGET_SESSION_NAME, dev[0].networkId, OPEN_DEFAULT_SESSION_GROUP,
        &attr2);
    TestRes(ret, 3, interface_name, 19);
    CloseSessionInterface(ret);

    ret = OpenSession(NULL, NULL, NULL, NULL, &attr1);
    TestRes(ret, 3, interface_name, 20);
    CloseSessionInterface(ret);

    FreeNodeInfoInterface(dev);
}

int main(int argc, char **argv)
{
    PreEnv();
    CommunicationLoop();
    CleanEnv();
    return 0;
}
