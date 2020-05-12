#!/bin/bash

file_name=$(basename fileName=$(find outputfolder/ -type f -name 'kubecf-v*'));
branch_name="${file_name%.*}"
mv outputfolder/kubecf-v* kubecf-helm

export GIT_ASKPASS=kubecf-master/.concourse/tasks/git-password.sh

pushd kubecf-helm/
git checkout -b $branch_name
git config --global user.name "akayeshmantha"
git config --global user.email "akayeshmantha@gmail.com"
git status
git add $file_name
git commit -m "bump kubecf helm chart ${file_name%.*}"

git push -f https://$git_token@github.com/Akayeshmantha/kubecf-helm $branch_name
git pull-request --no-fork --title "Update kubecf-helm chart." --message "Increment kubecf helm chart version."
popd
