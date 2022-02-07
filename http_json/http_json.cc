#include <curl/curl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <string_view>
#include <vector>
#include "nlohmann/json.hpp"
using json = nlohmann::json;

struct Person {
    std::string name;
    std::string eye_color;
};

NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(Person, name, eye_color)

std::string data;

struct SwapiRequest {
    CURL* curl;
    SwapiRequest(std::string_view path) {
        curl = curl_easy_init();
        curl_easy_setopt(curl, CURLOPT_URL, path.data());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, +[](char* buffer, size_t item_size, size_t n_items, void* user_data){
            auto size = item_size * n_items;

            data += std::string(buffer, n_items);
            return size;
        });

        if ( auto code = curl_easy_perform(curl) ) {
            printf("download problem! %s\n", curl_easy_strerror(code));
            exit(1);
        }
    }

    ~SwapiRequest() {
        curl_easy_cleanup(curl);
    }
};

int main() {
    auto request = SwapiRequest{ "https://swapi.dev/api/people/1"};

    auto luke = json::parse(data).get<Person>();

    printf("%s has %s eyes\n", luke.name.data(), luke.eye_color.data());
}