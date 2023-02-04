# Queryproxy

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Related information](#related-information)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name | Description                     | Default value |
| ------------- | ------------------------------- | ------------- |
| QUERYPROXY    | Use Queryproxy. (true or false) | false         |

## How to setup

To set up Queryproxy, configure an environment variable in config.sh.
Set a sub-domain name for Queryproxy to `QUERYPROXY=` as shown:

```bash
QUERYPROXY=false
```

## Related information

-   [queryproxy example - NGSI Go](https://github.com/lets-fiware/ngsi-go/tree/main/extras/queryproxy)
