##
# Configures your shell with some convenient Simon tools
# Some of these will be used by other scripts in our code repo's
##

if [[ -r ~/.simonrc ]]; then
    # Expect this to export SIMONHOME
    source ~/.simonrc
fi

if [[ -z $SIMONHOME ]]; then
    # Matt's default
    export SIMONHOME="$HOME/git/Radico"
fi

alias simon-shell-refresh="source $0"

export SIMONWEBHOME="$SIMONHOME/web"
# Most scripts appear to interpret this as "I'm on my laptop"
export WORKSPACE="."
export SECRETS="$SIMONHOME/keys/secrets"
export PYTHONPATH="$SIMONWEBHOME"
export SPARK_HOME="/usr/local/Cellar/apache-spark/2.2.0/libexec"
export PD_SUPPRESS_LOCAL_ALERTS=true
alias cds="cd $SIMONHOME"
alias cdw="cd $SIMONWEBHOME"

# My branch, which could be develop, versus origin/develop
alias me-v-dev='git diff origin/develop..HEAD'

alias simon-env="cat $SIMONHOME/simon-shell/glasses.txt"

# Enter the virtualenv
alias simon-tox-activate="source $SIMONWEBHOME/.tox/py27/bin/activate"

##
# Tie them all together
##
alias simon-boot='cdw; simon-env; simon-tox-activate'
alias simon-run-dev='simon-boot; echo "Setting env to dev"; djdev ./manage.py supervisor'
alias simon-run-dev-dj='simon-boot; djdev ./manage.py runserver'
alias simon-run-dev-webpack='cdw; npm run dev-server'

# Quick aliases for searching only pythonk or javascript, or all app code
alias grokpy="grep -r  --exclude '.tox/*' --exclude 'node_modules/*' --include '*.py'"
alias grokjs="grep -r --exclude '.tox/*' --exclude 'simon/static/dist/*' --exclude 'node_modules/*' --exclude 'simon/static/js/vendor/*' --include '*.js*' --include '*.jsx'"
alias grokapp="grep -r --exclude '.tox/*' --exclude 'simon/static/dist/*' --exclude 'node_modules/*' --exclude 'simon/static/js/vendor/*'"


##
# Sets django environment for a given command
# $1 - environment
# $**2 - command to run
##
function _djsetmod() {
    declare _env="$1"
    if [[ -z "$_env" ]]; then
        echo >&2 "No env provided"
        return 2
        echo >&2 "Invalid settings module, $_env"
        return 1
    fi

    if [[ -z "$2" ]]; then
        echo >&2 "No command provided"
        return 2
    fi

    DJANGO_SETTINGS_MODULE=settings.${1} "${@:2}"
}

# Configure target application environment
alias djdev='_djsetmod dev'
alias djstaging='_djsetmod staging'
alias djprod='_djsetmod prod'
alias djtest='_djsetmod test'
alias djlocal='_djsetmod local'

# Git things
alias ofd="git fetch origin && git rebase origin/develop"
alias ofdr="git fetch origin && git reset --hard origin/develop"
alias ggd='git c develop'
alias apimp='amend -a; pimp'

# Database, Simon and customers
alias mydb='mysql --login-path=simon-prod ebdb -A'
alias bbtunnel="ssh -N -L 5439:datawarehouse-prod.ca4nfse7sfpx.us-east-1.redshift.amazonaws.com:5439 ci"

# Hadoop and Spark
# usage ssh-simon-hadoop whatever.aws.amazon.com (outside vpc)
# usage ssh-simon-spark 10.0.1.x (master node, if vpc)
alias ssh-simon-hadoop="ssh -L 9100:localhost:9100 -L 9101:localhost:9101 9200:localhost:80 -i $SIMONHOME/keys/radico.pem"
alias ssh-simon-spark="ssh -L 18080:localhost:18080 -L 4040:localhost:4040 -L 9200:localhost:80 -L 8080:localhost:8080 -i $SIMONHOME/keys/radico.pem"

##
# Open up an SSH tunnel to an EMR master
# @param $1 <host>: The hostname or ip address of the master node
##
function hadoop2-tunnel () {
    declare emrHost="$1"

    if [[ -z $emrHost ]]; then
        echo >&2 "No host provided. E.g. hadoop-tunnel ec2-54-158-184-99.compute-1.amazonaws.com"
        return 1
    fi

    echo "http://localhost:9200/ganglia for resource graphs"
    echo "http://localhost:50070 for NameNode"
    echo "http://localhost:8088 for ResourceManager"
    echo "http://localhost:19888 for JobHistory"
    echo "http://localhost:20888 for ApplicationMaster"

ssh -N -L 50070:$1:50070 -L 8088:$1:8088 -L 19888:$1:19888 -L 9200:localhost:80 -L 20888:$1:20888 -i $SIMONHOME/keys/radico.pem ec2-user@$emrHost || (
        echo >&2 "ERROR: Failed to open ssh tunnel. Please verify host name and that no other tunnels are open (ignore if you just CTRL-C'ed tunnel)"
    )
}

##
# Git push with some pre-checks
##
function pimp() {
  # If you are on a long lived branch, you may not need to pep
  # ...everything every time
  declare numCommits="$1"
  declare upstreamBranch="$GIT_MASTER"
  declare originBranch="master"
  if [[ $(pwd) =~ "$SIMONWEBHOME" ]]; then
    originBranch='develop'
  fi

  if [[ ! -z "$(git status -s)" ]] ; then
    echo >&2 "Can't pimp. You have un-committed changes."
    return 2
  fi

  declare -i FAILED=0
  if [[ -z $numCommits ]]; then
      numCommits=$(git rev-list --count HEAD...origin/$originBranch)
  fi

  echo "Validating pep8 against each file changed in last $numCommits commits..."
  while read -r name; do
      if ! $SIMONWEBHOME/.tox/py27/bin/flake8 --config conf/flake8 $name; then
          FAILED=1
      fi
  done < <(git diff HEAD~$numCommits --name-only | grep -e ".py$")

  [[ $FAILED == 0 ]] && git push
}

