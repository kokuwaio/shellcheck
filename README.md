# Shellcheck Plugin

A [Woodpecker](https://woodpecker-ci.org) plugin for [Shellsheck](https://www.shellcheck.net/).
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

| Image                                                                                   | Comment                           | amd64 | arm64 | Un-/Compressed Size   |
| --------------------------------------------------------------------------------------- | --------------------------------- |:-----:|:-----:|:---------------------:|
| [kokuwaio/shellcheck](https://hub.docker.com/r/kokuwaio/shellcheck)                     | Woodpecker plugin                 | ✅    | ✅    | 30.148 MB /  9.858 MB |
| [koalaman/shellcheck](https://hub.docker.com/r/koalaman/shellcheck)                     | not a Woodpecker plugin, official | ✅    | ✅    |  6.051 MB /  1.611 MB |
| [pipelinecomponents/shellcheck](https://hub.docker.com/r/pipelinecomponents/shellcheck) | not a Woodpecker plugin           | ✅    | ❌    | 58.160 MB / 21.245 MB |

Remarks:

- Size measured with amd64 architecture
- **Uncompressed**: size on your disk
- **Compressed**: transferred from registry to disk, important for CI runners/agents that di not cache images
- Data collected: 01.02.2025
