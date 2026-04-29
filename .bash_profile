export TRASH=~/trash/
export VISUAL=code
source $DirectoryRepos/bash-profile/.bash_profile_env
source $DirectoryRepos/bash-profile/.bash_profile_git
export PATH="$HOME/.pyenv/bin:$PATH"

branch='`__git_ps1`'
PS1="\n\[\033[1;31m\]  \w$(tput setaf 0) $branch \n\[$(tput setaf 2)\]λ  \[\033[0m\]"

alias b="cd .."
alias clr="command clear"
alias eb="rep && cd bash-profile && e .bash_profile"
alias e-bash-profile-env="rep && cd bash-profile && e .bash_profile_env"
alias ebe="e-bash-profile-env"
alias ebg="rep && cd bash-profile && e .bash_profile_git"
alias e-template="echo template here | copy_to_clipboard"
alias f="source $DirectoryRepos/bash-profile/.bash_profile"
alias ga="git add ."
alias gl="git log"
alias gs="git status"
alias h="cd ~"
alias l="ls"
alias la="ls -la"
alias rep="cd $DirectoryRepos"
alias run-api="cd-white-label-api && go run services/white-label-api/main.go"
alias trash="cd $TRASH"
alias trash-create="mkdir -p $TRASH"
alias trash-empty="rm -rf $TRASH/* && echo 'emptied trash'"
alias x="exit"

code() {
  if [[ "$GOOGLE_CLOUD_WORKSTATIONS" == "true" ]]; then
    code-oss-cloud-workstations $1
  else
    command code $1
  fi
  }

copy_to_clipboard() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        pbcopy
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        clip.exe
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v xclip &> /dev/null; then
            xclip -selection clipboard
        elif command -v xsel &> /dev/null; then
            xsel --clipboard --input
        else
            echo "Neither xclip nor xsel is installed. Please install one of them to use this function."
            return 1
        fi
    else
        echo "Unsupported OS type: $OSTYPE"
        return 1
    fi
    }

curl-api-create() {
    curl -X POST http://localhost:8080/create \
          -H "Content-Type: application/json" \
          -d "{\"value\": \"Hello\"}"
  }
e() {
    file_to_open=${1:-$DirectoryBashProfile/.bash_profile}
    echo "File to open: $file_to_open"

    if [ -n "$GOOGLE_CLOUD_WORKSTATIONS" ]; then
        echo "Running in Google Cloud Workstations: $file_to_open"
        bash /opt/goland/bin/goland.sh "$file_to_open"
    else
        echo "Running locally: $file_to_open"
        code "$file_to_open" &
    fi
  }
fr() {
  if [[ "$DirectoryRepos/bash-profile" == "/home/user/bash-profile" ]]; then
    source ~/.bashrc
  else
    source ~/.bash_profile
  fi
  }

