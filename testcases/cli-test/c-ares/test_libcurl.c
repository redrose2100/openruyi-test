#include <stdio.h>
#include <curl/curl.h>
#include <curl/easy.h>

int test(char* URL, char* host) {
CURLcode res;
CURL *curl;

if (curl_global_init(CURL_GLOBAL_ALL) != CURLE_OK) {
printf("curl_global_init() failed\n");
return -1;
}
curl = curl_easy_init();

if (!curl) {
printf("curl_easy_init() failed\n");
curl_global_cleanup();
return 1;
}

curl_easy_setopt(curl, CURLOPT_URL, URL);
curl_easy_setopt(curl, CURLOPT_DNS_SERVERS, host);
curl_easy_setopt(curl, CURLOPT_TIMEOUT, 10);
curl_easy_setopt(curl, CURLOPT_FILETIME, 1L);
curl_easy_setopt(curl, CURLOPT_NOBODY, 1L);
curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);

res = curl_easy_perform(curl);

test_cleanup:

curl_easy_cleanup(curl);
curl_global_cleanup();

return (int)res;
}

int main(int argc, char *argv[]) {
test(argv[2], argv[1]);
return 0;
}
