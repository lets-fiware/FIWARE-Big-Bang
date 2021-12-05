# Troubleshooting

## QuantumLeap with CrateDB

QuantumLeap has CrateDB a backend database to persists historic context data. If CrateDB exits immediately with a
`max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]` error, this can be fixed
by running the `sudo sysctl -w vm.max_map_count=262144` command on the host machine. For further information look within
the CrateDB [documentation](https://crate.io/docs/crate/howtos/en/latest/admin/bootstrap-checks.html#bootstrap-checks)
and Docker
[troubleshooting guide](https://crate.io/docs/crate/howtos/en/latest/deployment/containers/docker.html#troubleshooting)

```
sudo sysctl -w vm.max_map_count=262144
```
