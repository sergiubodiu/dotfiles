https://help.github.com/articles/syncing-a-fork/

Some workflows require that one or more branches of development on one machine be replicated on another machine, but the two machines cannot be directly connected, and therefore the interactive git protocols (git, ssh, rsync, http) cannot be used. 
https://schacon.github.io/git/git-bundle.html

Assume you want to transfer the history from a repository R1 on machine A to another repository R2 on machine B. We can move data from A to B via some mechanism (CD, email, etc.). We want to update R2 with development made on the branch master in R1.

To bootstrap the process, you can first create a bundle that does not have any basis. You can use a tag to remember up to what commit you last processed, in order to make it easy to later update the other repository with an incremental bundle:

	machineA$ cd R1
	machineA$ git bundle create file.bundle master
	machineA$ git tag -f lastR2bundle master

Then you transfer file.bundle to the target machine B. If you are creating the repository on machine B, then you can clone from the bundle as if it were a remote repository instead of creating an empty repository and then pulling or fetching objects from the bundle:

	machineB$ git clone /home/me/tmp/file.bundle R2

This will define a remote called "origin" in the resulting repository that lets you fetch and pull from the bundle. The $GIT_DIR/config file in R2 will have an entry like this:

[remote "origin"]
    url = /home/me/tmp/file.bundle
    fetch = refs/heads/*:refs/remotes/origin/*

To update the resulting mine.git repository, you can fetch or pull after replacing the bundle stored at /home/me/tmp/file.bundle with incremental updates.

After working some more in the original repository, you can create an incremental bundle to update the other repository:

	machineA$ cd R1
	machineA$ git bundle create file.bundle lastR2bundle..master
	machineA$ git tag -f lastR2bundle master

You then transfer the bundle to the other machine to replace /home/me/tmp/file.bundle, and pull from it.

	machineB$ cd R2
	machineB$ git pull
	
Synchronizing Git repositories without a server
-----------------------------------------------
This post describes a method for pushing changes between two repositories without using a server with network connections to both hosts having repositories
http://blog.costan.us/2009/02/synchronizing-git-repositories-without.html

mkdir /path/to/usb/stick/repository.git
git clone --local --bare . /path/to/usb/stick/repository.git

Then register the repository on the USB stick as a remote repository, and push the desired branch to it (if you don't want to push master, substitute your desired branch).

git remote add usb file:///path/to/usb/stick/repository.git
git push usb master

git push usb

On the receiving end, mount the USB stick, and use a file URL for the repository

file:///path/to/usb/stick/repository.git

A few handy commands:

# cloning the repository on the USB stick
git clone file:///path/to/usb/stick/repository.git
# updating a repository cloned from the USB stick using the above command
git pull origin
# adding the USB stick repository as a remote for an existing repository
git remote add usb file:///path/to/usb/stick/repository.git
# updating from a remote repository configured using the above command
git pull usb master


How to add a local repo and treat it as a remote repo
-----------------------------------------------------

~/repo1 $ git remote add repo2 ~/repo2
~/repo1 $ git fetch repo2
~/repo1 $ git merge repo2/foo