make-branch() {
  if [ -z "$1" ]; then
    echo "Usage: make-branch <branch-name>"
    return 1
  fi

  branch_name="$1"

  alias_name=$(echo "$branch_name" | tr '[:upper:]' '[:lower:]' | tr '/_ ' '-')

  normalized=$(echo "$branch_name" | tr '[:upper:]' '[:lower:]')

  ticket=$(echo "$normalized" | grep -oE '^[a-z]+[0-9]+')

  if echo "$normalized" | grep -qE "^[a-z]+[0-9]+-[0-9]+-"; then
    sub=$(echo "$normalized" | grep -oE '^[a-z]+[0-9]+-[0-9]+')
    description=$(echo "$normalized" | sed -E "s/^$sub-//")
    title_prefix=$(echo "$sub" | tr '[:lower:]' '[:upper:]')
  else
    description=$(echo "$normalized" | sed -E "s/^$ticket-//")
    title_prefix=$(echo "$ticket" | tr '[:lower:]' '[:upper:]')
  fi

  commit_message=$(echo "$description" | tr '-' ' ')
  commit_message="$(echo "${commit_message:0:1}" | tr '[:lower:]' '[:upper:]')${commit_message:1}"

  title="$title_prefix: $commit_message"

  echo "Title: $title"
  echo "Commit message: $commit_message"

  current_branch=$(git rev-parse --abbrev-ref HEAD)

  {
    echo "alias git-echo-${alias_name}=\"echo ${branch_name} | copy_to_clipboard\""
    echo "alias git-branch-${alias_name}=\"git checkout -b ${branch_name}\""
    echo "alias git-checkout-${alias_name}=\"git checkout ${branch_name}\""
    echo "alias git-feature-checkout-${alias_name}=\"git checkout ${current_branch}\""
    echo "alias git-feature-pull-${alias_name}=\"git checkout ${current_branch} && git pull origin ${current_branch}"\"
    echo "alias git-commit-${alias_name}='git commit -m \"${commit_message}\"'"
    echo "alias git-force-push-${alias_name}=\"git push origin ${branch_name} --force\""
    echo "alias git-push-${alias_name}=\"git push origin ${branch_name}\""

    if [ "$current_branch" != "$branch_name" ]; then
      echo "alias git-merge-${alias_name}=\"echo 'Step 1: checkout ${current_branch}' && git checkout ${current_branch} && echo 'Step 2: pull latest from origin/${current_branch}' && git pull origin ${current_branch} && echo 'Step 3: checkout ${branch_name}' && git checkout ${branch_name} && echo 'Step 4: merge ${current_branch} into ${branch_name}' && git merge ${current_branch}\""
      echo "alias git-delete-force-${alias_name}=\"git checkout ${current_branch} && git branch -D ${branch_name}\""
    fi

    echo "alias git-pull-${alias_name}=\"git checkout ${branch_name} && git pull origin ${branch_name}\""
    echo "alias git-pull-${alias_name}-api=\"cd-api && git checkout ${branch_name} && git pull origin ${branch_name}\""
    echo "alias git-pull-${alias_name}-fmc=\"cd-fmc && git checkout ${branch_name} && git pull origin ${branch_name}\""
    echo "alias git-pull-${alias_name}-web=\"cd-web && git checkout ${branch_name} && git pull origin ${branch_name}\""

    echo "alias git-title-${alias_name}-web=\"echo '${title}' | copy_to_clipboard\""
  } | copy_to_clipboard

  ebg
  }

make-env() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: make-env <parentDir/repo> <ssh-clone>"
    echo "Example: make-env ssh-keys git@github.com:HappySaila/ssh-keys.git"
    return 1
  fi

  parentDir=$(echo $1 | cut -d'/' -f1)
  repo=$(echo $1 | cut -d'/' -f2)
  directoryVar="Directory$(echo $repo | sed -r 's/(^|-)([a-z])/\U\2/g')"
  parentDirVar="Directory$(echo $parentDir | sed -r 's/(^|-)([a-z])/\U\2/g')"
  cloneVar=$2

  (
    echo "export $directoryVar=\"\$DirectoryRepos/$repo\""
    echo "alias cd-$repo=\"cd \$$directoryVar\""
    echo "alias clone-$repo=\"rep && git clone $cloneVar\""
  ) | tee /dev/fd/2 | copy_to_clipboard

  e-bash-profile-env
  }

post() {
  if [ "$#" -lt 4 ]; then
    echo "Usage: post [environment] [endpoint] [namespace] [variadic-json-body-key-value]"
    echo "post local /create agd-internal A 10 B 20" | clip.exe
    return 1
  fi

  url_base="${urls[$1]}"
  if [ -z "$url_base" ]; then
    echo "Error: URL base not found for key '$1'."
    return
  fi
  echo $url_base

  endpoint="$2"
  namespace="$3"

  final_url="${url_base}${endpoint}?ns=${namespace}"
  echo "Final URL: $final_url"

  json_payload="{"
  shift 3
  while [ "$#" -gt 1 ]; do
    json_payload+="\"$1\": $2,"
    shift 2
  done
  json_payload="${json_payload%,}}"
  echo "JSON payload: $json_payload"

  echo "curl -X POST -H \"Content-Type: application/json\" -d \"$json_payload\" \"$final_url\""
  curl -X POST -H "Content-Type: application/json" -d "$json_payload" "$final_url"
  }

pull-bash-profile() {
  cd-bash-profile
  ga
  gst
  git pull
  gsa
  gs
  }

push-bash-profile() {
  cd-bash-profile
  git add .
  git commit -m "bash profile"
  git push
  }

r() {
    if [ -z "$1" ]; then
        echo "expected 1 value"
        return
    fi
    if [ ! -d "$TRASH" ]; then
        echo "The trash directory does not exist. Please create it using: mkdir -p $TRASH"
        return
    fi
    now=$(date +"%D-%T")
    now=$(echo $now | sed "s/\//:/g")
    binPath=$TRASH
    echo $binPath
    destination=$binPath$now
    mkdir $destination
    echo $1 >> $destination/command.txt
    mv $1 $destination
    echo "deleted $1"
  }
