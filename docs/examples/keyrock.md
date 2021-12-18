# Keyrock

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Sanity check for Keyrock](#sanity-check-for-keyrock)
-   [Access Keyrock GUI](#access-keyrock-gui)
-   [Examples](#examples)
-   [Related information](#related-information)

</details>

## Sanity check for Keyrock

Once Keyrock is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host keyrock.example.com --pretty
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

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/keyrock/keyrock-sign-in.png)

## Create user

### Create a user

Request:

```
ngsi users create --host keyrock.example.com --username user001 --email user001@example.com --password 1234
```

Response:

```
36d8086c-4fc4-4954-9ee2-592e7debe5a0
```

Request:

```
ngsi users get --uid 36d8086c-4fc4-4954-9ee2-592e7debe5a0 --pretty
```

Response:

```
{
  "user": {
    "scope": [],
    "id": "36d8086c-4fc4-4954-9ee2-592e7debe5a0",
    "username": "user001",
    "email": "user001@example.com",
    "enabled": true,
    "admin": false,
    "image": "default",
    "gravatar": false,
    "date_password": "2021-12-18T21:26:30.000Z",
    "description": null,
    "website": null
  }
}
```

### Create users

Request:

```
#!/bin/sh
set -ue

HOST=keyrock
DOMAIN=example.com

for id in $(seq 10)
do
 USER=$(printf "user%03d" $id)
 PASS=$(pwgen -s 16 1)
 ngsi users create --host "${HOST}.${DOMAIN}" --username "${USER}" --email "${USER}@${DOMAIN}" --password "${PASS}" > /dev/null
 echo "${USER}@${DOMAIN} ${PASS}"
done
```

Response:

```
user001@e-suda.info Uu2HADXh5ITIlIVt
user002@e-suda.info Gbf4njxTp3tZApje
user003@e-suda.info J6aNl3phuOurh8x8
user004@e-suda.info 2Jm5bP7RJJmMD6D9
user005@e-suda.info midj714vE8pD9ULs
user006@e-suda.info jbrk2SC3SdVNsW8W
user007@e-suda.info wlxTAGdRHU6ESmRa
user008@e-suda.info sBfWNhVaye0zLHWh
user009@e-suda.info R6ES3ezcdTXst2TI
user010@e-suda.info A2djP94QYrH2LgVw
```

The `pwgen` program generates passwords. You can install it by following the steps below:

-   Ubuntu

```
apt update
apt install -y pwgen
```

-   CentOS

```
yum install -y epel-release
yum install -y pwge
```

## Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/keyrock).

## Related information

-   [Keyrock - GitHub](https://github.com/ging/fiware-idm)
-   [Keyrock portal site](https://keyrock-fiware.github.io/)
-   [Keyrock API - Apiary](https://keyrock.docs.apiary.io/#)
-   [Keyrock - Read the docs](https://fiware-idm.readthedocs.io/)
-   [Identity Management - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/identity-management.html)
-   [NGSI Go tutorial for Keyrock](https://ngsi-go.letsfiware.jp/tutorial/keyrock/)
