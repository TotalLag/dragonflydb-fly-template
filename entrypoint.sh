#!/bin/sh
set -e

# This script is the entrypoint for the Docker container.
# It ensures that the DragonflyDB server is started with the password
# provided by the DRAGONFLY_PASSWORD environment variable at runtime.

# Check if the password variable is set. If not, exit with an error.
if [ -z "$DRAGONFLY_PASSWORD" ]; then
  echo "FATAL: The DRAGONFLY_PASSWORD environment variable is not set." >&2
  exit 1
fi


# Use 'exec' to replace the shell process with the DragonflyDB process.
# This is important for proper signal handling (e.g., for shutdowns).
exec dragonfly \
    --logtostderr \
    --bind=0.0.0.0 \
    --dir=/data \
    --dbfilename=dump \
    --snapshot_cron='*/10 * * * *' \
    --maxmemory=256mb \
    --requirepass="$DRAGONFLY_PASSWORD"