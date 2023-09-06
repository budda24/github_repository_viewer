#!/bin/bash
set -e

# Get the top-level directory of the Git repository
git_root=$(git rev-parse --show-toplevel)

# Get the .git directory path
git_dir="$git_root/.git"

# Get and create hooks directory path
git_hooks_dir="$git_dir/hooks"
mkdir -p $git_hooks_dir

# Loop through all local hook files in the hooks directory
for hook in ./hooks/*; do
echo $hook
# Get the absolute path of the hook file
abs_hook_path=$(readlink -f $hook)

# Extract the file name without path
FILE_WITHOUT_PATH=${hook##*/}

# Get the absolute path of the target .git/hooks directory
abs_target_path=$(readlink -f $git_hooks_dir)
echo  $abs_target_path
# Create symlinks to local hooks
ln -s -f $abs_hook_path $abs_target_path/$FILE_WITHOUT_PATH

# Make sure all files that symlinks point to are executable
chmod ug+x $hook

# Display the symlink target using ls -l
ls -l $abs_target_path/$FILE_WITHOUT_PATH

done