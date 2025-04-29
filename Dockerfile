##
## Download shellcheck
##

FROM docker.io/library/debian:12.10-slim@sha256:4b50eb66f977b4062683ff434ef18ac191da862dbe966961bc11990cf5791a8d AS build
SHELL ["/bin/bash", "-u", "-e", "-o", "pipefail", "-c"]
RUN --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
	apt-get -qq update && \
	apt-get -qq install --yes --no-install-recommends ca-certificates wget xz-utils && \
	rm -rf /etc/*- /var/lib/dpkg/*-old /var/lib/dpkg/status /var/cache/* /var/log/*

# https://github.com/koalaman/shellcheck/tags
# https://github.com/koalaman/shellcheck/issues/2137 - Request to Add Checksums to Releases

ARG SHELLCHECK_VERSION=v0.10.0
RUN ARCH=$(dpkg --print-architecture) && \
	[[ $ARCH == amd64 ]] && export SUFFIX=x86_64; \
	[[ $ARCH == arm64 ]] && export SUFFIX=aarch64; \
	[[ $ARCH == armhf ]] && export SUFFIX=armv6hf; \
	[[ -z ${SUFFIX:-} ]] && echo "Unknown arch: $ARCH" && exit 1; \
	wget --no-hsts --quiet "https://github.com/koalaman/shellcheck/releases/download/$SHELLCHECK_VERSION/shellcheck-$SHELLCHECK_VERSION.linux.$SUFFIX.tar.xz" --output-document=- | \
	tar --xz --extract --to-stdout shellcheck-$SHELLCHECK_VERSION/shellcheck --strip-components=1 > /usr/local/bin/shellcheck

##
## Final stage
##

FROM docker.io/library/bash:5.2.37@sha256:64defcbc5126c2d81122b4fb78a629a6d27068f0842c4a8302b8273415b12e30
COPY --link --chown=0:0 --chmod=555 --from=build /usr/local/bin/shellcheck /usr/local/bin/shellcheck
COPY --link --chown=0:0 --chmod=555 entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/bash", "/usr/local/bin/entrypoint.sh"]
USER 1000:1000
