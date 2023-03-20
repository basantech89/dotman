#!/usr/bin/env bash

. ./src/utils/colors.sh
. ./src/utils/helpers.sh
. ./src/setup.sh
. ./src/manage.sh

IFS=$'\n'

VERSION="v0.1.0"

catch_ctrl+c() {
  goodbye
  exit
}

init_check() {
	prerequisites
	trap 'catch_ctrl+c' SIGINT

	# -z checks if a variabe is not set
  if [[ -z ${DOT_REPO} && -z ${DOT_DEST} ]]; then
    initial_setup
		goodbye
  else
		repo_check
    manage
  fi
}

intro() {
	BOSS_NAME=$LOGNAME
	printf "\n\a%s" "Hi ${BOLD}${TITLE}$BOSS_NAME${RESET} 👋"
	logo
}

if [[ $1 == "version" || $1 == "--version" || $1 == "-v" ]]; then
	if [[ -d "$HOME/dotman" ]]; then
		latest_tag=$(git -C "$HOME/dotman" describe --tags --abbrev=0)
		latest_tag_push=$(git -C "$HOME/dotman" log -1 --format=%ai "${latest_tag}")
		echo "${BOLD}dotman ${latest_tag} ${RESET}"
		echo "Released on: ${BOLD}${latest_tag_push}${RESET}"
	else
		echo "${BOLD}dotman ${VERSION}${RESET}"
	fi
	exit 0
fi

intro
init_check
