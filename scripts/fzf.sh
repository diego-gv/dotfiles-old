#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

do_configure() {
	info "[fzf] Configure"
	info "[fzf][configure] Create config file symlink"
	ln -fs "${DOTFILES_DIR}/fzf/fzf-preview.sh" "${XDG_CONFIG_HOME}/fzf/fzf-preview.sh"
}

main() {
	command=$1
	case $command in
	"configure")
		shift
		do_configure "$@"
		;;
	*)
		error "$(basename "$0"): '$command' is not a valid command"
		;;
	esac
}

main "$@"
