#!/bin/sh
set -eu

runtime_root=/var/data/eaglercraft-runtime
port=${PORT:-8081}

case "$port" in
  *[!0-9]*|'')
    echo "PORT must be a numeric TCP port" >&2
    exit 1
    ;;
esac

if [ ! -d "$runtime_root/bungee" ]; then
  mkdir -p "$runtime_root"
  cp -a /app/bungee "$runtime_root/bungee"
  cp -a /app/server "$runtime_root/server"
fi

sed -i "0,/^  address: 0\.0\.0\.0:[0-9][0-9]*$/s//  address: 0.0.0.0:$port/" \
  "$runtime_root/bungee/plugins/EaglercraftXBungee/listeners.yml"

cd "$runtime_root/bungee"
java -jar bungee.jar &
proxy_pid=$!

cleanup() {
  kill "$proxy_pid" 2>/dev/null || true
  wait "$proxy_pid" 2>/dev/null || true
}

trap cleanup EXIT INT TERM

cd "$runtime_root/server"
java -jar server.jar
