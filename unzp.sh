#!/bin/bash
#
#   A script to unpacking archives by file extension detection
#

if [ x == x$1 ]; then
  echo -e "usage: unzp.sh [filenames]"
else
  type "gtar" &>/dev/null;
  if [ $? == 0 ]; then
    TARCMD=gtar
  else
    TARCMD=tar
  fi
  for fn in "$@"; do
    if [ -f "$fn" ]; then
      case "$fn" in
        *.tar.gz)          $TARCMD -xvzf "$fn" ;;
        *.tgz)             $TARCMD -xvzf "$fn" ;;
        *.tar.bz2)         $TARCMD -xvjf "$fn" ;;
        *.gz)              gunzip "$fn" ;;
        *.bz2)             bunzip2 "$fn" ;;
        *.tar)             $TARCMD -xvf "$fn" ;;
        *.zip|*.egg|*.jar) unzip "$fn" ;;
#        *.rar)             unrar e "$fn" ;;
        *.rar)             rar x "$fn" ;;
        *.7z)              7z x "$fn" ;;
        *) echo "error: '$fn' is an unknown archive type" ;;
      esac
    else
      echo "error: '$fn' is not a valid archive type"
    fi
  done
fi
