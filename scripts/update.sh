#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

DOTFILES_DIR="${DOTFILES_DIR:=${HOME}/dotfiles}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

function main() {
	system
	if ! is_wsl ; then
		snap_packages
	fi
	omz
}

function system() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Retrieve new lists of packages"
	sudo apt-get update -qq

	info "[${funcname}] Upgrade packages"
	sudo apt-get upgrade -y

	info "[${funcname}] Remove unused packages"
	sudo apt-get autoclean -y

	info "[${funcname}] Erase old downloaded archive files"
	sudo apt-get autoremove -y
}

function omz() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Update"
	(
		cd "${DOTFILES_DIR}"
		./scripts/ohmyzsh.sh update_plugins
	)
	zsh -c 'source ${HOME}/.zshrc && omz update && exit'
}

function snap_packages() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Retrieve new lists of packages"
	sudo snap refresh --list

	info "[${funcname}] Upgrade packages"
	sudo snap refresh
}

main
