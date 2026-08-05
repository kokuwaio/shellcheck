# https://just.systems/man/en/

[private]
@default:
    just --list --unsorted

# Run linter.
@lint:
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/just:1.58.0
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/shellcheck:v0.11.0
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/hadolint:v2.14.0
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/yamllint:v1.38.0
    docker run --rm --read-only --volume=$PWD:$PWD:rw --workdir=$PWD kokuwaio/markdownlint:0.49.1 --fix
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/renovate-config-validator:44
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD woodpeckerci/woodpecker-cli:v3 lint

# Build image with local docker daemon.
@build:
    docker buildx build . --platform=linux/amd64,linux/arm64

# Inspect image layers with `dive`.
@dive TARGET="":
    dive build . --target={{ TARGET }}

# Test created image.
@test:
    docker buildx build . --load --tag=kokuwaio/shellcheck:dev
    docker run --rm --read-only --volume=$PWD:$PWD:ro --workdir=$PWD kokuwaio/shellcheck:dev
