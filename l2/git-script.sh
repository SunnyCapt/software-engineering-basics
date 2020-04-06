#!/bin/bash 

mkdir git-proj 
cd "git-proj"
git init
git status
echo ".DS_Store 
 .AppleDouble 
 .LSOverride" > .gitignore
git add .gitignore
alias biba="git config --local user.name 'Biba'; git config --local user.email 'biba@gmail.com
alias boba='git config --local user.name "Boba"; git config --local user.email "boba@gmail.com

#commit 0 
boba
yes | cp -rfv ../commits/commit0/* ./ 
git add -A
git commit -m r0
#commit 1 
git checkout -b r1
yes | cp -rfv ../commits/commit1/* ./ 
git add -A
git commit -m r1
#commit 2 
biba
git checkout -b r2
yes | cp -rfv ../commits/commit2/* ./ 
git add -A
git commit -m r2
#commit 3 
yes | cp -rfv ../commits/commit3/* ./ 
git add -A
git commit -m r3
#commit 4 
boba
git checkout master 
yes | cp -rfv ../commits/commit4/* ./ 
git add -A
git commit -m r4
#commit 5 
git checkout r1 
yes | cp -rfv ../commits/commit5/* ./ 
git add -A
git commit -m r5
#commit 6 
git checkout r1 
yes | cp -rfv ../commits/commit6/* ./ 
git add -A
git commit -m r6
#commit 7 
biba
git checkout r2 
yes | cp -rfv ../commits/commit7/* ./ 
git add -A
git commit -m r7
#commit 8 
boba
git checkout master 
yes | cp -rfv ../commits/commit8/* ./ 
git add -A
git commit -m r8
#commit 9 
biba
git checkout r2 
yes | cp -rfv ../commits/commit9/* ./ 
git add -A
git commit -m r9
#commit 10
yes | cp -rfv ../commits/commit10/* ./
git add -A
git commit -m r10 
#commit 11
yes | cp -rfv ../commits/commit11/* ./
git add -A
git commit -m r11 
#commit 12
boba
git checkout r1 
yes | cp -rfv ../commits/commit12/* ./
git add -A
git commit -m r12 
#commit 13
biba
git checkout r2 
git merge --no-ff r1
cp -rfv ../commits/commit13/* ./
git checkout --ours -- *
git checkout --ours -- J.java 
git checkout --ours -- I.java 
git add -A
git commit -m r13 
#commit 14
boba
git checkout master 
git merge --no-ff r2
rm -fv "*"
rm -fv "ABNQBatpyO.0W1" 
cp -rfv ../commits/commit14/* ./
git checkout --ours -- ./*
git add -A
git commit -m r14 

git log --all --decorate --oneline --graph