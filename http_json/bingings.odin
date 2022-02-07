package main

import "core:bindgen"

main :: proc() {
    options : bindgen.GeneratorOptions
    bindgen.generate(
        packageName = "curl",
        foreignLibrary = "system:curl",
        outputFile = "libcurl/curl.odin",
        headerFiles = []string{"libcurl/api.h"},
        options = options,
    )
}