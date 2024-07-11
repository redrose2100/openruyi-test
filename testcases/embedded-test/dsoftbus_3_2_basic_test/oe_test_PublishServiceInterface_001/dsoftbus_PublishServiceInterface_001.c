/**
 * @ttitle:测试PublishService发布特定服务能力函数，TestRes函数第二个入参为1时是正常测试，为0时是异常测试
 */
#include "dsoftbus_common.h"
#define DEFAULT_PUBLISH_ID 123
#define DEFAULT_CAPABILITY "osdCapability"
#define PACKAGE_NAME "softbus_sample"
#define WRONG_PACKAGE_1 NULL

void ComTest()
{
    char *interface_name = "PublishServiceInterface";
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
        .OnPublishSuccess = PublishSuccess,
        .OnPublishFail = PublishFailed,
    };

    int ret = PublishService(PACKAGE_NAME, &info, &cb);
    TestRes(ret, 1, interface_name, 1);
    UnPublishService(PACKAGE_NAME, DEFAULT_PUBLISH_ID);

    ret = PublishService("    ", &info, &cb);
    TestRes(ret, 1, interface_name, 2);
    UnPublishService("    ", DEFAULT_PUBLISH_ID);

    ret = PublishService(WRONG_PACKAGE_1, &info, &cb);
    TestRes(ret, 0, interface_name, 3);
    UnPublishService(WRONG_PACKAGE_1, DEFAULT_PUBLISH_ID);

    PublishInfo wrong_info_1 = {};
    ret = PublishService(PACKAGE_NAME, &wrong_info_1, &cb);
    TestRes(ret, 0, interface_name, 4);
    UnPublishService(PACKAGE_NAME, DEFAULT_PUBLISH_ID);

    PublishInfo wrong_info_2 = {
        .publishId = 0,
        .mode = DISCOVER_MODE_PASSIVE,
        .medium = COAP,
        .freq = LOW,
        .capability = DEFAULT_CAPABILITY,
        .capabilityData = NULL,
        .dataLen = 0,
    };
    ret = PublishService(PACKAGE_NAME, &wrong_info_2, &cb);
    TestRes(ret, 1, interface_name, 5);
    UnPublishService(PACKAGE_NAME, 0);

    PublishInfo wrong_info_3 = {
        .publishId = -1,
        .mode = DISCOVER_MODE_PASSIVE,
        .medium = COAP,
        .freq = LOW,
        .capability = DEFAULT_CAPABILITY,
        .capabilityData = NULL,
        .dataLen = 0,
    };
    ret = PublishService(PACKAGE_NAME, &wrong_info_3, &cb);
    TestRes(ret, 1, interface_name, 6);
    UnPublishService(PACKAGE_NAME, -1);

    PublishInfo wrong_info_4 = {
        .publishId = DEFAULT_PUBLISH_ID,
        .mode = DISCOVER_MODE_PASSIVE,
        .medium = COAP,
        .freq = LOW,
        .capability = "",
        .capabilityData = NULL,
        .dataLen = 0,
    };
    ret = PublishService(PACKAGE_NAME, &wrong_info_4, &cb);
    TestRes(ret, 0, interface_name, 7);
    UnPublishService(PACKAGE_NAME, DEFAULT_PUBLISH_ID);

    PublishInfo wrong_info_5 = {
        .publishId = DEFAULT_PUBLISH_ID,
        .mode = DISCOVER_MODE_PASSIVE,
        .medium = COAP,
        .freq = LOW,
        .capability = "   ",
        .capabilityData = NULL,
        .dataLen = 0,
    };
    ret = PublishService(PACKAGE_NAME, &wrong_info_5, &cb);
    TestRes(ret, 0, interface_name, 8);
    UnPublishService(PACKAGE_NAME, DEFAULT_PUBLISH_ID);

    ret = PublishService(WRONG_PACKAGE_1, &wrong_info_1, &cb);
    TestRes(ret, 0, interface_name, 9);
    UnPublishService(PACKAGE_NAME, DEFAULT_PUBLISH_ID);
}

int main(int argc, char **argv)
{
    ComTest();
    return 0;
}
