#!/bin/bash

workDir=`pwd`;
sourcePath="$workDir/commits";
repositoryName="svn-repo";
projectName="proj";
svnRepoDir="/tmp";
repositoryFullPath=$svnRepoDir/$repositoryName;
projectWCPath=$repositoryName/$projectName;
initStructurePath=$svnRepoDir/$projectName

parse_conflicted_files() { 
	while read line; do 
		if [[ $line =~ ^\!?\ *C\ *(.*)$ ]]; then 
			echo ${BASH_REMATCH[1]}; 
		fi; 
	done;
}

clearWorkDir() {
	echo "[INFO] clear dirs";
	rm -rf $repositoryFullPath $projectWCPath $initStructurePath 2>/dev/null;
}

loadAndCommit() {
	echo "[INFO] load r$1 [$2]";
	
	set -f;
	conflictedFiles=`svn status | parse_conflicted_files`;

	while [[ $conflictedFiles ]]; do
		echo "[INFO] try to auto resolve conflicts";
		for file in $conflictedFiles; do
			svn resolve $file --accept=working; 
		done;
		conflictedFiles=`svn status | parse_conflicted_files`;
	done;
	
	set +f;
	cp $sourcePath/r$1/* .;
	set -f;

	for file in `ls`; do
		if ! [[ -f $sourcePath/r$1/$file ]]; then
			svn rm $file;
		fi
	done;

	newFiles=`svn status | egrep '^\?.*$' | cut -c 2- | tr -d ' '`;
	for newFile in $newFiles; do svn add "$newFile"; done;
	set +f;
	
	svn commit -m "$2 [commit$1]" --username $3;
}

init() {
	echo "[INFO] check paths";
	if [ -d $repositoryFullPath ]; then
		echo "[ERROR] " $repositoryFullPath "already exists";
		return -1;
	fi
	if [ -d $projectWCPath ]; then
		echo "[ERROR] " $projectWCPath "already exists";
		return -1;
	fi


	echo "[INFO] start init svn repo";
	svnadmin create $repositoryFullPath;

	echo "[INFO] create init structure dirs";
	mkdir -p $initStructurePath/trunk $initStructurePath/branches $initStructurePath/tags;

	echo "[INFO] import init structure to repo";
	svn import $initStructurePath file://$repositoryFullPath/$projectName -m "init";
	
	echo "[INFO] checkout project";
	svn checkout file://$repositoryFullPath/$projectName/trunk $projectWCPath
}

createBranch() {
	echo "[INFO] create branch $2 from $1";
	svn copy file://$repositoryFullPath/$projectName/$1 \
	file://$repositoryFullPath/$projectName/branches/$2 -m $3 --username $4;
}

switch() {
	echo "[INFO] switch to $1";
	svn switch file://$repositoryFullPath/$projectName/$1;
}

createBranchAndSwitch() {
	createBranch $1 $2 $3 $4;
	switch branches/$2;
}

merge() {
	svn merge file:///$repositoryFullPath/$projectName/$1 --accept p --username $2;
}

main() {
	if ! [[ -d commits ]]; then
		echo "[ERROR] cd to dir with commits/";
		return -1;
	fi
	clearWorkDir;
	init;
	cd $projectWCPath;
	loadAndCommit 0 "commit-by-red-user" red;
	createBranchAndSwitch trunk some-feature-by-red-user "some-feature-by-red-user" red;
	loadAndCommit 1 "commit-by-red-user" red;
	createBranchAndSwitch branches/some-feature-by-red-user \
	some-feature-by-blue-user "some-featur-by-blue-user" blue;
	loadAndCommit 2 "commit-by-blue-user" blue;
	loadAndCommit 3 "commit-by-blue-user" blue;
	switch trunk;
	loadAndCommit 4 "commit-by-red-user" red;
	switch branches/some-feature-by-red-user;
	loadAndCommit 5 "commit-by-red-user" red;
	loadAndCommit 6 "commit-by-red-user" red;
	switch branches/some-feature-by-blue-user;
	loadAndCommit 7 "commit-by-blue-user" blue;
	switch trunk;
	loadAndCommit 8 "commit-by-red-user" red;
	switch branches/some-feature-by-blue-user;
	loadAndCommit 9 "commit-by-blue-user" blue;
	loadAndCommit 10 "commit-by-blue-user" blue;
	loadAndCommit 11 "commit-by-blue-user" blue;
	switch branches/some-feature-by-red-user;
	loadAndCommit 12 "commit-by-red-user" red;
	switch branches/some-feature-by-blue-user;
	merge branches/some-feature-by-red-user blue;
	loadAndCommit 13 "commit-by-blue-user" blue;
	switch trunk;
	merge branches/some-feature-by-blue-user red;
	loadAndCommit 14 "commit-by-blue-user" blue;
	
	cd - 1>/dev/null
}

main;
