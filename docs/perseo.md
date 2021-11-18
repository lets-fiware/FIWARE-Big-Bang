# Perseo

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Sanity check for Perseo](#sanity-check-for-perseo)
-   [Related information](#related-information)

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name        | Description                                                      | Default value |
| -------------------- | ---------------------------------------------------------------- | ------------- |
| PERSEO               | A sub-domain name of Perseo                                      | (empty)       |
| PERSEO\_MAX\_AGE     | The expiration time for dangling rules in milliseconds.          | 6000          |
| PERSEO\_SMTP\_HOST   | Host of the SMTP server for Perseo.                              | (empty)       |
| PERSEO\_SMTP\_PORT   | Port of the SMTP server for Perseo.                              | (empty)       |
| PERSEO\_SMTP\_SECURE | true if SSL should be used with the SMTP server. (true or false) | (empty)       |
| PERSEO\_LOG\_LEVEL   | Log level for Perseo.                                            | info          |

## How to setup

To set up Perseo, configure some environment variables in config.sh.

First, set a sub-domain name for Perseo to `CYGNUS=` as shown:

```bash
PERSEO=perseo
```

## Sanity check for Perseo

Once Perseo is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host perseo.example.com --pretty
```

#### Response:

```json
{
  "error": null,
  "data": {
    "name": "perseo",
    "description": "IOT CEP front End",
    "version": "1.20.0"
  }
}
```

## Related information

-   [Perseo Context-Aware CEP - GitHub](https://github.com/telefonicaid/perseo-fe)
-   [Perseo-core (EPL server) - GitHub](https://github.com/telefonicaid/perseo-core)
-   [NGSI Go tutorial for Perseo](https://ngsi-go.letsfiware.jp/tutorial/perseo/)
