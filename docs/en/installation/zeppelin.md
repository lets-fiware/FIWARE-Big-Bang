# Apache Zeppelin (Experimental support)

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Related information](#related-information)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name   | Description                    | Default value |
| --------------- | ------------------------------ | ------------- |
| ZEPPELIN        | A sub-domain name of Zeppelin  | (empty)       |
| ZEPPELIN\_DEBUG | Set logging level for Zeppelin | false         |

## How to setup

To set up Zeppelin, configure an environment variable in config.sh.
Set a sub-domain name for Zeppelin to `ZEPPELIN=` as shown:

```bash
ZEPPELIN=zeppelin
```

## Related information

-   [Apache Zeppelin](https://zeppelin.apache.org/)
-   [Zeppelin - GitHub](https://github.com/apache/zeppelin)
