if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

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
  echo 1>&2 "Running in $argv[1]: $argv[2..-1]"
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
set -gx PATH $PATH ~/go/bin

set -gx ANDROID_NDK_ROOT ~/Android/Sdk/ndk/20.0.5594570
set -gx ANDROID_HOME ~/Android/Sdk
set -gx HOST (hostname)

function hadoop2-tunnel
  set -l emrHost "$argv[1]"

  if test -z $emrHost
    echo 1>&2 "No host provided. E.g. hadoop-tunnel ec2-54-158-184-99.compute-1.amazonaws.com"
    return 1
  end

  echo "http://localhost:9200/ganglia for resource graphs"
  echo "http://localhost:50070 for NameNode"
  echo "http://localhost:8088 for ResourceManager"
  echo "http://localhost:19888 for JobHistory"
  echo "http://localhost:20888 for ApplicationMaster"

  ssh -N -L 50070:$1:50070 -L 8088:$1:8088 -L 19888:$1:19888 -L 9200:localhost:80 -L 20888:$1:20888 -i $SIMONHOME/keys/radico.pem ec2-user@$emrHost || \
      echo >&2 "ERROR: Failed to open ssh tunnel. Please verify host name and that no other tunnels are open (ignore if you just CTRL-C'ed tunnel)"
end

function simon-ssh
  set -l role "$argv[1]"
  if test -z $role
      echo 1>&2 "No role provided"
      return 1
  end

  set -l res (aws ec2 describe-instances --filters "Name=tag:Role,Values=$role")
  set -l ip (echo $res | jq .'["Reservations"][0]["Instances"][0]["PrivateIpAddress"]' | sed s/\"//g)
  if test -z $ip || $ip == 'null'
      echo 1>&2 "No instances found for role $role"
      return 1
  end
  ssh $ip
end

function snowflake_connect
  set -l ip_list ""

  for ip in (dig em41824.us-east-1.snowflakecomputing.com +short | tail -n +2)
    set ip_list "$ip_list $ip/32"
  end

  echo "sshuttle -r ec2-user@ci.simondata.net --ssh-cmd \"ssh -i $SIMONHOME/keys/radico.pem\" $ip_list"
end
