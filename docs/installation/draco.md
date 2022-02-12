# Draco

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Related information](#related-information)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name              | Description                                    | Default value |
| -------------------------- | ---------------------------------------------- | ------------- |
| DRACO                      | A sub-domain name of Draco                     | (empty)       |
| DRACO\_MONGO               | Use MongoDB sink for Draco. true or false      | false         |
| DRACO\_MYSQL               | Use MySQL sink for Draco. true or false        | false         |
| DRACO\_POSTGRES            | Use PostgreSQL sink for Draco. true or false   | false         |
| DRACO\_EXPOSE\_PORT        | Expose port for Draco. (none, local, all) 5050 | none          |
| DRACO\_DISABLE\_NIFI\_DOCS | Enable NiFi Documentation path (/nifi-docs)    | true          |

## How to setup

To set up Draco, configure some environment variables in config.sh.

First, set a sub-domain name for Draco to `DRACO=` as shown:

```bash
DRACO=draco
```

And set one or more databases used for storing persistent data to `true`:

```bash
DRACO_MONGO=
DRACO_MYSQL=
DRACO_POSTGRES=
```
## Related information

-   [ging / fiware-draco - GitHub](https://github.com/ging/fiware-draco)
-   [FIWARE Draco - readthedocs.io](https://fiware-draco.readthedocs.io/en/latest/)
-   [Apache NiFi System Administrator’s Guide](https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html)
-   [ging/fiware-draco - Docker Hub](https://hub.docker.com/r/ging/fiware-draco)
