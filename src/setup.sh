#!/usr/bin/env bash

. ./src/utils/colors.sh
. ./src/utils/helpers.sh
. ./src/constants.sh

add_env() {
	# export environment variables
	print_info "${INFO}" "\nExporting env variables DOT_DEST & DOT_REPO ..."
	repo_name=$(basename "${$1}")

	current_shell=$(basename "$SHELL")
	if [[ $current_shell == "zsh" ]]; then
		echo "export DOT_REPO=$1" >> "$HOME"/.zshrc
		echo "export DOT_DEST=$2/${repo_name}" >> "$HOME"/.zshrc
	elif [[ $current_shell == "bash" ]]; then
		# assume we have a fallback to bash
		echo "export DOT_REPO=$1" >> "$HOME"/.bashrc
		echo "export DOT_DEST=$2/${repo_name}" >> "$HOME"/.bashrc
	else
		print_info "${ERROR}" "Couldn't export DOT_REPO and DOT_DEST."
		print_info "${ERROR}" "Consider exporting them manually".
		exit "${VAR_EXPORT}"
	fi
	print_info "${SUCCESS}" "Configuration for SHELL: $current_shell has been updated."
}

clone_dotrepo () {
	# clone the repo in the destination directory
	DOT_DEST=$1
	DOT_REPO=$2
	
	# -C option is used in git to clone the repository to a user-specified path
	if git -C "${DOT_DEST}" clone "${DOT_REPO}"; then
		if [[ $DOT_REPO && $DOT_DEST ]]; then
			add_env "$DOT_REPO" "$DOT_DEST"
		fi
		printf "\n%s" "[✔️ ] ${SUCCESS}dotman successfully configured.${RESET}"
	else
		# invalid arguments to exit, Repository Not Found
		printf "\n%s" "[❌] ${ERROR}$DOT_REPO Unavailable. Exiting !${RESET}"
		exit "${DOT_REPO_NOT_FOUND}"
	fi
}

link_dotfiles () {
	readarray -t dotfiles < <( find "${DOT_DEST}/$(basename "${DOT_REPO}")" -maxdepth 1 -name ".*" -type f )

}

initial_setup () {
  print_info "${TITLE}" "\n\nFirst time use 🔥, Set Up dotman"
	print_info "${SEPARATOR}" "....................................\n"
	# -p specifies a prompt before taking an input
	read -p "➤ Enter dotfiles repository URL : " -r DOT_REPO
	
	# basename remove all the chars upto the last / in a pathname
  read -p "➤ Where should I clone ${BOLD}$(basename "${DOT_REPO}")${RESET} (${HOME}): " -r DOT_DEST
	# parameter substitution
  DOT_DEST=${DOT_DEST:-$HOME}
	# -d checks if $DOT_DEST is a valid path in the system
  if [[ -d "$DOT_DEST" ]]; then
		printf "\n%s\r\n" "${BOLD}Calling 📞 Git ... ${RESET}"
		clone_dotrepo "$DOT_DEST" "$DOT_REPO"
		printf "\n%s\n" "Open a new terminal or source your shell config"
  else
    printf "[❌]${ERROR}${BOLD}$DOT_DEST${RESET} Not a valid directory, exiting."
		exit "${DOT_DIR_NOT_FOUND}"
  fi
}
