export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"

ZSH_THEME="robbyrussell"

plugins=(git fzf sudo history colored-man-pages zsh-autosuggestions zsh-syntax-highlighting )

source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

alias update='yay -Syu --needed'
alias cleanup='yay -Yc'
alias cleanupcache='yay -Sc'
alias search='yay -Ss'
alias fucking='sudo'
alias yaydelete='yay -Rns'
alias calculator='quich'
alias calc='quich'
alias home='cd ~'
alias root='cd /'
alias config='cd ~/.config'
alias zsh_config='nvim ~/.zshrc'
alias ff='fastfetch'
alias hypr='start-hyprland'
alias help='~/.config/hypr/Scripts/help.sh'
alias ipv4="ip addr show | grep 'inet ' | grep -v '127.0.0.1' | cut -d' ' -f6 | cut -d/ -f1"
alias ipv6="ip addr show | grep 'inet6 ' | cut -d ' ' -f6 | sed -n '2p'"
alias clock='peaclock'
alias weather='python3 ~/.config/hypr/Scripts/weather.py'
alias delete='rm -rf'
alias y='yazi'
alias ai='/home/oofer/Projects/lmstudio.sh'
[[ -o interactive ]] && fastfetch

# Take tab back from fzf
bindkey -r '^I'
bindkey -M emacs '^I' autosuggest-accept
bindkey -M viins '^I' autosuggest-accept

# Path to your Oh My Zsh installation.
export LESS="-R"

export PATH=$PATH:/home/oofer/.spicetify

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/oofer/.lmstudio/bin"
# End of LM Studio CLI section

