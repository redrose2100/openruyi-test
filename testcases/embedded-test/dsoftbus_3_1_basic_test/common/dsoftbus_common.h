#ifndef SOFTBUS_COMMON__H
#define SOFTBUS_COMMON__H
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include "securec.h"
#include "session.h"
#include "softbus_common.h"
#include "discovery_service.h"
#include "softbus_bus_center.h"

int HichainInit(void);

void PublishSuccess(int publishId);
void PublishFailed(int publishId, PublishFailReason reason);
int PublishServiceInterface();
void UnPublishServiceInterface(void);

void DiscoverySuccess(int subscribeId);
void DiscoveryFailed(int subscribeId, DiscoveryFailReason reason);
void DeviceFound(const DeviceInfo *device);
int DiscoveryInterface(void);
void StopDiscoveryInterface(void);

int SessionOpened(int sessionId, int result);
void SessionClosed(int sessionId);
void ByteRecived(int sessionId, const void *data, unsigned int dataLen);
void MessageReceived(int sessionId, const void *data, unsigned int dataLen);
int CreateSessionServerInterface(void);

int GetAllNodeDeviceInfoInterface(NodeBasicInfo **dev);
void FreeNodeInfoInterface(NodeBasicInfo *dev);
int OpenSessionInterface(const char *peerNetworkId);
void CloseSessionInterface(int sessionId);

void SetGlobalSessionId(int id);
int GetGlobalSessionId();
void PreEnv(void);
void CleanEnv(void);
void ComTest();
void CommunicationLoop();

void TestRes(int ret, int mode, char *test_name, int number);


#endif
