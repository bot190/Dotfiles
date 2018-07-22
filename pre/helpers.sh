#!/bin/bash

update_or_install () {
    LOCALREPO=$2
    LOCALREPO_VC_DIR="$LOCALREPO/.git"
    REPOSRC=$1
    if [ ! -d $LOCALREPO_VC_DIR ]
    then
        git clone $REPOSRC $LOCALREPO
    else
        cd $LOCALREPO
        git pull $REPOSRC
    fi
}
