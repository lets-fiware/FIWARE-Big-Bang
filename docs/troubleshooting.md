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

## Cannot create new user with "ngsi users create"

If you receive the following error message with "Invalid email" from NGSI Go, please check if a domain of the email
address is in `config/keyrock/whitelist.txt`.

```
ngsi users create --host keyrock --username user001 --email user001@example.com --password 1234
usersCreate003 error 400 Bad Request {"error":{"message":"Invalid email","code":400,"title":"Bad Request"}}
```

If the domain is not existed, add it to `config/keyrock/whitelist.txt` and restart your Keyrock instance. The FIWARE Big
bang sets up a Keyrock instance with `whitelist` as the email list type. Please see [Keyrock documentation](https://fiware-idm.readthedocs.io/en/latest/installation_and_administration_guide/configuration/index.html#email-filtering)
in detail.
