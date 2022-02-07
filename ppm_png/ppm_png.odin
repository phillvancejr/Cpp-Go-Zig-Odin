package main

import "core:fmt"
import "core:os"
import "vendor:stb/image"

width :: 20
height :: width
components :: 3
pixels : [width*height*3]byte

main :: proc() {
    // write checker pattern
    for y in 0 .. height {
        for x:= 0; x < width * components; x += components {
            scaled_x := x/3
            // white
            color : byte = 255
            if scaled_x < width/2 {
                if y < height/2 do color = 255
                else do color = 0
            } else {
                if y < height/2 do color = 0
                else do color = 255
            }
            pixels[y*width*components+x    ] = color
            pixels[y*width*components+x + 1] = color
            pixels[y*width*components+x + 2] = color
        }
    }

    ppm, e := os.open("ppm_png/out.ppm", os.O_RDWR | os.O_TRUNC)
    if e != os.ERROR_NONE {
        fmt.eprintln("could not open file: ", os.get_last_error_string())
        return
    }
    defer os.close(ppm)

    fmt.fprintf(ppm, "P3\n%d %d\n255\n", width, height)

    for y in 0 .. height {
        for x:= 0; x < width * components; x += components {
            r := pixels[y*width*components+x    ]
            g := pixels[y*width*components+x + 1]
            b := pixels[y*width*components+x + 2]

            fmt.fprintf(ppm, "%d %d %d\n", r, g, b)
        }
    }
    image.write_png("ppm_png/out.png", width, height, components, &pixels[0], width*components)
    // print pixels to console
    print_pixels(true)
}

print_pixels :: proc(ansi: bool) {
    for y in 0 .. height {
        for x:= 0; x < width * components; x += components {
            r := pixels[y*width*components+x    ]
            g := pixels[y*width*components+x + 1]
            b := pixels[y*width*components+x + 2]

            if ansi {
                // white
                color := "\x1b[97m"
                // black/dark gray
                if r == 0 do color = "\x1b[30m"
                fmt.printf("%s\u2588\u2588\u2588", color)

            } else {
                // if not using ansi just print text representation
                if r == 255 do fmt.printf("%d%d%d", r,g,b)
                else do fmt.print("000000000")
            }
        }
        fmt.println("\x1b[0m")
    }
}