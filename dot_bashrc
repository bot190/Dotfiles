# .bashrc
if [[ $- != *i* ]] ; then
  # shell is non-interactive. be done now!
  return
fi

# Load all files from .shell/bashrc.d directory
if [ -d $HOME/.config/bashrc.d ]; then
  for file in $HOME/.config/bashrc.d/*.bash; do
    source $file
  done
fi

# Load all files from .shell/rc.d directory
if [ -d $HOME/.config/rc.d ]; then
  for file in $HOME/.config/rc.d/*.sh; do
    source $file
  done
fi


