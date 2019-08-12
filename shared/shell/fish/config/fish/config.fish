set -U SIMONHOME "$HOME/git/simon"
set -u SIMONWEBHOME "$SIMONHOME/web"
alias cdw "cd $SIMONWEBHOME"
alias cds "cd $SIMONHOME"

alias simon-env "cat $SIMONHOME/simon-shell/glasses.txt"
alias simon-tox-activate "source $SIMONWEBHOME/.tox/py27/bin/activate.fish"

function _djsetmod 
  if test -z "$argv[1]" 
    echo 1>&2 "No env provided"
    return 2
  end
  if test -z "$argv[2]" 
    echo 1>&2 "No command provided"
    return 2
  end
  echo "Running in $argv[1]: $argv[2..-1]"
  set -lx DJANGO_SETTINGS_MODULE "settings.$argv[1]"
  eval "$argv[2..-1]"
end

alias djdev "_djsetmod dev"
alias djstaging "_djsetmod staging"
alias djprod "_djsetmod prod"
alias djtest "_djsetmod test"
alias djlocal "_djsetmod local"

if status --is-interactive
  abbr -a ta tmux attach
  abbr -a gco git checkout
  abbr -a gpr git pull --rebase
end

