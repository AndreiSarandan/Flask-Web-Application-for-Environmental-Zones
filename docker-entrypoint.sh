#!/bin/sh
set -eu

# All Gunicorn workers share one fresh metrics directory per server run.
if [ "${1:-}" = "gunicorn" ]; then
    PROMETHEUS_MULTIPROC_DIR=$(mktemp -d /tmp/lez-prometheus.XXXXXX)
    export PROMETHEUS_MULTIPROC_DIR
fi

exec "$@"
