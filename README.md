# Git Helpers
This is a collection of mise toml based Git aliases, functions and scripts that could be added to environment on demand due to mise.

If any of the tomls are added to any git project, it ensures git installation using mise.

Refer to the script files and toml files to get what git command shortcuts, scripts are present.

## Prerequisites
Must have - System must have already installed https://github.com/jdx/mise tool which is the basis of using weegit

Good to have - Users can pre-install wee tool from https://github.com/chetanc10/wee that works along with mise to help users setup and maintain many wee enabled repos.

# Installation
## With mise
The repo can be cloned or it can downloaded or a set of files can be downloaded and copied to relevant git project root directories.

## With wee
For systems already having wee installed:
1. Install weegit using wee:
   ```wee install https://github.com/chetanc10/weegit```
2. Inside any target git project in the system:
   ```wee add chetanc10/weegit``` => installs all tomls and scripts
   ```wee add chetanc10/weegit base.toml rebase.toml gins.bash``` => installs specified fragments to local git project
   These are all mise controlled and so they'll be defined and undefined upon entry and exit respectively into the project.
3. To remove any fragment from a git proect:
   ```wee add chetanc10/weegit``` => removes all tomls and scripts
   ```wee add chetanc10/weegit base.toml gins.bash``` => removes specified fragments from local git project 
