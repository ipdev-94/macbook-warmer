#!/bin/bash
# MacBook Warmer — heats up your CPU cores to warm your lap
# Usage:   ./warmup.sh        (starts warming)
#          ./warmup.sh stop   (stops all warmers)
#
# Press Ctrl+C to stop, or run: ./warmup.sh stop

NUM_CORES=${1:-6}

if [ "$1" = "stop" ]
then
    echo "Cooling down... killing all warmer processes."
    pkill -f "warmup_worker"
    exit 0
fi

# Validate
if ! [[ "$NUM_CORES" =~ ^[0-9]+$ ]] || [ "$NUM_CORES" -lt 1 ]
then
    NUM_CORES=6
fi

echo "MacBook Warmer — spinning up $NUM_CORES cores"
echo "   Press Ctrl+C to stop (or run: $0 stop)"
echo ""

cleanup()
{
    echo ""
    echo "Cooling down..."
    kill $(jobs -p) 2>/dev/null
    wait 2>/dev/null
    echo "Done. MacBook will cool off now."
    exit 0
}
trap cleanup SIGINT SIGTERM

for i in $(seq 1 "$NUM_CORES"); do
    bash -c 'exec -a warmup_worker bash -c "while true; do :; done"' &
    echo "Core $i warming..."
done

echo ""
echo "All cores running! Your lap should warm up in ~30 seconds."
echo "Battery will drain faster. Don't forget to stop it!"

# Wait for Ctrl+C
wait
