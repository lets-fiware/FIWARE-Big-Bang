# Cygnus

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Related information](#related-information)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name               | Description                                                                                                       | Default value     |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------- |
| CYGNUS                      | A sub-domain name of Cygnus                                                                                       | (empty)           |
| CYGNUS\_MONGO               | Use MongoDB sink for Cygnus. true or false                                                                        | false             |
| CYGNUS\_MYSQL               | Use MySQL sink for Cygnus. true or false                                                                          | false             |
| CYGNUS\_POSTGRES            | Use PostgreSQL sink for Cygnus. true or false                                                                     | false             |
| CYGNUS\_ELASTICSEARCH       | Use Elasticsearch sink for Cygnus. true or false                                                                  | false             |
| CYGNUS\_EXPOSE\_PORT        | Expose port for Cygnus. (none, local, all) 5051 for Mongo, 5050 for MySQL, 5055 for Postgres, 5058 for PostgreSQL | none              |
| CYGNUS\_LOG\_LEVEL          | Set logging level for Cygnus. (INFO, DEBUG)                                                                       | info              |
| ELASTICSEARCH               | A sub-domain name of Elasticsearch                                                                                | (empty)           |
| ELASTICSEARCH\_JAVA\_OPTS   | Set Java options for Elasticsearch                                                                                | -Xmx256m -Xms256m |
| ELASTICSEARCH\_EXPOSE\_PORT | Expose port (none, local, all) for Elasticsearch                                                                  | none              |

## How to setup

To set up Cygnus, configure some environment variables in config.sh.

First, set a sub-domain name for Cygnus to `CYGNUS=` as shown:

```bash
CYGNUS=cygnus
```

And set one or more databases used for storing persistent data to `true`:

```bash
CYGNUS_MONGO=
CYGNUS_MYSQL=
CYGNUS_POSTGRES=
CYGNUS_ELASTICSEARCH=
```

When using Elasticsearch, set a sub-domain name for Elasticsearch as shown:

```bash
ELASTICSEARCH=elasticsearch
```

## Related information

-   [FIWARE Cygnus documentation](https://fiware-cygnus.readthedocs.io/en/latest/)
-   [FIWARE Cygnus - GitHub](https://github.com/telefonicaid/fiware-cygnus)
-   [Persisting context (Apache Flume) - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/historic-context-flume.html)
