# Keyrock

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Sanity check for Keyrock](#sanity-check-for-keyrock)
-   [Access Keyrock GUI](#access-keyrock-gui)
-   [Examples](#examples)
-   [Related information](#related-information)

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name     | Description                                                      | Default value                   |
| ----------------- | ---------------------------------------------------------------- | ------------------------------- |
| KEYROCK           | A sub-domain name of Keyrock (Required)                          | keyrock                         |
| IDM\_ADMIN\_NAME  | A name of an admin user for Keyrock                              | admin                           |
| IDM\_ADMIN\_EMAIL | An email address of an admin user for Keyrock                    | IDM\_ADMIN\_NAME @ DOMAIN\_NAME |
| IDM\_ADMIN\_PASS  | A password of an admin user for Keyrock                          | (Automatically generated)       |
| KEYROCK\_POSTGRES | Use PostgreSQL as backend database for Keyrock. (true or false)  | false                           |

## How to setup

To set up Keyrock, configure an environment variable in config.sh.
Set a sub-domain name for Keyrock to `KEYROCK` as shown:

```bash
KEYROCK=keyrock
```

## Sanity check for Keyrock

Once Keyrock is running, you can check the status by the following command:

#### Request:

```bash
curl https://keyrock.example.com/version
```

#### Response:

```json
{
  "keyrock": {
    "version": "8.1.0",
    "release_date": "2021-07-22",
    "uptime": "00:23:14.3",
    "git_hash": "https://github.com/ging/fiware-idm/releases/tag/8.1.0",
    "doc": "https://fiware-idm.readthedocs.io/en/8.1.0/",
    "api": {
      "version": "v1",
      "link": "https://keyrock.example.com/v1"
    }
  }
}
```

## Access Keyrock GUI

Open at `https://keyrock.example.com` to access the Keyrock GUI.

## Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/keyrock).

## Related information

-   [Keyrock - GitHub](https://github.com/ging/fiware-idm)
-   [Keyrock portal site](https://keyrock-fiware.github.io/)
-   [Keyrock API - Apiary](https://keyrock.docs.apiary.io/#)
-   [Keyrock - Read the docs](https://fiware-idm.readthedocs.io/)
-   [Identity Management - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/identity-management.html)
-   [NGSI Go tutorial for Keyrock](https://ngsi-go.letsfiware.jp/tutorial/keyrock/)
