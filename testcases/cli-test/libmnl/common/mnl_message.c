#include <linux/genetlink.h>
#include <linux/netlink.h>
#include <libmnl/libmnl.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

struct parsed_data {
    uint32_t number;
    int number_seen;
    int text_seen;
};

static int attribute_callback(const struct nlattr *attribute, void *data)
{
    struct parsed_data *parsed = data;
    uint16_t type = mnl_attr_get_type(attribute);

    if (type == 1) {
        if (mnl_attr_validate(attribute, MNL_TYPE_U32) < 0) {
            return MNL_CB_ERROR;
        }
        parsed->number = mnl_attr_get_u32(attribute);
        parsed->number_seen = 1;
    } else if (type == 2) {
        if (mnl_attr_validate(attribute, MNL_TYPE_STRING) < 0) {
            return MNL_CB_ERROR;
        }
        if (strcmp(mnl_attr_get_str(attribute), "libmnl") != 0) {
            return MNL_CB_ERROR;
        }
        parsed->text_seen = 1;
    }
    return MNL_CB_OK;
}

int main(void)
{
    char buffer[MNL_SOCKET_BUFFER_SIZE];
    struct nlmsghdr *header;
    struct genlmsghdr *generic_header;
    struct parsed_data parsed = {0};
    struct mnl_socket *socket;

    header = mnl_nlmsg_put_header(buffer);
    header->nlmsg_type = 0x10;
    header->nlmsg_flags = NLM_F_REQUEST;
    header->nlmsg_seq = 7;
    generic_header = mnl_nlmsg_put_extra_header(header, sizeof(*generic_header));
    generic_header->cmd = 1;
    generic_header->version = 1;
    mnl_attr_put_u32(header, 1, 1234);
    mnl_attr_put_str(header, 2, "libmnl");

    if (mnl_nlmsg_ok(header, header->nlmsg_len) != 1 ||
        mnl_attr_parse(header, sizeof(*generic_header), attribute_callback,
                       &parsed) < 0 || parsed.number != 1234 ||
        !parsed.number_seen || !parsed.text_seen) {
        return 1;
    }

    socket = mnl_socket_open(NETLINK_ROUTE);
    if (socket == NULL || mnl_socket_bind(socket, 0, MNL_SOCKET_AUTOPID) < 0 ||
        mnl_socket_get_portid(socket) == 0) {
        if (socket != NULL) {
            mnl_socket_close(socket);
        }
        return 1;
    }
    mnl_socket_close(socket);
    printf("MNL_RESULT message_and_socket_ok\n");
    return 0;
}
