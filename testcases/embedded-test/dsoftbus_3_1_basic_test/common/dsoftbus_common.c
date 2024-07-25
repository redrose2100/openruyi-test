#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <cjson/cJSON.h>
#include <securec.h>
#include <softbus_common.h>
#include <device_auth.h>
#include <parameter.h>
#include "securec.h"
#include "discovery_service.h"
#include "softbus_bus_center.h"
#include "session.h"
#include "dsoftbus_common.h"

#define PACKAGE_NAME "softbus_sample"
#define LOCAL_SESSION_NAME "session_test"
#define TARGET_SESSION_NAME "session_test"
#define DEFAULT_CAPABILITY "osdCapability"
#define DEFAULT_SESSION_GROUP "group_test"
#define DEFAULT_PUBLISH_ID 123

#define APP_ID "hichain_test"
#define DEFAULT_GROUP_NAME "dsoftbus"
#define DEFAULT_PIN_CODE "123456"
#define MAX_UDID_LEN 65
#define MAX_GROUP_LEN 65
#define ERR_RET -1

#define FIELD_ETH_IP "ETH_IP"
#define FIELD_ETH_PORT "ETH_PORT"
#define FIELD_WLAN_IP "WLAN_IP"
#define FIELD_WLAN_PORT "WLAN_PORT"

const DeviceGroupManager *g_hichainGmInstance = NULL;
char g_udid[MAX_UDID_LEN];
char g_groupId[MAX_GROUP_LEN];
int64_t g_requestId = 1;
int g_para = 0;
int g_sessionId;

enum {
    DEVICE_DISCOVERY = 0,
    DEVICE_JOINING,
    DEVICE_ONLINE,
} DeviceStatus;

char *g_deviceStatus[] = {
    "discovery",
    "joining",
    "online",
};

typedef struct DeviceList {
    struct DeviceList *next;
    DeviceInfo device;
    int status;
    int64_t requestId;
} DeviceList;
DeviceList *g_deviceListHead = NULL;

static const char *GetStringFromJson(const cJSON *obj, const char *key)
{
    cJSON *item;

    if (obj == NULL || key == NULL)
        return NULL;

    item = cJSON_GetObjectItemCaseSensitive(obj, key);
    if (item != NULL && cJSON_IsString(item)) {
        return cJSON_GetStringValue(item);
    } else {
        int len = cJSON_GetArraySize(obj);
        for (int i = 0; i < len; i++) {
            item = cJSON_GetArrayItem(obj, i);
            if (cJSON_IsObject(item)) {
                const char *value = GetStringFromJson(item, key);
                if (value != NULL)
                    return value;
            }
        }
    }
    return NULL;
}

static int HichainSaveGroupID(const char *param)
{
    cJSON *msg = cJSON_Parse(param);
    const char *value = NULL;

    if (msg == NULL) {
        printf("HichainSaveGroupID: cJSON_Parse fail\n");
        return ERR_RET;
    }

    value = GetStringFromJson(msg, FIELD_GROUP_ID);
    if (value == NULL) {
        printf("HichainSaveGroupID:GetStringFromJson fail\n");
        cJSON_Delete(msg);
        return ERR_RET;
    }

    memcpy_s(g_groupId, MAX_GROUP_LEN, value, strlen(value));
    printf("HichainSaveGroupID:groupID=%s\n", g_groupId);

    cJSON_Delete(msg);
    return 0;
}

static void HiChainGmOnFinish(int64_t requestId, int operationCode, const char *returnData)
{
    if (operationCode == GROUP_CREATE && returnData != NULL) {
        printf("create new group finish:requestId=%ld, returnData=%s\n", requestId, returnData);
        HichainSaveGroupID(returnData);
    } else if (operationCode == MEMBER_JOIN) {
        DeviceList *node = g_deviceListHead;

        printf("member join finish:requestId=%ld, returnData=%s\n", requestId, returnData);
        while (node) {
            if (node->requestId != requestId) {
                node = node->next;
                continue;
            }
            node->status = DEVICE_ONLINE;
            break;
        }
    } else {
        printf("<HiChainGmOnFinish>CB:requestId=%ld, operationCode=%d, returnData=%s\n", requestId, operationCode,
            returnData);
    }
}

