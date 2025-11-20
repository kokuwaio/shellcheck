# Shellcheck WoodpeckerCI Plugin

[![pulls](https://img.shields.io/docker/pulls/kokuwaio/shellcheck)](https://hub.docker.com/r/kokuwaio/shellcheck)
[![size](https://img.shields.io/docker/image-size/kokuwaio/shellcheck)](https://hub.docker.com/r/kokuwaio/shellcheck)
[![dockerfile](https://img.shields.io/badge/source-Dockerfile%20-blue)](https://git.kokuwa.io/woodpecker/shellcheck/src/branch/main/Dockerfile)
[![license](https://img.shields.io/badge/License-EUPL%201.2-blue)](https://git.kokuwa.io/woodpecker/shellcheck/src/branch/main/LICENSE)
[![prs](https://img.shields.io/gitea/pull-requests/open/woodpecker/shellcheck?gitea_url=https%3A%2F%2Fgit.kokuwa.io)](https://git.kokuwa.io/woodpecker/shellcheck/pulls)
[![issues](https://img.shields.io/gitea/issues/open/woodpecker/shellcheck?gitea_url=https%3A%2F%2Fgit.kokuwa.io)](https://git.kokuwa.io/woodpecker/shellcheck/issues)

A [WoodpeckerCI](https://woodpecker-ci.org) plugin for [shellsheck](https://github.com/koalaman/shellcheck) to lint shell files.  
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
    depends_on: []
    image: kokuwaio/shellcheck:v0.11.0
    settings:
      shell: bash
      severity: error
    when:
      event: pull_request
      path: "**/*.sh"
```

Gitlab: (using script is needed because of <https://gitlab.com/gitlab-org/gitlab/-/issues/19717>)

```yaml
shellcheck:
  needs: []
  stage: lint
  image:
    name: kokuwaio/shellcheck:v0.11.0
    entrypoint: [""]
  script: [/usr/local/bin/entrypoint.sh]
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      changes: ["**/*.sh"]
```

CLI:

```bash
docker run --rm --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/shellcheck --shell=bash --severity=error
```

## Settings

| Settings Name | Environment     | Default  | Description                                                                                                                  |
| ------------- | --------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `shell`       | PLUGIN_SHELL    | `none`   | Specify dialect (sh, bash, dash, ksh, busybox)                                                                               |
| `severity`    | PLUGIN_SEVERITY | `style`  | Minimum [severity](https://github.com/koalaman/shellcheck/wiki/severity) of errors to consider (error, warning, info, style) |
| `include`     | PLUGIN_INCLUDE  | `none`   | Consider only given types of warnings                                                                                        |
| `exclude`     | PLUGIN_EXCLUDE  | `none`   | Exclude types of warnings                                                                                                    |
| `color`       | PLUGIN_COLOR    | `always` | Use color (auto, always, never)                                                                                              |
| `format`      | PLUGIN_FORMAT   | `tty`    | Output format (checkstyle, diff, gcc, json, json1, quiet, tty)                                                               |

## Alternatives

| Image                                                                                   | Comment                           |                                                                            amd64                                                                            |                                                                            arm64                                                                            |
| --------------------------------------------------------------------------------------- | --------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [kokuwaio/shellcheck](https://hub.docker.com/r/kokuwaio/shellcheck)                     | Woodpecker plugin                 | [![size](https://img.shields.io/docker/image-size/kokuwaio/shellcheck?arch=amd64&label=)](https://hub.docker.com/r/kokuwaio/shellcheck)                     | [![size](https://img.shields.io/docker/image-size/kokuwaio/shellcheck?arch=arm64&label=)](https://hub.docker.com/r/kokuwaio/shellcheck)                     |
| [koalaman/shellcheck](https://hub.docker.com/r/koalaman/shellcheck)                     | not a Woodpecker plugin, official | [![size](https://img.shields.io/docker/image-size/koalaman/shellcheck?arch=amd64&label=)](https://hub.docker.com/r/koalaman/shellcheck)                     | [![size](https://img.shields.io/docker/image-size/koalaman/shellcheck?arch=arm64&label=)](https://hub.docker.com/r/koalaman/shellcheck)                     |
| [pipelinecomponents/shellcheck](https://hub.docker.com/r/pipelinecomponents/shellcheck) | not a Woodpecker plugin           | [![size](https://img.shields.io/docker/image-size/pipelinecomponents/shellcheck?arch=amd64&label=)](https://hub.docker.com/r/pipelinecomponents/shellcheck) | [![size](https://img.shields.io/docker/image-size/pipelinecomponents/shellcheck?arch=arm64&label=)](https://hub.docker.com/r/pipelinecomponents/shellcheck) |
