# https://just.systems/man/en/
set fallback := true
set unstable := true
set script-interpreter := ["bash", "-eu"]

REGISTRY_IMAGE := "docker.io/library/registry:2.8.3"
REGISTRY_NAME := "kaniko-registry"
REGISTRY_PORT := "5001"
IMAGE := replace("localhost:_/shellcheck", '_', REGISTRY_PORT)

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

# Build using local repository as cache.
@build: registry-up
	docker run --rm --net=host --volume=$(pwd):/workspace:ro gcr.io/kaniko-project/executor:v1.23.2 --context=/workspace --destination={{IMAGE}}

# Run image against local repository.
run: registry-up
	docker pull {{IMAGE}} >/dev/null
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) {{IMAGE}}

# Inspect image layers with `dive`.
@dive: registry-up
	docker pull {{IMAGE}} >/dev/null
	docker run --rm -it --volume=/var/run/docker.sock:/var/run/docker.sock:ro wagoodman/dive:latest {{IMAGE}}

# Build with local docker daemon.
docker: registry-up
	docker buildx build . --load --quiet --tag={{IMAGE}}:amd64 --platform=linux/amd64
	docker buildx build . --load --quiet --tag={{IMAGE}}:arm64 --platform=linux/arm64
	docker push {{IMAGE}} --all-tags --quiet
	docker manifest rm {{IMAGE}} || true
	docker manifest create {{IMAGE}} --insecure --amend {{IMAGE}}:amd64 --amend {{IMAGE}}:arm64
	docker manifest inspect {{IMAGE}} --verbose
	docker manifest push {{IMAGE}} --purge
	docker pull {{IMAGE}}
	docker image inspect {{IMAGE}}
	docker run --rm --read-only --env=CI=1 --volume=$(pwd):$(pwd):ro --workdir=$(pwd) {{IMAGE}}

# Start local image registry at `http://localhost:{{REGISTRY_PORT}}`.
@registry-up:
	docker volume create {{REGISTRY_NAME}} >/dev/null
	docker ps --format '{{{{.Names}}' | grep {{REGISTRY_NAME}} >/dev/null || docker run --quiet --detach --volume={{REGISTRY_NAME}}:/var/lib/registry --publish={{REGISTRY_PORT}}:5000 --name={{REGISTRY_NAME}} {{REGISTRY_IMAGE}} >/dev/null

# Shutdown local image registry.
@registry-down:
	docker rm {{REGISTRY_NAME}} --force >/dev/null 2>&1
