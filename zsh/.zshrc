# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

# Let Ctrl-S pass through to tmux
bindkey -r '^S'

# Set up the prompt
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
     #exec tmux new-session -A -s main
     exec tmux new-session
fi

modules_shell=zsh
module() { eval `/usr/bin/modulecmd $modules_shell $*`; }

parse_git_branch() {
   local branch=""
   branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

   if [[ -z "$branch" ]]
   then
      return
   fi

   local commit
   commit=$(git rev-parse --short HEAD 2> /dev/null)
   local UPSTREAM LOCAL REMOTE color commit_color

   UPSTREAM=${1:-'@{u}'}
   LOCAL=$(git rev-parse @ 2> /dev/null)
   REMOTE=$(git rev-parse "$UPSTREAM" 2> /dev/null)

   if [[ $LOCAL = $REMOTE ]]; then
      commit_color="%F{green}"
   else
      commit_color="%F{red}"
   fi

   local green="%F{green}"
   local reset="%f"

   echo "${green}(${branch})${reset} ${commit_color}[${commit}]${reset} "
}

autoload -U colors && colors
setopt PROMPT_SUBST

update_prompt() {
 PROMPT='%{%B%}[%D{%H:%M:%S}]%{%b%} %{$fg[magenta]%}%{%B%}%n%{%b%}%{$reset_color%}@%{$fg[cyan]%}%{%B%}%m%{%b%} %{$fg[yellow]%}%{%B%}%~ %{%b%}%{$reset_color%}$(parse_git_branch)>> '
}

update_prompt

setopt histignorealldups sharehistory

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export PATH="$PATH:$HOME/arm-gnu-toolchain-15.3.rel1-x86_64-arm-none-eabi/bin"
alias l='ls -lh'
alias vim='nvim'

tmux-project() {
    local session="$1"
    local dir="$2"
    local venv="$3"
    local final_dir="$4"

    if ! tmux has-session -t "$session" 2>/dev/null; then
        tmux new-session -d -s "$session" -c "$dir"

        [[ -n "$venv" ]] && \
            tmux send-keys -t "$session" "source \"$venv/bin/activate\"" C-m

        [[ -n "$final_dir" ]] && \
            tmux send-keys -t "$session" "cd \"$final_dir\"" C-m
    fi

    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session"
    else
        tmux attach-session -t "$session"
    fi
}

[[ -f "$HOME/.config/zsh/projects.zsh" ]] &&
    source "$HOME/.config/zsh/projects.zsh"
