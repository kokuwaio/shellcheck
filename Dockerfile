# ignore pipefail because
# bash is non-default location https://github.com/tianon/docker-bash/issues/29
# hadolint only uses default locations https://github.com/hadolint/hadolint/issues/977
# hadolint global ignore=DL4006

FROM docker.io/library/bash:5.3.8@sha256:69f5b18444a177abdb2b3c64749a47abdccdd11661a1b7b2731ed23dc1d09ebd
SHELL ["/usr/local/bin/bash", "-u", "-e", "-o", "pipefail", "-c"]

ARG TARGETARCH
RUN [[ $TARGETARCH == amd64 ]] && export ARCH=x86_64; \
	[[ $TARGETARCH == arm64 ]] && export ARCH=aarch64; \
	[[ -z ${ARCH:-} ]] && echo "Unknown arch: $TARGETARCH" && exit 1; \
	wget -q "https://github.com/koalaman/shellcheck/releases/download/v0.11.0/shellcheck-v0.11.0.linux.$ARCH.tar.xz" --output-document=- | \
	tar --xz --extract --to-stdout shellcheck-v0.11.0/shellcheck --strip-components=1 > /usr/local/bin/shellcheck && \
	chmod 555 /usr/local/bin/shellcheck

COPY --chmod=555 entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
USER 1000:1000
