#include <fstream>
#include <stdio.h>
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "../deps/stb/stb_image_write.h"

const int width = 20;
const int height = width;

using byte = unsigned char;
byte pixels[width*height*3]{0};

// print to console using ansi escape
void print_pixels(bool ansi) {
    for ( auto y = 0; y < height; y++ ) {
        for ( auto x = 0; x < width*3; x+=3 ) {
            auto r = pixels[y*width*3+x]; 
            auto g = pixels[y*width*3+x + 1];
            auto b = pixels[y*width*3+x + 2];
            if ( ansi ) {
                // white
                auto color = "\x1b[97m";
                if ( r == 0 )
                    // black/gray
                    color = "\x1b[30m";
                printf("%s\u2588\u2588\u2588", color);
            } else {
                if ( r == 255)
                    printf("%d%d%d", r,g,b);
                else
                    printf("000000000");
            }
        }
        puts("\x1b[0m");
    }
}

int main() {

    for ( auto y = 0; y < height; y++) {
        for ( auto x = 0; x < width*3; x +=3) {
            auto scaled_x = x/3;
            // if left half
            auto color = 255;
            if (scaled_x < width/2) {
                // if upper quarter
                if ( y < height / 2)
                    color = 255;
                else
                    color = 0;
            } 
            else { // right half
                // upper right quarter
                if ( y < height / 2)
                    color = 0;
                else
                    color = 255;
            }
            pixels[y*width*3+x]     = color;
            pixels[y*width*3+x + 1] = color;
            pixels[y*width*3+x + 2] = color;
        }
    }
    std::ofstream out{ "ppm_png/out.ppm"};
    // write ppm manually

    out << "P3\n" << width << ' ' << height << "\n255\n";
    for ( auto y = 0; y < height; y++) {
        for ( auto x = 0; x < width*3; x +=3) {
            auto r = std::to_string(pixels[y*width*3+x]); 
            auto g = std::to_string(pixels[y*width*3+x + 1]);
            auto b = std::to_string(pixels[y*width*3+x + 2]);

            out << r << " " << g << " " << b << '\n';
        }
    }
    // write png with stb
    stbi_write_png("ppm_png/out.png", width, height, 3, pixels, width*3);
    // print pixels to console
    print_pixels(true);

}