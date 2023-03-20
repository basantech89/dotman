. ./src/utils/colors.sh
. ./src/utils/helpers.sh
. ./src/constants.sh
. ./src/setup.sh

find_dotfiles() {
	printf "\n"

	declare -ag dotfiles
	# readarray reads lines from the standard input into the indexed array variable
	# -t option removes any trailing delimiter (default newline) from each line read.
	readarray -t dotfiles_repo < <( find "${DOT_DEST}" -maxdepth 1 -name ".*" -type f )
	for i in "${!dotfiles_repo[@]}"
	do
		dotfile_name=$(basename "${dotfiles_repo[$i]}")
		[[ -f "${HOME}/$dotfile_name" ]] && dotfiles+=("${dotfile_name}") || print_info "${ERROR}" "dotfile ${dotfile_name} not found."
	done
	printf "${SUCCESS}"
	printf '%s\n' "${dotfiles[@]}"
	printf "${RESET}"

	# If you have an older version of Bash (<4), readarray might not be present as a builtin. 
	# We can achieve the same functionality by using a while loop instead
	# while read -r value; do
	# 	dotfiles+=($value)
	# done < <( find "${HOME}" -maxdepth 1 -name ".*" -type f )
}

diff_check() {
	# declare lets us create variables. 
	# The -a option is used to create arrays
	# -g tells declare to make the variables available "globally" inside the script.
	if [[ -z $1 ]]; then
		declare -ag file_arr
	fi

	# dotfiles in repository
	readarray -t dotfiles_repo < <( find "${DOT_DEST}" -maxdepth 1 -name ".*" -type f )

	# check length here ?
	# for i in "${!dotfiles_repo[@]}"
	for (( i=0; i<"${#dotfiles_repo[@]}"; i++))
	do
		dotfile_name=$(basename "${dotfiles_repo[$i]}")
		# compare the HOME version of dotfile to that of repo
		diff=$(diff -u --suppress-common-lines --color=always "${dotfiles_repo[$i]}" "${HOME}/${dotfile_name}")
		if [[ $diff != "" ]]; then
			if [[ $1 == "show" ]]; then
				printf "\n\n%s" "Running diff between ${HOME}/${dotfile_name} and "
				printf "%s\n" "${dotfiles_repo[$i]}"
				printf "%s\n\n" "$diff"
			fi
			file_arr+=("${dotfile_name}")
		fi
	done
	# ${#file_arr} gives us the length of the array
	if [[ ${#file_arr} == 0 ]]; then
		print_info "${INFO}" "\n\nNo Changes in dotfiles."
		return
	fi
}

show_diff_check() {
	diff_check "show"
}

dot_pull() {
	# pull changes (if any) from the host repo
	print_info "${INFO}" "\nPulling dotfiles ..."
	dot_repo="${DOT_DEST}"
	GET_BRANCH=$(git remote show origin | awk '/HEAD/ {print $3}')
	print_info "${INFO}" "\nPulling changes in $dot_repo"
	printf "\n%s\n" "Pulling from ${TITLE}${GET_BRANCH}" 
	git -C "$dot_repo" pull origin "${GET_BRANCH}"
}

dot_push() {
	diff_check
	if [[ ${#file_arr} != 0 ]]; then
		printf "\n%s\n" "${TITLE}Following dotfiles changed${RESET}"
		for file in "${file_arr[@]}"; do
			echo "$file"
			cp "${HOME}/$file" "${DOT_DEST}"
		done

		git -C "${DOT_DEST}" add -A

		echo "${PROMPT}Enter Commit Message (Ctrl + d to save): ${RESET}"
		commit=$(</dev/stdin)
		printf "\n"
		git -C "${DOT_DEST}" commit -m "$commit"

		# Run Git Push
		git -C "${DOT_DEST}" push
	else
		return
	fi
}

repo_check(){
	# check if dotfile repo is present inside DOT_DEST
	DOT_REPO_NAME=$(basename "${DOT_REPO}")
	if [[ -d ${DOT_DEST} ]]; then
		printf "\n%s\n" "Found ${TITLE}${DOT_REPO_NAME}${RESET} as dotfile repo in ${SUBTITLE}${DOT_DEST}/${RESET}"
	else
		printf "\n\n%s\n" "[❌] ${ERROR}${DOT_REPO_NAME}${RESET} not present inside path ${SUBTITLE}${DOT_DEST}${RESET}"
		read -p "Should I clone it ? [Y/n]: " -n 1 -r USER_INPUT
		USER_INPUT=${USER_INPUT:-y}
		case $USER_INPUT in
			[y/Y]* ) clone_dotrepo "$DOT_DEST" "$DOT_REPO" ;;
			[n/N]* ) printf "\n%s" "${ERROR}${DOT_REPO_NAME}${RESET} not found";;
			* )     printf "\n%s\n" "[❌] Invalid Input 🙄, Try Again";;
		esac
	fi
}

manage() {
	while :
	do
		printf "\n%s" "[${BOLD}1${RESET}] Show diff"
		printf "\n%s" "[${BOLD}2${RESET}] Push changed dotfiles"
		printf "\n%s" "[${BOLD}3${RESET}] Pull latest changes"
		printf "\n%s" "[${BOLD}4${RESET}] List all dotfiles"
		printf "\n%s\n" "[${BOLD}q/Q${RESET}] Quit Session"

		# Default choice is [1]
		# -n 1 option specifies what length of input is allowed, here only input one character amongst 1, 2, 3, 4, q and Q.
		read -p "What do you want me to do ? [${BOLD}1${RESET}]: " -n 1 -r USER_INPUT
		# See Parameter Expansion
		USER_INPUT=${USER_INPUT:-1}
		case $USER_INPUT in
			[1]* ) show_diff_check;;
			[2]* ) dot_push;;
			[3]* ) dot_pull;;
			[4]* ) find_dotfiles;;
			[q/Q]* ) goodbye
							exit;;
			* )     printf "\n%s\n" "[❌]${ERROR}Invalid Input, Try Again${RESET}";;
		esac
	done
}
