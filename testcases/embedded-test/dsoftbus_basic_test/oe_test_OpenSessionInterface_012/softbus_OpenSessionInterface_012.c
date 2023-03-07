/**
 * @title:测试OpenSession创建到对端的传输连接函数，
 *    入参OPEN_LOCAL_SESSION_NAME为NULL、OPEN_TARGET_SESSION_NAME为NULL、
 *    peerNetworkId为NULL、 OPEN_DEFAULT_SESSION_GROUP为NULL、&attr为空
 */
#include "dsoftbus_common.h"

static int OpenSession_AllNull(const char *peerNetworkId)
{
    SessionAttribute attr = {
    };

    return OpenSession(NULL, NULL, peerNetworkId, NULL, &attr);
}

static void Communicate_AllNull(void)
{
    NodeBasicInfo *dev = NULL;
    int dev_num, sessionId;

    dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        return;
    }
    SetGlobalSessionId(-1);
    sessionId = OpenSession_AllNull(NULL);
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
                Communicate_AllNull();
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