package curl

foreign import _curl "system:curl"

import _c "core:c"

CURLOPT_URL :: 10002;
CURLOPT_WRITEFUNCTION :: 20011;
CURLE_OK :: 0;

CURL :: struct {};
// these values were actually in Enums which bindgen handled correctly
// but since I just needed a few options I wanted them to be numbers
CURLcode :: int
CURLoption :: int

@(default_calling_convention="c")
foreign _curl {

    @(link_name="curl_easy_init")
    curl_easy_init :: proc() -> ^CURL ---;

    @(link_name="curl_easy_setopt")
    curl_easy_setopt :: proc(curl : ^CURL, option : CURLoption, #c_vararg parameter: ..any) -> CURLcode ---;

    @(link_name="curl_easy_perform")
    curl_easy_perform :: proc(curl : ^CURL) -> CURLcode ---;

    @(link_name="curl_easy_cleanup")
    curl_easy_cleanup :: proc(curl : ^CURL) ---;

    @(link_name="curl_easy_strerror")
    curl_easy_strerror :: proc(code : CURLcode) -> cstring ---;

}
