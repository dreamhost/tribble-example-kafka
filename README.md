# kafka-tribble

A single-node Apache Kafka (KRaft, no ZooKeeper) for [tribble](https://www.dreamhost.com),
built from the official `apache/kafka` image.

It is an internal service: other apps of the same account reach it at `tribble-<app id>:9092`,
and it has no public address. Give a client the address by reference, not by copying it:

| client variable | reference |
| :-- | :-- |
| `KAFKA_BOOTSTRAP_SERVERS` | `<this app's TRIBBLE_HOST>:9092` |

## Deploying

Create an app from this repository with the address turned off (internal), a volume, and at
least 1 CPU and 1.5 GiB of memory. `tribble.json` sets the port (9092), a TCP health check and
the volume path. No variables are needed.

## Notes

- **The advertised address is set at start.** `start.sh` builds `KAFKA_ADVERTISED_LISTENERS`
  from `TRIBBLE_HOST`. Set `KAFKA_ADVERTISED_HOST` to override it.
- **One port.** The controller listener is bound to localhost, so only 9092 is served.
- **No authentication and no TLS.** Anything in the account's namespace can read and write.
  Do not give this app a public address.
- **One replica only.** There is one broker and every topic has one replica, so running two
  replicas of this app would be two separate clusters behind one name.
- **Topics are created on first use**, with one partition. Data is kept for a week, up to
  1 GiB per partition.
- Any other broker setting is a variable: `KAFKA_<SETTING_NAME>` with dots as underscores.
