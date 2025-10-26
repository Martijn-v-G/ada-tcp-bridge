#!/usr/bin/env bash
set -euo pipefail

BRIDGE_CMD=./bin/bridge     # path to your built bridge binary (adjust if needed)
PORT=42000
LOGFILE=bridge.log
BUILD_CMD=./build         # the build command you mentioned

# How long to wait for the server to accept connections (seconds)
WAIT_STARTUP=5
# Delay between messages (seconds)
DELAY_BETWEEN=1

# Message bytes (first and second). Adjust second message if you want different content.
MSG1=\x01\x00HELO
MSG2=\x01\x00HELO

# Kill helper: tries graceful then force
kill_graceful() {
  pid="$1"
  if kill -0 "$pid" 2>/dev/null; then
    echo "Stopping bridge (PID $pid)..."
    kill "$pid"
    # wait up to 3 seconds for it to exit
    for i in {1..6}; do
      if ! kill -0 "$pid" 2>/dev/null; then
        echo "Bridge exited."
        return 0
      fi
      sleep 0.5
    done
    echo "Bridge did not exit, sending SIGKILL..."
    kill -9 "$pid" 2>/dev/null || true
  else
    echo "Bridge (PID $pid) not running."
  fi
}


# Wait for a TCP port to be open (using bash /dev/tcp)
wait_for_port() {
  local host=127.0.0.1
  local port=$1
  local timeout=$2
  local start
  start=$(date +%s)
  while :; do
    # attempt connection (redirect fd)
    if bash -c "echo > /dev/tcp/${host}/${port}" >/dev/null 2>&1; then
      return 0
    fi
    now=$(date +%s)
    if (( now - start >= timeout )); then
      return 1
    fi
    sleep 0.2
  done
}

# Ensure we clean up the bridge if the script is interrupted
BRIDGE_PID=0
cleanup() {
  if [ "$BRIDGE_PID" -ne 0 ]; then
    kill_graceful "$BRIDGE_PID" >/dev/null 2>&1
  fi
}
trap cleanup EXIT INT TERM

echo "Building..."
$BUILD_CMD

echo "Starting bridge on port $PORT (logging to $LOGFILE)..."
# Start bridge in background, redirect output to log
$BRIDGE_CMD "$PORT" &> "$LOGFILE" &
BRIDGE_PID=$!
echo "Bridge started with PID $BRIDGE_PID"

sleep 0.5

echo "Sending first message..."
printf "\\x01\\x00HELO" | nc -q 0 127.0.0.1 42000

sleep "$DELAY_BETWEEN"

echo "Sending second message..."
printf "\\x01\\x00WRLD" | nc -q 0 127.0.0.1 42000

# Optional small wait to let bridge process messages and write logs
sleep 0.5

echo "Killing bridge if still running..."
kill_graceful "$BRIDGE_PID"

echo "Done. Bridge log:"
grep "Decode" "$LOGFILE" || true
