/**
 * @title:测试PublishService发布特定服务能力函数，
 *    入参PACKAGE_NAME为正常、&info为正常、&cb中OnPublishSuccess = NULL
 */
#include "dsoftbus_common.h"

static int PublishService_NullSuccess()
{
    PublishInfo info = {
        .publishId = DEFAULT_PUBLISH_ID,
        .mode = DISCOVER_MODE_PASSIVE,
        .medium = COAP,
        .freq = LOW,
        .capability = DEFAULT_CAPABILITY,
        .capabilityData = NULL,
        .dataLen = 0,
    };
    IPublishCallback cb = {
        .OnPublishSuccess = NULL,
        .OnPublishFail = PublishFailed,
    };
    return PublishService(PACKAGE_NAME, &info, &cb);
}

int main(int argc, char **argv)
{
    int ret;

    ret = PublishService_NullSuccess();
    if (ret) {
        printf("PublishService fail, ret = %d\n", ret);
        return 1;
    }
    else {
        printf("PublishService success, ret = %d\n", ret);
        return 0;
    }
}