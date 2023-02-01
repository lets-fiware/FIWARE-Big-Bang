# Regproxy

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Related information](#related-information)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name            | Description                            | Default value |
| ------------------------ | -------------------------------------- | ------------- |
| REGPROXY                 | Use regproxy. (true or false)          | false         |
| REGPROXY\_NGSITYPE       | NgsiType for remote broker. (v2 or ld) | v2            |
| REGPROXY\_HOST           | Host for remote broker.                | (empty)       |
| REGPROXY\_IDMTYPE        | IdM type for remote broker.            | (empty)       |
| REGPROXY\_IDMHOST        | IdM host for remote broker.            | (empty)       |
| REGPROXY\_USERNAME       | A username for remote broker.          | (empty)       |
| REGPROXY\_PASSWORD       | A password for remote broker.          | (empty)       |
| REGPROXY\_CLIENT\_ID     | A client id for remote broker.         | (empty)       |
| REGPROXY\_CLIENT\_SECRET | A client secret for remote broker.     | (empty)       |

## How to setup

```bash
REGPROXY=false
REGPROXY_HOST=https://remote-orion.example.com/
REGPROXY_IDMTYPE=keyrock
REGPROXY_IDMHOST=http://keyrock.example.com/oauth2/token
REGPROXY_USERNAME=admin@test.com
REGPROXY_PASSWORD=1234
REGPROXY_CLIENT_ID=a1a6048b-df1d-4d4f-9a08-5cf836041d14
REGPROXY_CLIENT_SECRET=e4cc0147-e38f-4211-b8ad-8ae5e6a107f9
```

## Related information

-   [regproxy - NGSI Go](https://ngsi-go.letsfiware.jp/convenience/regproxy/)
-   [regproxy example - NGSI Go](https://github.com/lets-fiware/ngsi-go/tree/main/extras/registration_proxy)
