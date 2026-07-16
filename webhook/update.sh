#!/bin/sh
set -eu

lock=/etc/webhook/glance-update.lock
if ! mkdir "$lock" 2>/dev/null; then
	echo "An update is already running"
	exit 0
fi
trap 'rmdir "$lock"' EXIT

git -C /repo fetch origin main
git -C /repo reset --hard FETCH_HEAD
