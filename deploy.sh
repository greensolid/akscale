#! /bin/bash -v

mkdir -pv charts

if [ -z ${CIRCLE_PR_REPONAME+x} ] || [ "$CIRCLE_BRANCH" != "master" ]; then
    helmsman -f helmsman.toml
else
    chmod +x ./get-secrets.sh
    bash ./get-secrets.sh
    helmsman -apply -f helmsman.toml
fi
