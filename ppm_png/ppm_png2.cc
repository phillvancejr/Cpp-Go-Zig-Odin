#include <fstream>
#include <stdio.h>

const int width = 8;
const int height = width;

using byte = unsigned char;
byte pixels[width*height*3]{0};

void print_pixels() {
    for ( auto y = 0; y < height; y++ ) {
        printf("%d. ", y+1);
        for ( auto x = 0; x < width*3; x+=3 ) {
            auto r = pixels[y*width*3+x]; 
            auto g = pixels[y*width*3+x + 1];
            auto b = pixels[y*width*3+x + 2];
            printf("%d %d %d | ", r,g,b);
        }
        puts("");
    }
}

int main() {

    for ( auto y = 0; y < height; y++) {
        for ( auto x = 0; x < width*3; x +=3) {
            printf("x: %d\n",x);
            pixels[y*width*3+x]     = x/3 < width/2 ? 255 : 0;
            pixels[y*width*3+x + 1] = x/3 < width/2 ? 255 : 0;
            pixels[y*width*3+x + 2] = x/3 < width/2 ? 255 : 0;
        }
    }
    std::ofstream out{ "out.ppm"};

    out << "P3\n" << width << ' ' << height << "\n255\n";
    for ( auto y = 0; y < height; y++) {
        for ( auto x = 0; x < width*3; x +=3) {
            auto r = std::to_string(pixels[y*width*3+x]); 
            auto g = std::to_string(pixels[y*width*3+x + 1]);
            auto b = std::to_string(pixels[y*width*3+x + 2]);

            out << r << " " << g << " " << b << '\n';
        }
    }

    print_pixels();

    // Image


    // Render
    // std::ofstream test {"test.ppm"};
    // test << "P3\n" << width << ' ' << height << "\n255\n";

    // for (int j = height-1 ; j >= 0; j--) {
    //     for (int i = 0; i < width; i++) {
    //         auto r = double(i) / (width-1);
    //         auto g = double(j) / (height-1);
    //         auto b = 0.25;

    //         int ir = static_cast<int>(255.999 * r);
    //         int ig = static_cast<int>(255.999 * g);
    //         int ib = static_cast<int>(255.999 * b);

    //         pixels[ j * width+ i ] = ir;
    //         pixels[ j * width+ i +1 ] = ig;
    //         pixels[ j * width+ i +2 ] = ib;
    //         test << ir << ' ' << ig << ' ' << ib << '\n';
    //     }
    // }

}