static void HiChainGmOnError(int64_t requestId, int operationCode, int errorCode, const char *errorReturn)
{
    DeviceList *node = g_deviceListHead;

    printf("<HiChainGmOnError>CB:requestId=%ld, operationCode=%d, errorCode=%d, errorReturn=%s\n", requestId,
        operationCode, errorCode, errorReturn);
    while (node) {
        if (node->requestId != requestId) {
            node = node->next;
            continue;
        }
        node->status = DEVICE_DISCOVERY;
        break;
    }
}

static char *HiChainGmOnRuest(int64_t requestId, int operationCode, const char *reqParams)
{
    cJSON *msg = cJSON_CreateObject();
    char *param = NULL;

    printf("<HiChainGmOnRuest>CB:requestId=%ld, operationCode=%d, reqParams=%s", requestId, operationCode, reqParams);

    if (operationCode != MEMBER_JOIN) {
        return NULL;
    }

    if (msg == NULL) {
        printf("HiChainGmOnRuest: cJSON_CreateObject fail\n");
    }

    if (cJSON_AddNumberToObject(msg, FIELD_CONFIRMATION, REQUEST_ACCEPTED) == NULL ||
        cJSON_AddStringToObject(msg, FIELD_PIN_CODE, DEFAULT_PIN_CODE) == NULL ||
        cJSON_AddStringToObject(msg, FIELD_DEVICE_ID, g_udid) == NULL) {
        printf("HiChainGmOnRuest: cJSON_AddToObject fail\n");
        cJSON_Delete(msg);
        return NULL;
    }

    param = cJSON_PrintUnformatted(msg);
    cJSON_Delete(msg);
    return param;
}

static const DeviceAuthCallback g_groupManagerCallback = {
    .onRequest = HiChainGmOnRuest,
    .onError = HiChainGmOnError,
    .onFinish = HiChainGmOnFinish,
};

static int HichainGmRegCallback(void)
{
    return g_hichainGmInstance->regCallback(APP_ID, &g_groupManagerCallback);
}

static void HichainGmUnRegCallback(void)
{
    g_hichainGmInstance->unRegCallback(APP_ID);
}

static int HichainGmGetGroupInfo(char **groupVec, uint32_t *num)
{
    cJSON *msg = cJSON_CreateObject();
    char *param = NULL;
    int ret = ERR_RET;

    if (msg == NULL) {
        printf("HichainGmGetGroupInfo: cJSON_CreateObject fail\n");
        return ret;
    }

    if (cJSON_AddNumberToObject(msg, FIELD_GROUP_TYPE, PEER_TO_PEER_GROUP) == NULL ||
        cJSON_AddStringToObject(msg, FIELD_GROUP_NAME, DEFAULT_GROUP_NAME) == NULL ||
        cJSON_AddNumberToObject(msg, FIELD_GROUP_VISIBILITY, GROUP_VISIBILITY_PUBLIC) == NULL) {
        printf("HichainGmGetGroupInfo: cJSON_AddToObject fail\n");
        goto err_cJSON_Delete;
    }
    param = cJSON_PrintUnformatted(msg);
    if (param == NULL) {
        printf("HichainGmGetGroupInfo: cJSON_PrintUnformatted fail\n");
        goto err_cJSON_Delete;
    }

    ret = g_hichainGmInstance->getGroupInfo(ANY_OS_ACCOUNT, APP_ID, param, groupVec, num);
    if (ret != 0) {
        printf("getGroupInfo fail:%d", ret);
        goto err_getGroupInfo;
    }

err_getGroupInfo:
    cJSON_free(param);
err_cJSON_Delete:
    cJSON_Delete(msg);
    return ret;
}

static void HichainGmDestroyGroupInfo(char **groupVec)
{
    g_hichainGmInstance->destroyInfo(groupVec);
}

