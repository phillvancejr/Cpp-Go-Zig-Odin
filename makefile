#default: all
default: all2

ifneq ($(MAKECMDGOALS),check)
ifneq ($(MAKECMDGOALS),pbs)
ifndef name
$(error name is not set)
endif
endif
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

ifneq ($(MAKECMDGOALS), d)
libs=-L/usr/local/lib
includes=-I/usr/local/include -Ideps
else
libs=-L-L/usr/local/lib -I.
endif

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

ifeq ($(name), platformer)
ifeq ($(MAKECMDGOALS), d)
libs +=-L-framework -LCoreVideo -L-framework -LIOKit -L-framework -LCocoa -L-framework -LOpenGL -Jplatformer -Ldeps/raylib/libraylib.a
else
libs +=deps/raylib/libraylib.a
libs +=-framework CoreVideo -framework IOKit -framework Cocoa -framework OpenGL
includes +=-Ideps/raylib -Ideps/stb
endif
endif

ifeq ($(name), pong)
ifeq ($(MAKECMDGOALS), d)
libs +=-L-framework -LCoreVideo -L-framework -LIOKit -L-framework -LCocoa -L-framework -LOpenGL -Jplatformer -Ldeps/raylib/libraylib.a -vgc
else
libs +=deps/raylib/libraylib.a
libs +=-framework CoreVideo -framework IOKit -framework Cocoa -framework OpenGL
includes +=-Ideps/raylib -Ideps/stb
endif
endif

std=-std=c++17
all: cc go zig odin
all2: cc d odin

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
janet: $(name)/$(name).janet
	janet $<
janet-build: $(name)/$(name).janet
	cd $(name);jpm build
swift:
	swiftc $(name)/$(name).swift -o $(name)/swift_$(name) -import-objc-header $(name)/swift_lib.h $(libs)
	$(call bin,swift)
rust:
	cd $(name) && cargo run

nim:
	nim c --verbosity:0 -o:$(name)/nim_$(name) $(flags) $(name)/$(name).nim
	$(call bin,nim)
d: $(wildcard $(name)/$(name).d)
	dmd $(name)/$(name).d -of=$(name)/d_$(name) $(libs)
	rm $(name)/d_*.o
	$(call bin,d)
v: $(wildcard $(name)/*.v)
	v $(name)/$(name).v -o $(name)/v_$(name)
	$(call bin,v)


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

check: $(wildcard $(name)/*.odin)
	odin check $(name)/$(name)$(num).odin

create:
	touch $(name)/$(name).cc
	touch $(name)/$(name).go
	touch $(name)/$(name).zig
	touch $(name)/$(name).odin

# phase 2 after zig and go were eliminated
create2:
	touch $(name)/$(name).cc
	touch $(name)/$(name).d
	touch $(name)/$(name).odin
create3:
# phase 3 Go, C# & Swift
	mkdir $(name)
	touch $(name)/$(name).go
	touch $(name)/$(name).swift


create-janet:
	touch $(name)/$(name).janet
	touch $(name)/project.janet
	echo '(declare-project :name "$(name)")' > $(name)/project.janet
	echo '(declare-executable :name "$(name)" :entry "$(name).janet")' >> $(name)/project.janet

create-swift:
	touch $(name)/$(name).swift
	touch $(name)/swift_lib.h

create-nim:
	touch $(name)/$(name).nim

create-rust:
	cd $(name) && \
	echo "fn main(){\n}" > build.rs && \
	cargo init
.PHONY:pbs
pbs:
	dmd -betterC -lib pbs/*.d -of=pbs/libpbs.a