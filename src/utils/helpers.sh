#!/usr/bin/env bash

. ./src/utils/colors.sh

prerequisites() {
  if ! command -v git &> /dev/null; then
    print_info "${ERROR}" "Can't work without Git 😞"
    exit "${GIT_NOT_FOUND}"
  fi
}

logo() {
	# print dotman logo
	printf "${INFO}%s\n" ""
	printf "%s\n" "      _       _                         "
	printf "%s\n" "     | |     | |                        "
	printf "%s\n" "   __| | ___ | |_ _ __ ___   __ _ _ __  "
	printf "%s\n" "  / _\` |/ _ \| __| \`_ ' _ \ / _' | '_ \ "
	printf "%s\n" " | (_| | (_) | |_| | | | | | (_| | | | |"
	printf "%s\n" "  \__,_|\___/ \__|_| |_| |_|\__,_|_| |_|"
	printf "${RESET}\n%s" ""
}

goodbye() {
	printf "\a\n\n%s\n" "${TITLE}Thanks for using dotman 🖖.${RESET}"
	printf "%s\n" "for more updates.${RESET}"
	printf "%s\n" "${SUBTITLE}Report Bugs 🐛 @ ${UNDERLINE}https://github.com/basantech89/dotman/issues${END_UNDERLINE}${RESET}"
}

test_colors() {
  echo "${TITLE}TITLE Hello Basant${RESET}"
  echo "${SUBTITLE}SUBTITLE Hello Basant${RESET}"
  echo "${ERROR}ERROR Hello Basant${RESET}"
  echo "${BGSUCCESS}BGSUCCESS Hello Basant${RESET}"
  echo "${SUCCESS}SUCCESS Hello Basant${RESET}"
  echo "${PROMPT}PROMPT Hello Basant${RESET}"
  echo "${BGWARNING}BGWARNING Hello Basant${RESET}"
  echo "${WARNING}WARNING Hello Basant${RESET}"
  echo "${SECONDARY}SECONDARY Hello Basant${RESET}"
  echo "${BGINFO}BGINFO Hello Basant${RESET}"
  echo "${INFO}INFO Hello Basant${RESET}"
  echo "${SEPARATOR}SEPARATOR Hello Basant${RESET}"
}