static int HichainGmCreatGroup(void)
{
    cJSON *msg = cJSON_CreateObject();
    char *param = NULL;
    int ret = ERR_RET;

    if (msg == NULL)
        return ret;

    if (cJSON_AddNumberToObject(msg, FIELD_GROUP_TYPE, PEER_TO_PEER_GROUP) == NULL ||
        cJSON_AddStringToObject(msg, FIELD_DEVICE_ID, g_udid) == NULL ||
        cJSON_AddStringToObject(msg, FIELD_GROUP_NAME, DEFAULT_GROUP_NAME) == NULL ||
        cJSON_AddNumberToObject(msg, FIELD_USER_TYPE, 0) == NULL ||
        cJSON_AddNumberToObject(msg, FIELD_GROUP_VISIBILITY, GROUP_VISIBILITY_PUBLIC) == NULL ||
        cJSON_AddNumberToObject(msg, FIELD_EXPIRE_TIME, EXPIRE_TIME_MAX) == NULL) {
        printf("HichainGmCreatGroup: cJSON_AddToObject fail\n");
        cJSON_Delete(msg);
        return ret;
    }
    param = cJSON_PrintUnformatted(msg);
    if (param == NULL) {
        printf("HichainGmCreatGroup: cJSON_PrintUnformatted fail\n");
        cJSON_Delete(msg);
        return ret;
    }

    ret = g_hichainGmInstance->createGroup(ANY_OS_ACCOUNT, g_requestId++, APP_ID, param);

    cJSON_free(param);
    cJSON_Delete(msg);
    return ret;
}

static bool HichainIsDeviceInGroup(const char *groupId, const char *devId)
{
    return g_hichainGmInstance->isDeviceInGroup(ANY_OS_ACCOUNT, APP_ID, groupId, devId);
}

static int HichainGmAddMemberToGroup(DeviceInfo *device, const char *groupId)
{
    cJSON *msg = cJSON_CreateObject();
    cJSON *addr = NULL;
    char *param = NULL;
    int ret = ERR_RET;

    if (msg == NULL) {
        printf("HichainGmAddMemberToGroup: cJSON_CreateObject1 fail\n");
        return ret;
    }

    addr = cJSON_CreateObject();
    if (addr == NULL) {
        printf("HichainGmAddMemberToGroup: cJSON_CreateObject2 fail\n");
        goto err_cJSON_CreateObject;
    }

    for (unsigned int i = 0; i < device->addrNum; i++) {
        if (device->addr[i].type == CONNECTION_ADDR_ETH) {
            if (cJSON_AddStringToObject(addr, FIELD_ETH_IP, device->addr[i].info.ip.ip) == NULL ||
                cJSON_AddNumberToObject(addr, FIELD_ETH_PORT, device->addr[i].info.ip.port) == NULL) {
                printf("HichainGmAddMemberToGroup: cJSON_AddToObject1 fail\n");
                goto err_cJSON_AddToObject;
            }
        } else if (device->addr[i].type == CONNECTION_ADDR_WLAN) {
            if (cJSON_AddStringToObject(addr, FIELD_WLAN_IP, device->addr[i].info.ip.ip) == NULL ||
                cJSON_AddNumberToObject(addr, FIELD_WLAN_PORT, device->addr[i].info.ip.port) == NULL) {
                printf("HichainGmAddMemberToGroup: cJSON_AddToObject2 fail\n");
                goto err_cJSON_AddToObject;
            }
        } else {
            printf("unsupport connection type:%d\n", device->addr[i].type);
            goto err_cJSON_AddToObject;
        }
    }

    param = cJSON_PrintUnformatted(addr);
    if (param == NULL) {
        printf("HichainGmAddMemberToGroup: cJSON_PrintUnformatted1 fail\n");
        goto err_cJSON_AddToObject;
    }

    if (cJSON_AddStringToObject(msg, FIELD_GROUP_ID, groupId) == NULL ||
        cJSON_AddNumberToObject(msg, FIELD_GROUP_TYPE, PEER_TO_PEER_GROUP) == NULL ||
        cJSON_AddStringToObject(msg, FIELD_PIN_CODE, DEFAULT_PIN_CODE) == NULL ||
        cJSON_AddStringToObject(msg, FIELD_DEVICE_ID, g_udid) == NULL ||
        cJSON_AddStringToObject(msg, FIELD_GROUP_NAME, DEFAULT_GROUP_NAME) == NULL ||
        cJSON_AddBoolToObject(msg, FIELD_IS_ADMIN, false) == NULL ||
        cJSON_AddStringToObject(msg, FIELD_CONNECT_PARAMS, param) == NULL) {
        printf("HichainGmAddMemberToGroup: cJSON_AddToObject4 fail\n");
        goto err_cJSON_AddToObject1;
    }

    cJSON_free(param);
    param = cJSON_PrintUnformatted(msg);
    if (param == NULL) {
        printf("HichainGmAddMemberToGroup: cJSON_PrintUnformatted fail\n");
        goto err_cJSON_CreateObject;
    }

    ret = g_hichainGmInstance->addMemberToGroup(ANY_OS_ACCOUNT, g_requestId++, APP_ID, param);
    if (ret != 0) {
        printf("addMemberToGroup fail:%d\n", ret);
    }

err_cJSON_AddToObject1:
    cJSON_free(param);
err_cJSON_AddToObject:
    cJSON_Delete(addr);
err_cJSON_CreateObject:
    cJSON_Delete(msg);
    return ret;
}

