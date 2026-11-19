#!/bin/sh
# Kafka tells every client where to reconnect, so it has to know its own address, and that is
# only known at run time. tribble gives each app its internal hostname as TRIBBLE_HOST.
set -eu

host="${KAFKA_ADVERTISED_HOST:-${TRIBBLE_HOST:-localhost}}"
export KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://${host}:9092"
echo "advertising ${KAFKA_ADVERTISED_LISTENERS}"

exec /etc/kafka/docker/run
