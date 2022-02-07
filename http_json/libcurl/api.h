
// odin bindgen doesn't undestand typedef void so I made it a struct
typedef struct{} CURL;
// these values were actually in Enums which bindgen handled correctly
// but since I just needed a few options I wanted them to be numbers
#define CURLOPT_URL 10000+2
#define CURLOPT_WRITEFUNCTION 20011
#define CURLE_OK 0

CURL *curl_easy_init(void);
CURLcode curl_easy_setopt(CURL *curl, CURLoption option, ...);
CURLcode curl_easy_perform(CURL *curl);
void curl_easy_cleanup(CURL *curl);
const char *curl_easy_strerror(CURLcode);