int HichainInit(void)
{
    char *groupVec = NULL;
    uint32_t num;
    int ret;

    ret = InitDeviceAuthService();
    if (ret != 0) {
        printf("InitDeviceAuthService fail:%d\n", ret);
        return ret;
    }

    g_hichainGmInstance = GetGmInstance();
    if (g_hichainGmInstance == NULL) {
        printf("GetGmInstance fail\n");
        ret = ERR_RET;
        goto err_GetGmInstance;
    }

    ret = HichainGmRegCallback();
    if (ret != 0) {
        printf("HichainGmregCallback fail.:%d\n", ret);
        goto err_HichainGmRegCallback;
    }

    ret = HichainGmGetGroupInfo(&groupVec, &num);
    if (ret != 0) {
        printf("HichainGmGetGroupInfo fail:%d\n", ret);
        goto err_HichainGmGetGroupInfo;
    }

    if (num == 0) {
        ret = HichainGmCreatGroup();
        if (ret) {
            printf("HichainGmCreatGroup fail:%d\n", ret);
            goto err_HichainGmCreatGroup;
        }
    } else {
        printf("HichainGmGetGroupInfo:num=%u\n", num);
        HichainSaveGroupID(groupVec);
        HichainGmDestroyGroupInfo(&groupVec);
    }

    return 0;

err_HichainGmCreatGroup:
err_HichainGmGetGroupInfo:
    HichainGmUnRegCallback();
err_HichainGmRegCallback:
err_GetGmInstance:
    DestroyDeviceAuthService();
    return ret;
}

static void CheckDeviceStatus(void)
{
    DeviceList *node = g_deviceListHead;
    char *groupVec = NULL;
    uint32_t num;
    int ret;

    ret = HichainGmGetGroupInfo(&groupVec, &num);
    if (ret != 0 || num == 0) {
        printf("HichainGmGetGroupInfo fail\n");
        return;
    }

    ret = HichainSaveGroupID(groupVec);
    if (ret != 0)
        goto err_HichainSaveGroupID;

    while (node) {
        if (HichainIsDeviceInGroup(g_groupId, node->device.devId)) {
            node->status = DEVICE_ONLINE;
        }
        node = node->next;
    }

err_HichainSaveGroupID:
    HichainGmDestroyGroupInfo(&groupVec);
}

static bool CheckDeviceExist(const DeviceInfo *device)
{
    DeviceList *node = g_deviceListHead;

    while (node) {
        if (strcmp(device->devId, node->device.devId) == 0) {
            return true;
        }
        node = node->next;
    }
    return false;
}

static void SaveDeviceInfo(const DeviceInfo *device)
{
    DeviceList *node = malloc(sizeof(DeviceList));

    if (node == NULL) {
        printf("SaveDeviceInfo: malloc fail\n");
        return;
    }

    node->device = *device;
    node->requestId = ERR_RET;
    node->status = DEVICE_DISCOVERY;
    if (g_deviceListHead == NULL) {
        node->next = NULL;
    } else {
        node->next = g_deviceListHead;
    }
    g_deviceListHead = node;
}

static DeviceList *GetDeviceInfo(int idx)
{
    DeviceList *node = g_deviceListHead;
    while (node) {
        if (--idx == 0) {
            return node;
        }
        node = node->next;
    }
    return NULL;
}

static void FreeDeviceInfo()
{
    while (g_deviceListHead) {
        DeviceList *node = g_deviceListHead->next;
        free(g_deviceListHead);
        g_deviceListHead = node;
    }
}

