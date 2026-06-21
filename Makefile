NAME    := $(shell sed -n 's/^name *= *"\(.*\)"/\1/p' typst.toml)
VERSION := $(shell sed -n 's/^version *= *"\(.*\)"/\1/p' typst.toml)

PKG_DIR = $(out)/share/typst/packages/preview/$(NAME)/$(VERSION)

.PHONY: all check install

all:

check:
	tests/run-tests.sh

install:
	mkdir -p "$(PKG_DIR)"
	cp -r LICENSE README.md lib.typ typst.toml "$(PKG_DIR)"
