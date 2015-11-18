#
# Executes commands at the start of an interactive session.
#

###########################################################################
#                                 General                                 #
###########################################################################
# History storage lines in memory
HISTSIZE=1000
# History storage lines on disk
SAVEHIST=$HISTSIZE
# History file location
HISTFILE=~/.zsh-history
# Add to history file as commands are executed rather than at shell exit
setopt INC_APPEND_HISTORY
# Check for updates to history file when writing to it, handy when
# using multiple zsh sessions simultaneously
setopt SHARE_HISTORY
# Don't save a line of history if it's identical to the previous
setopt HIST_IGNORE_DUPS
# Remove excess blanks when adding a line to history
setopt HIST_REDUCE_BLANKS
# Enable editing the results of bang-history substitution instead of
# immediate execution
setopt HIST_VERIFY

# Beeping is annoying
setopt NO_BEEP

# Automatically cd when typing something that isn't a command, but is
# a directory
setopt AUTO_CD

# Extended globs are good
setopt EXTENDED_GLOB

# Check commands for typos and suggest fixes
setopt CORRECT

###########################################################################
#                            Completion Setup                             #
###########################################################################
# Automatically list options if a completion is ambiguous
setopt AUTO_LIST
# Insert any nonambiguous suffix or prefix before listing options
setopt LIST_AMBIGUOUS
# Show the filetype in completion listings
setopt LIST_TYPES
# Vary width of list columns to make list more commpact
setopt LIST_PACKED

# Adds the rust language completions to $fpath
fpath=(~/.zsh/completions/rust-lang $fpath)

# Load completion
autoload -U compinit && compinit

###########################################################################
#                                 Prompt                                  #
###########################################################################

# Adds the themes folder to $fpath
fpath=(~/.zsh/themes $fpath)
# Sets up zsh's builtin prompt theme system
autoload -Uz promptinit && promptinit
# Sets the prompt theme to slat
prompt slat

###########################################################################
#                                 Aliases                                 #
###########################################################################

# If herbstluftwm is installed, make it easier to control
if which herbstclient >/dev/null 2>&1; then
	alias hc=herbstclient
fi

case `uname` in
	Darwin)
		alias ls='ls -FG'
		;;
	Linux|CYGWIN*)
		alias ls='ls -F --color=auto'
		;;
esac

if which vim >/dev/null 2>&1 && vim --version | grep -q '+clientserver'; then
	# Ease opening files with an existing Vim instance.
	# Tries, in order, and skipping the rest once succeeding:
	#     1. The Vim server specified by the '--sn' option
	#     2. The Vim server specified by the '$VIM_SERV' variable, if still open
	#     3. The most recently opened Vim server
	#     4. A new Vim server named 'VIM'
	vis() {
		if [[ "$1" = '--sn' ]] && [[ -n "$2" ]]; then
			VIM_SERV="$2"
			shift 2
		elif [[ -z "$VIM_SERV" ]] || ! vim --serverlist | grep -xq "$VIM_SERV"; then
			VIM_SERV="$(vim --serverlist | tail -n1)"
			if [[ -z "$VIM_SERV" ]]; then
				VIM_SERV=VIM
			fi
		fi
		if [[ -n "$1" ]]; then
			vim --servername "$VIM_SERV" --remote-tab-silent "$@"
		else
			vim --servername "$VIM_SERV"
		fi
	}
fi