##
# Clear out the test database and re-create
##
function simon-test-db-refresh() {
    simon-boot
    rm test.sqlite.db
    djtest ./manage.py migrate
}

# Unit tests
function pyunit() {
  if [[ -z "$1" ]]; then
    echo >&2 "You must pass a file path. E.g. simon/tests/pipes/jobs/..."
    return 1
  fi

  # Prevent leftovers from causing false positives, etc.
  # Ignore all compiled 3rd party package files
  find . -name '*.pyc'  -not -path "./.tox/*" -delete

  DJANGO_SETTINGS_MODULE=settings.test py.test -rw -p no:django "$@"
}

# Integration tests
function pyintegration() {
  if [[ -z "$1" ]]; then
    echo >&2 "You must pass a file path. E.g. simon/tests/integration/pipes/jobs/..."
    return 1
  fi

  DJANGO_SETTINGS_MODULE=settings.prod python -m unittest "$@"
}

##
# Regenerates the ssh config file for the role
##
function simon-refresh-ssh-config() {
    declare role="$1"
    if [[ -z $role ]]; then
        echo >&2 "Missing role. Example usage: refresh_ssh_config web"
        return 1
    fi

    if ! which fab > /dev/null; then
        echo >&2 "You must boot your simon environment before using this command"
        return 1
    fi

    # Mac versus posix
    if which sed | grep -v local; then
        sed -i '' "/BEGIN $role/,/END $role/d;/END ROLE/q" ~/.ssh/config
        echo $'\n'"# BEGIN $role" >> ~/.ssh/config
        djprod fab hosts.gen_ssh_config_for:$role,identity="$SIMONHOME/keys/radico.pem" >> ~/.ssh/config
        sed -i '' "/Done/d" ~/.ssh/config
        echo "# END $role" >> ~/.ssh/config
    else
        sed -i "/BEGIN $role/,/END $role/d;/END ROLE/q" ~/.ssh/config
        echo $'\n'"# BEGIN $role" >> ~/.ssh/config
        djprod fab hosts.gen_ssh_config_for:$role,identity="$SIMONHOME/keys/radico.pem" >> ~/.ssh/config
        sed -i "/Done/d" ~/.ssh/config
        echo "# END $role" >> ~/.ssh/config
    fi

    grep $role ~/.ssh/config
}

##
# What pip package(s) requires this package?
# No guarantees on run time
# @param $1 name of the package
# @param $2 verbose? 1 or 0
##
function pip_requires() {
  declare depName="$1"
  declare -i verbose="$2"
  for packageName in $(cut -d '=' -f 1 requirements.txt ); do
    if [[ $verbose == 1 ]]; then
      echo "$(date) TRACE: Searching package $packageName for dependency on $depName"
    fi

    if pip show $packageName | grep Requires | grep -q $depName; then
      echo $packageName requires $depName
    fi
  done
}

##
# Find an instance matching the provided role and, if found, ssh to it
# Assumes your ~/.ssh/config is already set up for Simon subnet(s)
# @param $1 Instance role, specifically the EC2 tag value for the "Role" key
##
function simon-ssh() {
    declare role=$1
    if [[ -z ${role} ]]; then
        >&2 echo "No role provided"
        return 1
    fi

    declare res=$(aws ec2 describe-instances --filters "Name=tag:Role,Values=$role")
    declare ip=$(echo $res | jq .'["Reservations"][0]["Instances"][0]["PrivateIpAddress"]' | sed s/\"//g)
    if [[ -z ${ip} || ${ip} == 'null' ]]; then
        >&2 echo "No instances found for role $role"
        return 1
    fi
    ssh ${ip}
}

##
# Sets up sshuttle for connection to snowflake
##
function snowflake_connect() {
  ip_list=""

  for ip in $(dig em41824.us-east-1.snowflakecomputing.com +short | tail -n +2); do
    ip_list="$ip_list $ip/32"
  done
  
  echo sshuttle -r ec2-user@ci.simondata.net --ssh-cmd \"ssh -i $SIMONHOME/keys/radico.pem\" $ip_list
}

##
# Find triggered-delayed-sync build for a given sync
# https://app.tettra.co/teams/simondata/pages/syncs-runbook
##
function jenkins_url_for_delayed_sync() {
    declare syncId="$1"

    if [[ -z "$syncId" ]]; then
        echo >&2 "Please provide sync_id, e.g. jenkins_url_for_delayed_sync 5993498"
        return 2
    fi

    # Attempt to connect with 1 second timeout
    if ! nc -z -G 1 10.0.1.114 22 &> /dev/null; then
        echo >&2 "The ip address of the jenkins sync master has changed or the master can't be reached!"
        return 3
    fi

    declare cmd="grep $syncId ~jenkins/jobs/trigger-delayed-sync/builds/*/build.xml"
    declare matched=$(ssh 10.0.1.114 "$cmd")

    for build in $(echo $matched | cut -d / -f 8 | grep -v last); do
        echo http://syncs.automation.simondata.net/job/trigger-delayed-sync/${build}/console
    done
}

