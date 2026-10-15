#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <errno.h>
#include <sys/wait.h>
#include <pcap/pcap.h>

static int tests_passed = 0;
static int tests_failed = 0;
static int captured_packets = 0;

#define CHECK(cond, msg) do { \
    if (cond) { printf("ok: %s\n", msg); tests_passed++; } \
    else { printf("FAIL: %s\n", msg); tests_failed++; } \
} while (0)

static void capture_callback(u_char *user, const struct pcap_pkthdr *hdr, const u_char *pkt)
{
    (void)user; (void)hdr; (void)pkt;
    captured_packets++;
}

int main(void)
{
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_t *handle;
    int ret;

    /* Step 1: pcap_lib_version() returns a non-empty string */
    const char *ver = pcap_lib_version();
    CHECK(ver != NULL && strlen(ver) > 0, "pcap_lib_version() returned valid string");

    /* Step 2: pcap_findalldevs() returns available devices */
    struct pcap_if *alldevs = NULL;
    ret = pcap_findalldevs(&alldevs, errbuf);
    CHECK(ret == 0, "pcap_findalldevs() succeeded");

    /* Step 3: At least one network interface was found */
    int dev_count = 0;
    for (struct pcap_if *d = alldevs; d != NULL; d = d->next) {
        dev_count++;
    }
    CHECK(dev_count > 0, "At least one interface found");
    pcap_freealldevs(alldevs);

    /* Step 4: pcap_open_live() opens the loopback device */
    handle = pcap_open_live("lo", 262144, 1, 100, errbuf);
    CHECK(handle != NULL, "pcap_open_live(\"lo\") succeeded");

    if (handle == NULL) {
        fprintf(stderr, "Failed to open lo: %s\n", errbuf);
        goto done;
    }

    /* Step 5: pcap_datalink() returns a valid linktype */
    int linktype = pcap_datalink(handle);
    CHECK(linktype > 0, "pcap_datalink() returned valid linktype");

    /* Step 6: pcap_compile() compiles a BPF filter */
    struct bpf_program fp;
    ret = pcap_compile(handle, &fp, "ip", 0, PCAP_NETMASK_UNKNOWN);
    CHECK(ret == 0, "pcap_compile() compiled BPF filter");

    /* Step 7: pcap_setfilter() installs the compiled filter */
    if (ret == 0) {
        ret = pcap_setfilter(handle, &fp);
        CHECK(ret == 0, "pcap_setfilter() installed BPF filter");
        pcap_freecode(&fp);
    }

    /* Step 8: Set non-blocking mode and spawn traffic generator */
    pcap_setnonblock(handle, 1, errbuf);
    pid_t pid = fork();
    if (pid < 0) {
        fprintf(stderr, "Fork failed: %s\n", strerror(errno));
        tests_failed++;
        goto done;
    }
    if (pid == 0) {
        /* Child: generate loopback TCP traffic via bash /dev/tcp */
        usleep(200000);
        for (int i = 0; i < 20; i++) {
            system("timeout 0.2 bash -c 'exec 3<>/dev/tcp/127.0.0.1/22' 2>/dev/null");
            usleep(50000);
        }
        _exit(0);
    }

    /* Step 9: Use pcap_dispatch to read packets via callback */
    for (int i = 0; i < 200; i++) {
        ret = pcap_dispatch(handle, 100, capture_callback, NULL);
        if (ret == -1) {
            fprintf(stderr, "pcap_dispatch error: %s\n", pcap_geterr(handle));
            break;
        }
        if (captured_packets > 0) break;
        usleep(20000);
    }
    CHECK(captured_packets > 0, "pcap_dispatch() captured packets");

    kill(pid, SIGTERM);
    waitpid(pid, NULL, 0);

    /* Step 10: pcap_close() releases resources */
    pcap_close(handle);
    printf("ok: pcap_close() succeeded\n");
    tests_passed++;

done:
    printf("Summary: %d passed, %d failed\n", tests_passed, tests_failed);
    if (tests_failed == 0) {
        printf("all tests passed\n");
    }
    return (tests_failed == 0) ? 0 : 1;
}
