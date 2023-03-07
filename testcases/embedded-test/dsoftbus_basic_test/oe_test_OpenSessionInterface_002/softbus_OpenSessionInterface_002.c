/**
 * @title:测试OpenSession创建到对端的传输连接函数，
 *   入参OPEN_LOCAL_SESSION_NAME为NULL、OPEN_TARGET_SESSION_NAME为正常、
 *   peerNetworkId为正常、 OPEN_DEFAULT_SESSION_GROUP为正常、&attr为正常
 */
#include "dsoftbus_common.h"

static int OpenSession_NullSessionName(const char *peerNetworkId)
{
    SessionAttribute attr = {
        .dataType = TYPE_BYTES,
        .linkTypeNum = 1,
        .linkType[0] = LINK_TYPE_WIFI_WLAN_2G,
        .attr = { RAW_STREAM },
    };

    return OpenSession(NULL, TARGET_SESSION_NAME, peerNetworkId, DEFAULT_SESSION_GROUP, &attr);
}

static void Communicate_NullSessionName(void)
{
    NodeBasicInfo *dev = NULL;
    int dev_num, sessionId;

    dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        return;
    }

    sessionId = OpenSession_NullSessionName(dev[0].networkId);
    if (sessionId < 0) {
        printf("OpenSessionInterface fail, ret=%d\n", sessionId);
    } else {
        printf("OpenSessionInterface success, ret=%d\n", sessionId);
    }
}

int main(int argc, char **argv)
{
    bool loop = true;
    int ret;

    HichainInit();

    ret = CreateSessionServerInterface();
    if (ret) {
        printf("CreateSessionServer fail, ret=%d\n", ret);
        return ret;
    }

    ret = PublishServiceInterface();
    if (ret) {
        printf("PublishService fail, ret=%d\n", ret);
        goto err_PublishServiceInterface;
    }

    ret = DiscoveryInterface();
    if (ret) {
        printf("DiscoveryInterface fail, ret=%d\n", ret);
        goto err_DiscoveryInterface;
    }

    while (loop) {
        printf("\nInput c to commnuication, Input s to stop:");
        char op = getchar();
        switch (op) {
            case 'c':
                Communicate_NullSessionName();
                continue;
            case 's':
                loop = false;
                break;
            case '\n':
                break;
            default:
                continue;
        }
    }

    StopDiscoveryInterface();
err_DiscoveryInterface:
    UnPublishServiceInterface();
err_PublishServiceInterface:
    RemoveSessionServerInterface();
    return 0;
}