#!/bin/sh

# Simple auto-deployment script for Git repositories
# Meant to be used with cron

if [ ! -z "$1" ]; then
    if [ "$1" = "force" ]; then
        # Force deployment
        echo "Forcing deployment..."
    else
        # Unrecognized option
        echo "Unrecognized option: $1"
        exit 1
    fi
fi

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

LOC_STATS_JS="$REPO_DIR/html/js/stats.js"
REM_STATS_JS="/var/www/html/js/stats.js"

if [ "$LOCAL" != "$REMOTE" ] || [ "$1" = "force" ]; then
    # Pull changes from the remote repository
    if [ -f "$REM_STATS_JS" ]; then
        echo "not overwriting stats.js, removing local before cp"
        rm "$REPO_DIR/html/js/stats.js"
    fi
    echo 'resetting index.html'
    git checkout html/index.html
    echo "Pulling changes from the remote repository..."
    git pull

    echo "Copying files to /var/www/html..."
    mkdir -p /var/www/html

    ./cachebust.sh

    cp -r $REPO_DIR/html/* /var/www/html
fi
