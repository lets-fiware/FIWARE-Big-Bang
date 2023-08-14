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

To run the following examples, replace `example.com` with your domain or sub-domain. If you want to add a user
with an email address with another domain, before doint that, add the domain to `config/keyrock/whitelist.txt`
and restart your Keyrock instance. The FIWARE Big bang sets up a Keyrock instance with `whitelist` as the email
list type. Please see [Keyrock documentation](https://fiware-idm.readthedocs.io/en/latest/installation_and_administration_guide/configuration/index.html#email-filtering)
in detail.

### Create a user

#### Request:

```bash
ngsi users create --host keyrock.example.com --username user001 --email user001@example.com --password 1234
```

#### Response:

```text
36d8086c-4fc4-4954-9ee2-592e7debe5a0
```

#### Request:

```bash
ngsi users get --uid 36d8086c-4fc4-4954-9ee2-592e7debe5a0 --pretty
```

#### Response:

```json
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

#### Request:

```bash
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

#### Response:

```text
user001@example.com Uu2HADXh5ITIlIVt
user002@example.com Gbf4njxTp3tZApje
user003@example.com J6aNl3phuOurh8x8
user004@example.com 2Jm5bP7RJJmMD6D9
user005@example.com midj714vE8pD9ULs
user006@example.com jbrk2SC3SdVNsW8W
user007@example.com wlxTAGdRHU6ESmRa
user008@example.com sBfWNhVaye0zLHWh
user009@example.com R6ES3ezcdTXst2TI
user010@example.com A2djP94QYrH2LgVw
```

The `pwgen` program generates passwords. You can install it by following the steps below:

-   Ubuntu

```bash
apt update
apt install -y pwgen
```

-   CentOS Stream, Rocky Linux or AlmaLinux

```bash
yum install -y epel-release
yum install -y pwgen
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
-   [ging/fiware-idm - Docker Hub](https://hub.docker.com/r/ging/fiware-idm)
-   [ging/fiware-pep-proxy - Docker Hub](https://hub.docker.com/r/ging/fiware-pep-proxy)
