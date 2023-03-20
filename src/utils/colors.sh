#!/usr/bin/env bash

# check if tput exists
if ! command -v tput &> /dev/null; then
    # tput could not be found
  BOLD="1"
	RESET="0"
  DIM='2'
  UNDERLINE='4'
  BLINK='5'
  HIGHLIGHT='7'
  HIDDEN='8'

  # MODE
  FG='\033[38'
  BG='\033[48;2'

  # COLORS
  NC='\033[0m' #NoColor
  WHITE='255;255;255'
  BLACK='0;0;0'
  GREEN='0;255;0'
  ALICE='16;120;150'
  RUBY='192;47;29'
  CORAL='242;109;33'
  WEED='35;43;43'
  HONEY='227;147;87'
  ROSE='223;103;140'
  DENIM='61;21;95'
  JUNGLE='139;216;189'
  SPACE='36;54;101'
  SCARLET='236;139;94'
  SHADOW='20;26;70'
  SAPHIRE='41;40;38'
  HUNTER='249;211;66'
  PUNCH='239;84;85'
  PERSIAN='43;50;82'

  TITLE="${BG};${CORAL}m${FG};${BOLD};${WHITE}m"
  SUBTITLE="${BG};${ROSE}m${FG};${DIM};${DENIM}m"
  ERROR="${BG};${RUBY}m${FG};${BOLD};${WHITE}m"
  BGSUCCESS="${BG};${GREEN}m${FG};${BOLD};${ALICE}m"
  SUCCESS="${FG};${DIM};${GREEN}m"
  PROMPT="${BG};${ALICE}m${FG};${BOLD};${WHITE}m"
  BGWARNING="${BG};${HUNTER}m${FG};${DIM};${SAPHIRE}m"
  WARNING="${FG};${DIM};${HUNTER}m"
  SECONDARY="${BG};${JUNGLE}m${FG};${DIM};${SPACE}m"
  BGINFO="${BG};${SPACE}m${FG};${DIM};${JUNGLE}m"
  INFO="${FG};${DIM};${JUNGLE}m"
  SEPARATOR="${BG};${PUNCH}m${FG};${DIM};${PERSIAN}m"
else
	BOLD=$(tput bold)
	RESET=$(tput sgr0)
  UNDERLINE=$(tput smul)
  END_UNDERLINE=$(tput rmul)
  BLINK=$(tput blink)
  HIGHLIGHT=$(tput smso)
  END_HIGHLIGHT=$(tput rmso)
  REV=$(tput rev)
  HIDDEN=$(tput invis)

	FG_BLACK=$(tput setaf 0)
	FG_RED=$(tput setaf 1)
	FG_GREEN=$(tput setaf 2)
	FG_YELLOW=$(tput setaf 3)
	FG_BLUE=$(tput setaf 4)
	FG_MAGENTA=$(tput setaf 5)
	FG_CYAN=$(tput setaf 6)
	FG_WHITE=$(tput setaf 7)
	FG_DEFAULT=$(tput setaf 9)

	BG_BLACK=$(tput setab 0)
	BG_RED=$(tput setab 1)
	BG_GREEN=$(tput setab 2)
	BG_YELLOW=$(tput setab 3)
	BG_BLUE=$(tput setab 4)
	BG_MAGENTA=$(tput setab 5)
	BG_CYAN=$(tput setab 6)
	BG_WHITE=$(tput setab 7)
	BG_DEFAULT=$(tput setab 9)

  TITLE="${FG_MAGENTA}${BG_BLACK}${BOLD}"
  SUBTITLE="${FG_CYAN}${BG_BLACK}${BOLD}"
  ERROR="${FG_RED}${BG_BLACK}"
  BGSUCCESS="${FG_WHITE}${BG_GREEN}"
  SUCCESS="${FG_GREEN}${BG_BLACK}"
  PROMPT="${FG_WHITE}${BG_CYAN}${BOLD}"
  BGWARNING="${FG_WHITE}${BG_YELLOW}"
  WARNING="${FG_YELLOW}${BG_BLACK}"
  SECONDARY="${FG_WHITE}${BG_DEFAULT}"
  BGINFO="${FG_WHITE}${BG_BLUE}"
  INFO="${FG_BLUE}${BG_BLACK}"
  SEPARATOR="${FG_WHITE}${BG_BLACK}"
fi

print_info() {
	echo -e "${1}${2}${RESET}"
}