int ListDevice(int para)
{
    DeviceList *node = g_deviceListHead;
    int num = 0;
    g_para = g_para + 1;

    if (node == NULL) {
        printf("Get no device!\n");
        return -1;
    }

    CheckDeviceStatus();
    while (node) {
        printf("\n%d: devName=%s\n", ++num, node->device.devName);
        printf("\tdevId=%s\n", node->device.devId);
        printf("\tstatus=%s\n", g_deviceStatus[node->status]);
        node = node->next;
    }

    node = GetDeviceInfo(1);
    if (node == NULL) {
        printf("GetDeviceInfo fail\n");
        return -1;
    }

    if (node->status == DEVICE_DISCOVERY || g_para == 8) {
        g_para = 0;
        node->requestId = g_requestId;
        node->status = DEVICE_JOINING;
        int ret = HichainGmAddMemberToGroup(&node->device, g_groupId);
        if (ret) {
            printf("HichainGmAddMemberToGroup fail:%d\n", ret);
            node->requestId = ERR_RET;
            node->status = DEVICE_DISCOVERY;
            return -1;
        }
    }

    if (node->status != DEVICE_ONLINE) {
        return -1;
    }

    return 0;
}

void PublishSuccess(int publishId)
{
    printf("<PublishSuccess>CB: publish %d done\n", publishId);
}

void PublishFailed(int publishId, PublishFailReason reason)
{
    printf("<PublishFailed>CB: publish %d failed, reason=%d\n", publishId, (int)reason);
}

int PublishServiceInterface()
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
        .OnPublishSuccess = PublishSuccess,
        .OnPublishFail = PublishFailed,
    };
    return PublishService(PACKAGE_NAME, &info, &cb);
}

void UnPublishServiceInterface(void)
{
    int ret = UnPublishService(PACKAGE_NAME, DEFAULT_PUBLISH_ID);
    if (ret != 0) {
        printf("UnPublishService fail:%d\n", ret);
    }
}

void DeviceFound(const DeviceInfo *device)
{
    printf("<DeviceFound>CB: devName=%s", device->devName);

    if (CheckDeviceExist(device)) {
        printf("device:%s udid:%s is already in List\n", device->devName, device->devId);
        return;
    }
    SaveDeviceInfo(device);
    printf("Result: The peer device is successfully discovered.\n");
}

void DiscoverySuccess(int subscribeId)
{
    printf("<DiscoverySuccess>CB: discover subscribeId=%d\n", subscribeId);
}

void DiscoveryFailed(int subscribeId, DiscoveryFailReason reason)
{
    printf("<DiscoveryFailed>CB: discover subscribeId=%d failed, reason=%d\n", subscribeId, (int)reason);
}

int DiscoveryInterface(void)
{
    SubscribeInfo info = {
        .subscribeId = DEFAULT_PUBLISH_ID,
        .mode = DISCOVER_MODE_ACTIVE,
        .medium = COAP,
        .freq = LOW,
        .isSameAccount = false,
        .isWakeRemote = false,
        .capability = DEFAULT_CAPABILITY,
        .capabilityData = NULL,
        .dataLen = 0,
    };
    IDiscoveryCallback cb = {
        .OnDeviceFound = DeviceFound,
        .OnDiscoverFailed = DiscoveryFailed,
        .OnDiscoverySuccess = DiscoverySuccess,
    };
    return StartDiscovery(PACKAGE_NAME, &info, &cb);
}

void StopDiscoveryInterface(void)
{
    int ret = StopDiscovery(PACKAGE_NAME, DEFAULT_PUBLISH_ID);
    if (ret) {
        printf("StopDiscovery fail:%d\n", ret);
    }
}

int SessionOpened(int sessionId, int result)
{
    printf("<SessionOpened>CB: session %d open fail:%d\n", sessionId, result);
    if (result == 0) {
        g_sessionId = sessionId;
    }

    return result;
}

void SessionClosed(int sessionId)
{
    printf("<SessionClosed>CB: session %d closed\n", sessionId);
}

void ByteRecived(int sessionId, const void *data, unsigned int dataLen)
{
    printf("<ByteRecived>CB: session %d received %u bytes data=%s\n", sessionId, dataLen, (const char *)data);
}

