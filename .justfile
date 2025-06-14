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
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/renovate
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) woodpeckerci/woodpecker-cli lint

# Build image with local docker daemon.
@build:
	docker build . --tag=kokuwaio/shellcheck:dev --load

# Inspect image with docker.
@inspect: build
	docker image inspect kokuwaio/shellcheck:dev

# Inspect image layers with `dive`.
@dive: build
	docker run --rm -it --volume=/var/run/docker.sock:/var/run/docker.sock:ro wagoodman/dive:latest kokuwaio/shellcheck:dev
