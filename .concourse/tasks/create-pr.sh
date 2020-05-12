#!/bin/bash

file_name=$(basename fileName=$(find outputfolder/ -type f -name 'kubecf-v*'));
branch_name="${file_name%.*}"
mv outputfolder/kubecf-v* kubecf-helm

export GIT_ASKPASS=$git_token

pushd kubecf-helm/
git checkout -b $branch_name
git config --global user.name "akayeshmantha"
git config --global user.email "akayeshmantha@gmail.com"
git config credential.https://github.com.username akayeshmantha
git status
git add $file_name
git commit -m "bump kubecf helm chart ${file_name%.*}"
git config --global credential.helper cache
git config core.sshCommand 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
git config --global core.editor "cat"


git push -f origin kubecf-helm/
git pull-request --no-fork --title "Update kubecf-helm chart." --message "Increment kubecf helm chart version."
popd
