#!/bin/sh
set -eu

lock=/tmp/glance-update.lock
if ! mkdir "$lock" 2>/dev/null; then
	echo "An update is already running"
	exit 0
fi
trap 'rmdir "$lock"' EXIT

git -C /repo pull --ff-only
