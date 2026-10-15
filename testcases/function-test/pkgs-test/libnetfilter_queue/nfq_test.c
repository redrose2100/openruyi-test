/*
 * Test program for libnetfilter_queue API verification.
 * Tests basic library operations: open, create queue, set mode, destroy, close.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <arpa/inet.h>
#include <linux/netfilter.h>
#include <libnetfilter_queue/libnetfilter_queue.h>

static int queue_callback(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
                          struct nfq_data *nfa, void *data)
{
    int id = 0;
    struct nfqnl_msg_packet_hdr *ph;

    ph = nfq_get_msg_packet_hdr(nfa);
    if (ph)
        id = ntohl(ph->packet_id);

    return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
}

int main(int argc, char **argv)
{
    struct nfq_handle *h = NULL;
    struct nfq_q_handle *qh = NULL;
    int fd;
    int rv;
    char buf[4096];
    int ret = 1;

    /* Step 1: Open library handle */
    h = nfq_open();
    if (!h) {
        fprintf(stderr, "error: nfq_open() failed\n");
        goto cleanup;
    }
    printf("ok: nfq_open() succeeded\n");

    /* Step 2: Unbind existing PF_INET handler (if any) */
    if (nfq_unbind_pf(h, PF_INET) < 0) {
        fprintf(stderr, "error: nfq_unbind_pf() failed\n");
        goto cleanup;
    }
    printf("ok: nfq_unbind_pf() succeeded\n");

    /* Step 3: Bind PF_INET handler */
    if (nfq_bind_pf(h, PF_INET) < 0) {
        fprintf(stderr, "error: nfq_bind_pf() failed\n");
        goto cleanup;
    }
    printf("ok: nfq_bind_pf() succeeded\n");

    /* Step 4: Create queue on queue_num 0 */
    qh = nfq_create_queue(h, 0, &queue_callback, NULL);
    if (!qh) {
        fprintf(stderr, "error: nfq_create_queue() failed\n");
        goto cleanup;
    }
    printf("ok: nfq_create_queue() succeeded\n");

    /* Step 5: Set copy packet mode */
    if (nfq_set_mode(qh, NFQNL_COPY_PACKET, 0xffff) < 0) {
        fprintf(stderr, "error: nfq_set_mode() failed\n");
        goto cleanup;
    }
    printf("ok: nfq_set_mode(NFQNL_COPY_PACKET) succeeded\n");

    /* Step 6: Get file descriptor */
    fd = nfq_fd(h);
    if (fd < 0) {
        fprintf(stderr, "error: nfq_fd() failed\n");
        goto cleanup;
    }
    printf("ok: nfq_fd() returned %d\n", fd);

    /* Step 7: Destroy queue */
    nfq_destroy_queue(qh);
    qh = NULL;
    printf("ok: nfq_destroy_queue() succeeded\n");

    /* Step 8: Close library handle */
    nfq_close(h);
    h = NULL;
    printf("ok: nfq_close() succeeded\n");

    printf("all tests passed\n");
    ret = 0;

cleanup:
    if (qh)
        nfq_destroy_queue(qh);
    if (h)
        nfq_close(h);
    return ret;
}