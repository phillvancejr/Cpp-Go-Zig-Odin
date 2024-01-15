default: build
build: shaders
	clang++ -o metalcc -std=c++20 -framework AppKit -framework MetalKit -framework Metal -Wno-auto-var-id metal.mm

shaders:
	xcrun -sdk macosx metal -c shaders.metal -o shaders.air
	xcrun -sdk macosx metallib shaders.air -o shaders.metallib