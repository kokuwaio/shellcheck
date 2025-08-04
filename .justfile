# https://just.systems/man/en/

[private]
@default:
	just --list --unsorted

# Run linter.
@lint:
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/shellcheck
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/hadolint
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/yamllint
	docker run --rm --read-only --volume=$(pwd):$(pwd):rw --workdir=$(pwd) kokuwaio/markdownlint --fix
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/renovate-config-validator
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) woodpeckerci/woodpecker-cli lint

# Build image with local docker daemon.
@build:
	docker buildx build . --build-arg=NPM_CONFIG_REGISTRY --platform=linux/amd64,linux/arm64

# Inspect image layers with `dive`.
@dive TARGET="":
	dive build . --build-arg=NPM_CONFIG_REGISTRY --target={{TARGET}}

# Test created image.
@test:
	docker build . --tag=kokuwaio/shellcheck:dev
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/shellcheck:dev
