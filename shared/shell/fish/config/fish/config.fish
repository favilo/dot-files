if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow'
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND --no-ignore-vcs"
set -x FZF_DEFAULT_OPTS '--height 96% --reverse --preview "cat {}"'

fish_vi_key_bindings

if test -d ~/.profile.d
    for f in ~/.profile.d/*.fish
        source "$f"
    end
end

alias enw "emacs -nw"
alias vim "emacs -nw"

if status --is-interactive
  abbr -a ta tmux attach
  abbr -a gco git checkout
  abbr -a gpr git pull --rebase
end

if [ -e ~/.cargo/bin/exa ]
  abbr -a l exa
  abbr -a ls exa
  abbr -a ll exa -l
  abbr -a la exa -la
else 
  abbr -a l ls
  abbr -a ll ls -l
  abbr -a la ls -la
end

if test -d "$HOME/google-cloud-sdk"
    # The next line updates PATH for the Google Cloud SDK.
    source "$HOME/google-cloud-sdk/path.fish.inc"

    # The next line enables shell command completion for gcloud.
    # source "$HOME/google-cloud-sdk/completion.fish.inc"
end

set -gx PATH $PATH ~/.cabal/bin
set -gx PATH $PATH ~/.cargo/bin
set -gx PATH ~/.local/bin $PATH
set -gx PATH $PATH ~/go/bin
set -gx PATH $PATH /snap/bin
set -gx PATH $PATH ~/.emacs.d/bin

set -gx ANDROID_NDK_ROOT ~/Android/Sdk/ndk/20.0.5594570
set -gx ANDROID_HOME ~/Android/Sdk
set -gx HOST (hostname)


set -x PATH "$HOME/.pyenv/bin" $PATH
set -x PATH "$HOME/.poetry/bin" $PATH
set -x I_AM_RUNNING_INTEGRATION_TESTS "false"

status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source
