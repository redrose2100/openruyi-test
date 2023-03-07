#ifndef DSOFTBUS_COMMON_H
#define DSOFTBUS_COMMON_H

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include "securec.h"
#include "session.h"
#include "softbus_common.h"
#include "discovery_service.h"
#include "softbus_bus_center.h"

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

#define FIELD_ETH_IP "ETH_IP"
#define FIELD_ETH_PORT "ETH_PORT"
#define FIELD_WLAN_IP "WLAN_IP"
#define FIELD_WLAN_PORT "WLAN_PORT"

int HichainInit(void);

void SetGlobalSessionId(int id);
int GetGlobalSessionId();
int SessionOpened(int sessionId, int result);
void SessionClosed(int sessionId);
void ByteRecived(int sessionId, const void *data, unsigned int dataLen);
void MessageReceived(int sessionId, const void *data, unsigned int dataLen);

int CreateSessionServerInterface();
void RemoveSessionServerInterface();

void PublishSuccess(int publishId);
void PublishFailed(int publishId, PublishFailReason reason);
int PublishServiceInterface();
void UnPublishServiceInterface();

void DeviceFound(const DeviceInfo *device);
void DiscoverySuccess(int subscribeId);
void DiscoveryFailed(int subscribeId, DiscoveryFailReason reason);

int DiscoveryInterface();
void StopDiscoveryInterface();

int GetAllNodeDeviceInfoInterface(NodeBasicInfo **dev);
int OpenSessionInterface();
void CloseSessionInterface();
void FreeNodeInfoInterface(NodeBasicInfo *dev);
void Communicate();

#endif