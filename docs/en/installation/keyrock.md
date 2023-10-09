# Keyrock

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Related information](#related-information)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name        | Description                                                              | Default value                   |
| -------------------- | ------------------------------------------------------------------------ | ------------------------------- |
| KEYROCK              | A sub-domain name of Keyrock (Required)                                  | keyrock                         |
| IDM\_ADMIN\_USER     | A name of an admin user for Keyrock                                      | admin                           |
| IDM\_ADMIN\_EMAIL    | An email address of an admin user for Keyrock                            | IDM\_ADMIN\_USER @ DOMAIN\_NAME |
| IDM\_ADMIN\_PASS     | A password of an admin user for Keyrock                                  | (Automatically generated)       |
| IDM\_DEBUG           | Use logging for Keyrock (true or false)                                  | false                           |
| POSTFIX              | Use Postfix (local delivery). (true or false)                            | false                           |
| WILMA\_AUTH\_ENABLED | Whether to enable basic authentication on the PEP proxy. (true or false) | false                           |

## How to setup

To set up Keyrock, configure an environment variable in config.sh.
Set a sub-domain name for Keyrock to `KEYROCK=` as shown:

```bash
KEYROCK=keyrock
```

## Related information

-   [Keyrock - GitHub](https://github.com/ging/fiware-idm)
-   [Keyrock portal site](https://keyrock-fiware.github.io/)
-   [Keyrock API - Apiary](https://keyrock.docs.apiary.io/#)
-   [Keyrock - Read the docs](https://fiware-idm.readthedocs.io/)
-   [Identity Management - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/identity-management.html)
-   [NGSI Go tutorial for Keyrock](https://ngsi-go.letsfiware.jp/tutorial/keyrock/)
-   [ging/fiware-idm - Docker Hub](https://hub.docker.com/r/ging/fiware-idm)
-   [ging/fiware-pep-proxy - Docker Hub](https://hub.docker.com/r/ging/fiware-pep-proxy)
