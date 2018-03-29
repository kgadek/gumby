.PHONY: build image
# https://stackoverflow.com/a/23324703/547223
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
# https://stackoverflow.com/a/12959764/547223
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

build-cache/target/x86_64-unknown-linux-musl/release/gumby: $(call rwildcard,src/,*.rs) Cargo.toml
	mkdir -p build-cache/registry
	mkdir -p build-cache/target
	docker run --rm -v "${ROOT_DIR}/build-cache/registry":/home/rust/.cargo/registry:rw -v "${ROOT_DIR}":/home/rust/src:ro -v "${ROOT_DIR}/build-cache/target":/home/rust/src/target:rw ekidd/rust-musl-builder:stable cargo build --release

build: build-cache/target/x86_64-unknown-linux-musl/release/gumby

image: build
	docker build -t kgadek/gumby .
