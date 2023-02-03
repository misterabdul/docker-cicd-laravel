if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-syntax-highlighting vi-mode)
source $ZSH/oh-my-zsh.sh

export EDITOR='vim'
export VISUAL='vim'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
export POWERLEVEL9K_DISABLE_GITSTATUS=true
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
