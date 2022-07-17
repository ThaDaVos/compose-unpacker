# See: https://gist.github.com/asukakenji/f15ba7e588ac42795f421b48b8aede63
# For a list of valid GOOS and GOARCH values
# Note: these can be overriden on the command line e.g. `make PLATFORM=<platform> ARCH=<arch>`
PLATFORM=$(shell go env GOOS)
ARCH=$(shell go env GOARCH)

ifeq ("$(PLATFORM)", "windows")
bin=compose-unpacker.exe
else
bin=compose-unpacker
endif
dist := dist
image := portainer/compose-unpacker:latest
.PHONY: pre build release image clean download-binaries

download-binaries:
	@./setup.sh $(PLATFORM) $(ARCH)

pre:
	mkdir -pv $(dist)

build: pre download-binaries
	GOOS="$(shell go env GOOS)" GOARCH="$(shell go env GOARCH)" CGO_ENABLED=0 go build -a --installsuffix cgo --ldflags '-s' -o dist/$(bin)

image: release
	docker build -f build/$(PLATFORM)/Dockerfile -t $(image) .

clean:
	rm -rf $(dist)/*