void MessageReceived(int sessionId, const void *data, unsigned int dataLen)
{
    printf("<MessageReceived>CB: session %d received %u bytes message=%s\n", sessionId, dataLen, (const char *)data);
}

int CreateSessionServerInterface(void)
{
    const ISessionListener sessionCB = {
        .OnSessionOpened = SessionOpened,
        .OnSessionClosed = SessionClosed,
        .OnBytesReceived = ByteRecived,
        .OnMessageReceived = MessageReceived,
    };

    return CreateSessionServer(PACKAGE_NAME, LOCAL_SESSION_NAME, &sessionCB);
}

void RemoveSessionServerInterface(void)
{
    int ret = RemoveSessionServer(PACKAGE_NAME, LOCAL_SESSION_NAME);
    if (ret) {
        printf("RemoveSessionServer fail:%d\n", ret);
    }
}

int OpenSessionInterface(const char *peerNetworkId)
{
    SessionAttribute attr = {
        .dataType = TYPE_BYTES,
        .linkTypeNum = 1,
        .linkType[0] = LINK_TYPE_WIFI_WLAN_2G,
        .attr = { RAW_STREAM },
    };

    return OpenSession(LOCAL_SESSION_NAME, TARGET_SESSION_NAME, peerNetworkId, DEFAULT_SESSION_GROUP, &attr);
}

void CloseSessionInterface(int sessionId)
{
    CloseSession(sessionId);
}

int GetAllNodeDeviceInfoInterface(NodeBasicInfo **dev)
{
    int ret, num;

    ret = GetAllNodeDeviceInfo(PACKAGE_NAME, dev, &num);
    if (ret) {
        printf("GetAllNodeDeviceInfo fail:%d\n", ret);
        return -1;
    }

    printf("<GetAllNodeDeviceInfo>return %d Node\n", num);
    for (int i = 0; i < num; i++) {
        printf("<num %d>deviceName=%s\n", i + 1, dev[i]->deviceName);
        printf("\tnetworkId=%s\n", dev[i]->networkId);
        printf("\tType=%d\n", dev[i]->deviceTypeId);
    }

    return num;
}

void FreeNodeInfoInterface(NodeBasicInfo *dev)
{
    FreeNodeInfo(dev);
}

void PreEnv(void)
{
    int ret = GetDevUdid(g_udid, MAX_UDID_LEN);
    if (ret) {
        printf("GetDevUdid fail:%d\n", ret);
    }

    ret = HichainInit();
    if (ret) {
        printf("HichainInit fail\n");
    }

    PublishServiceInterface();
    DiscoveryInterface();
    CreateSessionServerInterface();
    while (ListDevice(g_para) == -1) {
        sleep(3);
        continue;
    }
}

void CleanEnv(void)
{
    UnPublishServiceInterface();
    StopDiscoveryInterface();
    RemoveSessionServerInterface();
    FreeDeviceInfo();
    HichainGmUnRegCallback();
}

void SetGlobalSessionId(int id)
{
    g_sessionId = id;
}

int GetGlobalSessionId()
{
    return g_sessionId;
}

void TestRes(int ret, int mode, char *test_name, int number)
{
    if (mode == 0) {
        if (ret != 0) {
            printf("This interface test success,  ret=%d\n", ret);
        } else {
            printf("This interface test failed,  ret=%d\n", ret);
        }
    } else if (mode == 1) {
        if (ret != 0) {
            printf("This interface test failed,  ret=%d\n", ret);
        } else {
            printf("This interface test success,  ret=%d\n", ret);
        }
    } else if (mode == 2) {
        if (ret > 0) {
            printf("This interface test success,  ret=%d\n", ret);
        } else {
            printf("This interface test failed,  ret=%d\n", ret);
        }
    } else if (mode == 3) {
        if (ret <= 0) {
            printf("This interface test success,  ret=%d\n", ret);
        } else {
            printf("This interface test failed,  ret=%d\n", ret);
        }
    }
    sleep(1);
    printf("This interface is %s,  which is the %d test case.\n", test_name, number);
}

void CommunicationLoop()
{
    bool loop = true;
    while (loop) {
        printf("\nInput c to commnuication, Input s to stop:");
        char op = getchar();
        switch (op) {
            case 'c':
                ComTest();
                loop = false;
            case 's':
                loop = false;
                break;
            default:
                continue;
        }
    }
}
