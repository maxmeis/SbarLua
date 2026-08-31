NAME=sketchybar
CFLAGS=-std=c99 -O3 -g -shared -fPIC
PREFIX ?= $(HOME)/.local/share/sketchybar_lua

LUA_DIR ?= lua-5.5.0
LUA_CFLAGS ?= -I$(LUA_DIR)/src
LUA_LIBS ?= -Lbin -llua
LUA_DEPS ?= bin/liblua.a

ifeq ($(shell uname -sm),Darwin arm64)
 ARCH= -arch arm64
else
 ARCH= -arch x86_64
endif

bin/$(NAME).so: src/$(NAME).c src/*.c $(LUA_DEPS) | bin
	clang $(CFLAGS) $(LUA_CFLAGS) $(ARCH) $^ $(LUA_LIBS) -framework CoreFoundation -o bin/$(NAME).so

install: bin/$(NAME).so | $(PREFIX)
	mkdir -p $(PREFIX)
	mv bin/$(NAME).so $(PREFIX)

uninstall:
	rm -rf $(PREFIX)/$(NAME).so

clean:
	rm -rf bin
	cd $(LUA_DIR) && make clean

bin/liblua.a: | bin
	cd $(LUA_DIR) && make
	mv $(LUA_DIR)/src/liblua.a bin

bin:
	mkdir bin

$(PREFIX):
	mkdir -p $(PREFIX)
