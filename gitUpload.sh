#!/bin/bash

if [ "$1" = "-" ]; then
  COMMIT_MESSAGE="Update"
else
  COMMIT_MESSAGE="$*"
fi

git add .
git commit -m "$COMMIT_MESSAGE"
git push origin main