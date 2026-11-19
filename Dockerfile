FROM apache/kafka:4.3.2

# One node that is both broker and controller (KRaft, no ZooKeeper).
#
# Two listeners: PLAINTEXT on 9092 is the one clients use, and the one tribble.json declares.
# CONTROLLER on 9093 is bound to localhost, since the only controller is this same process.
ENV KAFKA_NODE_ID=1 \
    KAFKA_PROCESS_ROLES=broker,controller \
    KAFKA_LISTENERS=PLAINTEXT://:9092,CONTROLLER://localhost:9093 \
    KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT \
    KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT \
    KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER \
    KAFKA_CONTROLLER_QUORUM_VOTERS=1@localhost:9093 \
    # A fixed id, so a restart with an existing volume is the same cluster.
    CLUSTER_ID=dHJpYmJsZS1rYWZrYS0wMQ \
    # One broker, so every internal topic has one replica.
    KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
    KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
    KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
    KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0 \
    # A subdirectory of the volume: a fresh volume's root holds `lost+found`, which Kafka
    # refuses to start beside.
    KAFKA_LOG_DIRS=/var/lib/kafka/data/logs \
    # Keep a week, and at most 1 GiB per partition, on a 5 GiB volume.
    KAFKA_LOG_RETENTION_HOURS=168 \
    KAFKA_LOG_RETENTION_BYTES=1073741824 \
    KAFKA_HEAP_OPTS="-Xms512m -Xmx512m"

COPY --chmod=755 start.sh /usr/local/bin/start.sh
CMD ["/usr/local/bin/start.sh"]
