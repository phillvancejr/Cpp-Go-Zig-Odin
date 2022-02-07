// /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/curl/curl.h
package main

import "core:c"
import "core:fmt"
import "core:strings"
import "core:encoding/json"
import "libcurl"

Person :: struct {
    name: string,
    height: string,
    mass: string,
    hair_color: string,
    skin_color: string,
    eye_color: string,
    birth_year: string,
    gender: string,
    homeworld: string,
    films:[]string,
    species:[]string,
    vehicles:[]string,
    starships:[]string,
    created:string,
    edited:string,
    url:string,
}

response := strings.make_builder_none()

main :: proc() {
    using libcurl
    strings.init_builder_none(&response)

    curl := curl_easy_init()
    defer curl_easy_cleanup(curl)

    curl_easy_setopt(curl, CURLOPT_URL, "https://swapi.dev/api/people/1")
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, proc(buffer: [^]u8, item_size: c.size_t, n_items: c.size_t, ignore: ^any)->c.size_t{
        size := item_size * n_items
        strings.write_bytes(&response, buffer[0:n_items])
        return size
    })

    code := curl_easy_perform(curl)

    if code != CURLE_OK do fmt.printf("download problem! %s\n", curl_easy_strerror(code))

    luke : Person

    e := json.unmarshal(response.buf[:], &luke)
    if e != nil {
        fmt.printf("Could not unmarshal! %v:%v\n", typeid_of(type_of(e)), e)
        return
    }

    fmt.printf("%s has %s eyes\n", luke.name, luke.eye_color)
}