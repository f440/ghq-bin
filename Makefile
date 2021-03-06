VERSION := $(shell cat VERSION)

.PHONY: all
all: clone image-update version-up build commit

.PHONY: clone
clone:
	if [ ! -d repo ]; then git clone ssh://aur@aur.archlinux.org/ghq-bin.git repo ; else cd repo && git pull; fi

.PHONY: image-update
image-update:
	docker pull archlinux:latest

.PHONY: version-up
version-up:
	./update.sh $(VERSION)

.PHONY: build
build:
	uid=${shell id -u} docker-compose up

.PHONY: commit
commit:
	cd repo && git diff
	cd repo && git commit -a -m "Bump up version number to $(VERSION)"
	cd repo && git push --dry-run && echo "ready to push"
	git commit -a -m "Bump up version number to $(VERSION)"

.PHONY: push
push:
	cd repo && git push origin HEAD

.PHONY: clean
clean:
	uid=${shell id -u} docker-compose down
