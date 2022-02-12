# Comet

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
    -   [Minimal mode (STH-Comet ONLY)](#minimal-mode-sth-comet-only)
    -   [Formal mode (Cygnus + STH-Comet)](#formal-mode-cygnus--sth-comet)
-   [Related information](#related-information)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name        | Description                                                      | Default value |
| -------------------- | ---------------------------------------------------------------- | ------------- |
| COMET                | A sub-domain name of Comet                                       | (empty)       |
| CYGNUS               | A sub-domain name of Cygnus                                      | (empty)       |
| COMET\_EXPOSE\_PORT  | Expose port for Comet. (none, local, all)                        | none          |
| COMET\_LOGOPS\_LEVEL | Set logging level for Comet. (DEBUG, INFO, WARN, ERROR or FATAL) | INFO          |

## How to setup

### Minimal mode (STH-Comet ONLY)

The minimal mode persists Time Series Context Data into MongoDB through Comet. To set up Comet with minimal mode
(STH-Comet ONLY), configure an environment variable in config.sh. Set a sub-domain name for Comet to `COMET` as shown:

```bash
COMET=comet
```

### Formal mode (Cygnus + STH-Comet)

The formal mode persists Time Series Context Data into MongoDB through Cygnus. To set up Comet with formal mode
(Cygnus + STH-Comet), configure an environment variable in config.sh. Set a sub-domain name for Comet and Cygnus
to `COMET` and `CYGNUS` as shown:

```bash
COMET=comet
CYGNUS=cygnus
```

## Related information

-   [STH-Comet - GitHub](https://github.com/telefonicaid/fiware-sth-comet)
-   [STH-Comet - Read the docs](https://fiware-sth-comet.readthedocs.io/en/latest/)
-   [Short Term History - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/short-term-history.html)
-   [NGSI Go tutorial for STH-Comet](https://ngsi-go.letsfiware.jp/tutorial/comet/)
-   [telefonicaiot/fiware-sth-comet - Docker Hub](https://hub.docker.com/r/telefonicaiot/fiware-sth-comet)
