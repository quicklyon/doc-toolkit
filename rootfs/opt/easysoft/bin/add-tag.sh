#!/bin/bash

VERSION="${1:-NULL}"
URL="${2:-NULL}"

if [ "$VERSION" == "NULL" ] || [  "$URL" == "NULL" ];then
  echo "$0 need version and url. Ex.: $0 \"0.12.9\" \"https://github.com/gogs/gogs/releases/tag/v0.12.9\""
  exit 1
fi

IS_EXISTES=$(grep -c "$VERSION" .template/support-tags.md)

if [ "$IS_EXISTES" == "0" ];then
    sed -i "2i - [$VERSION]($URL)" .template/support-tags.md
else
    echo "$VERSION is exist,skip add version."
fi
