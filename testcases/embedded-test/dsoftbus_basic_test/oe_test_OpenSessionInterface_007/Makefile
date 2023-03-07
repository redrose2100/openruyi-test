TARGET = OpenSessionInterface_007
OBJECTS = softbus_OpenSessionInterface_007.o
COMMON_DIR := ../oe_test_dsoftbus_common

LIBS = -lsoftbus_client.z -lsyspara.z -ldeviceauth_sdk.z -lsec_shared.z -lsoftbus_utils.z -lsoftbus_common
CFLAGS=-Wall

.PHNOY:all
all: ${TARGET}
obj: ${OBJECTS}

${TARGET} : ${OBJECTS} Makefile
	${CC} -o ${TARGET} ${OBJECTS} ${LIBS} -L${COMMON_DIR}
%.o: %.c
	${CC} ${CFLAGS} -c $< -I${COMMON_DIR}
.PHNOY: clean
clean:
	-rm -rf ${TARGET} ${OBJECTS}