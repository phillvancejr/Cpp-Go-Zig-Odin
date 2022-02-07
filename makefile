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

includes=-Ideps
ifeq ($(name), ppm_png)
libs =-Ldeps/stb
libs +=-lstb_image_write
endif

ifeq ($(name), http_json)
libs =-lcurl
endif

std=-std=c++17
all: cc go zig odin

cc: $(wildcard $(name)/*.cc)
	clang++ $(std) -o $(name)/cc_$(name) $(deps) $(libs) $(headers) $(name)/$(name).cc
	$(call bin,cc)
go: $(wildcard $(name)/*.go)
	GO111MODULE="off" go build -o $(name)/go_$(name)  $(name)/$(name).go
	$(call bin,go)
zig: $(wildcard $(name)/*.zig)
	zig build-exe -femit-bin=$(name)/zig_$(name) $(includes) $(libs) $(name)/$(name).zig
	$(call bin,zig)
odin: $(wildcard $(name)/*.odin)
	odin build $(name)/$(name).odin -out:$(name)/odin_$(name)
	$(call bin,odin)

.SILENT: time
time:
	{ time $(MAKE) $(lang) name=$(name); } 2>&1 | grep -Eo 'real.*'

header:
	clang++ $(std) $(name)/headers.hpp -o $(name)/headers.hpp.gch

create:
	touch $(name)/$(name).cc
	touch $(name)/$(name).go
	touch $(name)/$(name).zig
	touch $(name)/$(name).odin