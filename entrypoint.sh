#!/usr/bin/env bash
set -eu;

##
## build command
##

COMMAND="shellcheck"
if [[ -n "${PLUGIN_FORMAT:-}" ]]; then
	COMMAND+=" --format=$PLUGIN_FORMAT"
fi
if [[ -n "${PLUGIN_COLOR:-}" ]]; then
	COMMAND+=" --color=$PLUGIN_COLOR"
else
	COMMAND+=" --color=always"
fi
if [[ -n "${PLUGIN_SHELL:-}" ]]; then
	COMMAND+=" --shell=$PLUGIN_SHELL"
fi
if [[ -n "${PLUGIN_SEVERITY:-}" ]]; then
	COMMAND+=" --severity=$PLUGIN_SEVERITY"
fi
if [[ -n "${PLUGIN_INCLUDE:-}" ]]; then
	COMMAND+=" --include=$PLUGIN_INCLUDE"
fi
if [[ -n "${PLUGIN_EXCLUDE:-}" ]]; then
	COMMAND+=" --exclude=$PLUGIN_EXCLUDE"
fi

# custom args, e.g. docker run --rm --volume=$(pwd):$(pwd) --workdir=$(pwd) --env=CI=test kokuwaio/shellcheck --format=json
if [[ -n "${1:-}" ]]; then
	COMMAND+=" $*"
fi

##
## collect files (https://www.shellcheck.net/wiki/Recursiveness)
##

FILES=$(find "$(pwd)" -type f \
	\( -name '*.sh' \
	-o -name '*.ksh' \
	-o -name '*.bash' \
	-o -name '*.bashrc' \
	-o -name '*.bash_profile' \
	-o -name '*.bash_login' \
	-o -name '*.bash_logout' \) \
	-not -path '*/node_modules/*')
if [[ ! "$FILES" ]]; then
	echo "No files found!"
	exit 1
fi
for FILE in ${FILES}; do
	COMMAND+=" \n $FILE"
done

##
## execute command
##

if [[ -n "${CI:-}" ]]; then
	echo -e "$COMMAND"
else
	echo -e "${COMMAND//\\n/}"
fi
eval "${COMMAND//\\n/}"
