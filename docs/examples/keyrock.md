# Keyrock

-   [Sanity check for Keyrock](#sanity-check-for-keyrock)
-   [Access Keyrock GUI](#access-keyrock-gui)
-   [Examples](#examples)
-   [Related information](#related-information)

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
