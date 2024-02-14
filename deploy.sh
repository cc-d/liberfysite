#!/bin/sh

#
# Simple auto-deployment script for Git repositories
# Meant to be used with cron
#

REPO_DIR="$HOME/liberfysite"
REMOTE_REPO_URL="https://github.com/cc-d/liberfysite.git"

# Navigate to the Git repository
cd "$REPO_DIR" || exit

# Fetch changes from the remote repository without merging them
echo "Fetching changes from the remote repository..."
git fetch origin

# Check if there are any changes by comparing the local and remote branches
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
echo "Local: $LOCAL" "Remote: $REMOTE"

if [ "$LOCAL" != "$REMOTE" ]; then
    # Pull changes from the remote repository
    echo "Pulling changes from the remote repository..."
    git pull

    echo "Copying files to /var/www/html..."
    mkdir -p /var/www/html
    cp -r $REPO_DIR/* /var/www/html/
fi



