function rubyDetails {
  if [[ ! -z $GEM_HOME ]]; then
    export BUNDLE_SILENCE_ROOT_WARNING=1
    export BUNDLE_PATH="$GEM_HOME"
    export BUNDLE_BIN="$GEM_HOME/bin"
    export BUNDLE_SILENCE_ROOT_WARNING=1
    export BUNDLE_APP_CONFIG="$GEM_HOME"
  fi
  echo "----------- Ruby - $(date) -------------"
  echo "Ruby"
  echo "  - Path: $(which ruby)"
  echo "  - Version: $(ruby -v)"
  echo "----------- Gem - $(date) -------------"
  echo "  - Path: $(which gem)"
  echo "  - Version: $(gem -v)"
  echo "  - GEM_HOME: ${GEM_HOME}"
  echo "----------- Bundle - $(date) -------------"
  echo "  - Path: $(which bundle)"
  echo "  - BUNDLE_PATH: ${BUNDLE_PATH}"
  echo "  - BUNDLE_BIN: ${BUNDLE_BIN}"
  echo "  - BUNDLE_APP_CONFIG: ${BUNDLE_APP_CONFIG}"
}

if [[ -f /usr/local/rvm/scripts/rvm ]]; then
  echo "Setting rvm path: /usr/local/rvm/scripts/rvm"
  source /usr/local/rvm/scripts/rvm
  export PATH="$PATH:/usr/local/rvm/bin" # Add RVM to PATH for scripting
  rubyDetails
elif [[ -f "$HOME/.rvm/scripts/rvm" ]]; then
  echo "Setting rvm path: $HOME/.rvm/scripts/rvm"
  source "$HOME/.rvm/scripts/rvm"
  rubyDetails
  export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
else
  echo "Unable to find the rvm path"
fi
