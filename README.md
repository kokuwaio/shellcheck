# Shellcheck Plugin

[![pulls](https://img.shields.io/docker/pulls/kokuwaio/shellcheck)](https://hub.docker.com/repository/docker/kokuwaio/shellcheck)
[![size](https://img.shields.io/docker/image-size/kokuwaio/shellcheck)](https://hub.docker.com/repository/docker/kokuwaio/shellcheck)
[![dockerfile](https://img.shields.io/badge/source-Dockerfile%20-blue)](https://github.com/kokuwaio/shellcheck/blob/main/Dockerfile)
[![license](https://img.shields.io/github/license/kokuwaio/shellcheck)](https://github.com/kokuwaio/shellcheck/blob/main/LICENSE)
[![issues](https://img.shields.io/github/issues/kokuwaio/shellcheck)](https://github.com/kokuwaio/shellcheck/issues)

A [Woodpecker CI](https://woodpecker-ci.org) plugin for [shellsheck](https://github.com/koalaman/shellcheck) to lint shell files.
Also usable with Gitlab, Github or locally, see examples for usage.

## Features

- preconfigure Shellcheck parameters
- searches for shell files recursive
- runnable with local docker daemon

## Example

Woodpecker:

```yaml
steps:
  shellcheck:
    image: kokuwaio/shellcheck
    depends_on: []
    settings:
      shell: bash
      severity: error
    when:
      event: pull_request
      path: "**/*.sh"
```

Gitlab:

```yaml
shellcheck:
  stage: lint
  needs: []
  image: kokuwaio/shellcheck
  variables:
    PLUGIN_SHELL: bash
    PLUGIN_SEVERITY: error
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      changes: ["**/*.sh"]
```

CLI:

```bash
docker run --rm --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/shellcheck --shell=bash --severity=error
```

## Settings

| Settings Name  | Environment     | Default  | Description                                                    |
| -------------- | --------------- | -------- | -------------------------------------------------------------- |
| `shell`        | PLUGIN_SHELL    | `none`   | Specify dialect (sh, bash, dash, ksh, busybox)                 |
| `severity`     | PLUGIN_SEVERITY | `style`  | Minimum [severity](https://github.com/koalaman/shellcheck/wiki/severity) of errors to consider (error, warning, info, style) |
| `include`      | PLUGIN_INCLUDE  | `none`   | Consider only given types of warnings                          |
| `exclude`      | PLUGIN_EXCLUDE  | `none`   | Exclude types of warnings                                      |
| `color`        | PLUGIN_COLOR    | `none`   | Use color (auto, always, never)                                |
| `format`       | PLUGIN_FORMAT   | `tty`    | Output format (checkstyle, diff, gcc, json, json1, quiet, tty) |

## Alternatives

| Image                                                                                   | Comment                           | amd64 | arm64 |
| --------------------------------------------------------------------------------------- | --------------------------------- |:-----:|:-----:|
| [kokuwaio/shellcheck](https://hub.docker.com/r/kokuwaio/shellcheck)                     | Woodpecker plugin                 | [![size](https://img.shields.io/docker/image-size/kokuwaio/shellcheck?arch=amd64&label=)](https://hub.docker.com/repository/docker/kokuwaio/shellcheck) | [![size](https://img.shields.io/docker/image-size/kokuwaio/shellcheck?arch=arm64&label=)](https://hub.docker.com/repository/docker/kokuwaio/shellcheck) |
| [koalaman/shellcheck](https://hub.docker.com/r/koalaman/shellcheck)                     | not a Woodpecker plugin, official | [![size](https://img.shields.io/docker/image-size/koalaman/shellcheck?arch=amd64&label=)](https://hub.docker.com/repository/docker/koalaman/shellcheck) | [![size](https://img.shields.io/docker/image-size/koalaman/shellcheck?arch=arm64&label=)](https://hub.docker.com/repository/docker/koalaman/shellcheck) |
| [pipelinecomponents/shellcheck](https://hub.docker.com/r/pipelinecomponents/shellcheck) | not a Woodpecker plugin           | [![size](https://img.shields.io/docker/image-size/pipelinecomponents/shellcheck?arch=amd64&label=)](https://hub.docker.com/repository/docker/pipelinecomponents/shellcheck) | [![size](https://img.shields.io/docker/image-size/pipelinecomponents/shellcheck?arch=arm64&label=)](https://hub.docker.com/repository/docker/pipelinecomponents/shellcheck) |
