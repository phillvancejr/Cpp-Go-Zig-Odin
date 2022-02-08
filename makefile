default: all
ifndef name
$(error name is not set)
endif

ifdef run
bin=$(name)/$(1)_$(name)
else
bin=
endif

ifndef lang
lang=cc
endif

ifndef pre
headers=
else
headers=-include $(name)/headers.hpp
endif

libs=-L/usr/local/lib
includes=-I/usr/local/include -Ideps

ifeq ($(name), ppm_png)
libs +=-Ldeps/stb
libs +=-lstb_image_write
endif

ifeq ($(name), http_json)
libs +=-lcurl
endif

ifeq ($(name), opengl)
libs +=-lglfw3 -framework Cocoa -framework IOKit -framework OpenGL
libs +=-Ldeps/glad -lglad
includes += -Ideps/glad/include
endif
std=-std=c++17
all: cc go zig odin

ifeq ($(name), build_system)
$(error use individual build commands for each language inside the build_system directory)
endif
cc: $(wildcard $(name)/*.cc)
	clang++ $(std) -o $(name)/cc_$(name) $(includes) $(libs) $(headers) $(opt) $(name)/$(name)$(num).cc
	$(call bin,cc)
go: $(wildcard $(name)/*.go)
	GO111MODULE="off" go build -o $(name)/go_$(name)  $(name)/$(name)$(num).go
	$(call bin,go)
zig: $(wildcard $(name)/*.zig)
	zig build-exe -femit-bin=$(name)/zig_$(name) $(includes) $(libs) $(opt) $(name)/$(name)$(num).zig
	$(call bin,zig)
odin: $(wildcard $(name)/*.odin)
	odin build $(name)/$(name)$(num).odin -out:$(name)/odin_$(name)
	$(call bin,odin)

.SILENT: time
time:
	{ time $(MAKE) $(lang) name=$(name); } 2>&1 | grep -Eo 'real.*'

header:
	clang++ $(std) $(name)/headers.hpp -o $(name)/headers.hpp.gch

client:
	GO111MODULE="off" go build -o echo_server/client echo_server/client.go

libadd:
	clang -c build_system/add.c -o build_system/add.o
	libtool -static -o build_system/libadd.a build_system/add.o
create:
	touch $(name)/$(name).cc
	touch $(name)/$(name).go
	touch $(name)/$(name).zig
	touch $(name)/$(name).odin