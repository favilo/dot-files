set -Ux SIMONHOME "$HOME/git/simon"
set -Ux SIMONWEBHOME "$SIMONHOME/web"
set -x FZF_DEFAULT_COMMAND 'ag -g ""'
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
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
  echo (string escape -- $argv[2..-1])
  eval (string escape -- $argv[2..-1])
end

function pyunit
  if test -z "$argv[1]"
  then
    echo >&2 "You must pass a file path. E.g. simon/tests/pipes/jobs/..."
    return 1
  end

  # Prevent leftovers from causing false positives, etc.
  # Ignore all compiled 3rd party package files
  find . -name '*.pyc'  -not -path "./.tox/*" -delete

  set -lx DJANGO_SETTINGS_MODULE settings.test
  py.test -rw -p no:django "$argv"
end

# Integration tests
function pyintegration
  if test -z "$argv[1]"
  then
    echo >&2 "You must pass a file path. E.g. simon/tests/integration/pipes/jobs/..."
    return 1
  end

  set -lx DJANGO_SETTINGS_MODULE settings.prod
  python -m unittest "$argv"
end

alias djdev "_djsetmod dev"
alias djstaging "_djsetmod staging"
alias djprod "_djsetmod prod"
alias djtest "_djsetmod test"
alias djlocal "_djsetmod local"
alias enw "emacs -nw"
alias vim "emacs -nw"

if status --is-interactive
  abbr -a ta tmux attach
  abbr -a gco git checkout
  abbr -a gpr git pull --rebase
end


if test -d "$HOME/google-cloud-sdk"
    # The next line updates PATH for the Google Cloud SDK.
    source "$HOME/google-cloud-sdk/path.fish.inc"

    # The next line enables shell command completion for gcloud.
    # source "$HOME/google-cloud-sdk/completion.fish.inc"
end

set -gx PATH $PATH ~/.cabal/bin
set -gx PATH ~/.local/bin $PATH

set -gx ANDROID_NDK_ROOT ~/Android/Sdk/ndk/20.0.5594570
set -gx ANDROID_HOME ~/Android/Sdk
