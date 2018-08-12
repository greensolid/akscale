#! /bin/bash

mkdir -pv charts

if [ -z ${CIRCLE_PR_REPONAME+x} ]; then
    helmsman -f helmsman.toml
else
    helmsman -apply -f helmsman.toml
fi
