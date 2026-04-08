# Environment Variables
export TRASH=~/trash/
export VISUAL=code
source $DirectoryRepos/bash-profile/.bash_profile_env
source $DirectoryRepos/bash-profile/.bash_profile_git
export PATH="$HOME/.pyenv/bin:$PATH"

# Terminal Upgrade
branch='`__git_ps1`'
PS1="\n\[\033[1;31m\]  \w$(tput setaf 0) $branch \n\[$(tput setaf 2)\]λ  \[\033[0m\]"

# *****
# 00000
# 11111
# 22222
# 33333
# 44444
# 55555
# 66666 
# 77777
# 88888
# 99999
# AAAAA
# BBBBB
alias b="cd .."
# CCCCC
alias clr="command clear"
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

# DDDDD
# EEEEE
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
alias e-bash-profile-env="rep && cd bash-profile && e .bash_profile_env"

# FFFFF
alias f="source $DirectoryRepos/bash-profile/.bash_profile"
fr() {
  if [[ "$DirectoryRepos/bash-profile" == "/home/user/bash-profile" ]]; then
    source ~/.bashrc
  else
    source ~/.bash_profile
  fi
  }
# GGGGG
alias ga="git add ."
alias gs="git status"
# HHHHH
alias h="cd ~"
# IIIII
# JJJJJ
# KKKKK
# LLLLL
alias l="ls"
alias la="ls -la"
# MMMMM
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

# NNNNN
# OOOOO
# PPPPP
post() {
  if [ "$#" -lt 4 ]; then
    echo "Usage: post [environment] [endpoint] [namespace] [variadic-json-body-key-value]"
    echo "post local /create agd-internal A 10 B 20" | clip.exe
    return 1
  fi

  # Get URL
  url_base="${urls[$1]}"
  if [ -z "$url_base" ]; then
    echo "Error: URL base not found for key '$1'."
    return
  fi
  echo $url_base

  # Extract other parameters
  endpoint="$2"
  namespace="$3"

  # Construct final URL
  final_url="${url_base}${endpoint}?ns=${namespace}"
  echo "Final URL: $final_url"

  # Generate JSON payload from variadic parameters
  json_payload="{"
  shift 3
  while [ "$#" -gt 1 ]; do
    json_payload+="\"$1\": $2,"
    shift 2
  done
  json_payload="${json_payload%,}}"
  echo "JSON payload: $json_payload"
  
  # Make POST request using curl and print response
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
# QQQQQ
# RRRRR
alias rep="cd $DirectoryRepos"
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
# SSSSS
# TTTTT
alias trash="cd $TRASH"
alias trash-create="mkdir -p $TRASH"
alias trash-empty="rm -rf $TRASH/* && echo 'emptied trash'"
# UUUUU
# VVVVV
# WWWWW
# XXXXX
alias x="exit"
# YYYYY
# ZZZZZ
