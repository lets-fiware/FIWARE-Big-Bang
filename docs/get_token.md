# How to get an access token

-   [Prerequisite](#prerequisite)
-   [Get an access token from Tokenproxy](#get-an-access-token-from-tokenproxy)
-   [Get an access token from Keyrock](#get-an-access-token-from-keyrock)
-   [Get an access token with NGSI Go](#get-an-access-token-with-ngsi-go)
-   [Examples](#examples)
-   [Related information](#related-information)

## Prerequisite

To get an access token, you need a username and a password. They are in a `.env` file
which is in a directory you ran lets-fiware.sh.

The `IDM_ADMIN_EMAIL` variable has a username.

```bash
cat .env | grep IDM_ADMIN_EMAIL
```

```bash
IDM_ADMIN_EMAIL=admin@example.com
```

The `IDM_ADMIN_PASS` variable has a password.

```bash
cat .env | grep IDM_ADMIN_PASS
```

```bash
IDM_ADMIN_PASS=zVBSpufGQpg6eN2h
```

## Get an access token from Tokenproxy

The Tokenproxy supports how to get an access token using urlencoderd format or JSON format.
The URL of Tokenproxy is in a `.env` file. The path is `/token`.

```bash
cat .env | grep KEYROCK
```

```bash
KEYROCK=keyrock.example.com
```

### Get an access token using urlencoderd format with curl

#### Request:

```bash
curl https://keyrock.example.com/token \
  --data "username=admin@example.com" \
  --data "password=zVBSpufGQpg6eN2h"
```

#### Response:

```json
{
  "access_token": "3b7c02f9e8a0b8fb1ca0df27052b6dfc00f32df4",
  "token_type": "bearer",
  "expires_in": 3599,
  "refresh_token": "8b23aeabcb97b2b6b09670c8fa4c448a46ab5268",
  "scope": [
    "bearer"
  ]
}
```

### Get an access token using urlencoderd format with Python

```python
import requests
import json

url = 'https://keyrock.example.com/token'
payload = 'username=admin@example.com&password=zVBSpufGQpg6eN2h'
headers = {'Content-Type': 'application/x-www-form-urlencoded'}

res = requests.post(url, data=payload, headers=headers)

if (res.status_code == 200):
  print(res.text)
else:
  print(res.status_code)
```

### Get an access token using JSON format with curl

#### Request:

```bash
curl https://keyrock.example.com/token \
  --header 'Content-Type: application/json' \
  --data '{"username":"admin@example.com", "password": "zVBSpufGQpg6eN2h"}'
```

#### Response:

```json
{
  "access_token": "d3ea43a2bb9784baaa8b9d79756163bc7f36e6d5",
  "token_type": "bearer",
  "expires_in": 3599,
  "refresh_token": "ebc53954a8905f3e33647fdde06369ce1b4c147d",
  "scope": [
    "bearer"
  ]
}
```

### Get an access token using JSON format with Python

```python
import requests
import json

url = 'https://keyrock.example.com/token'
payload = {'username':'admin@example.com', 'password': 'zVBSpufGQpg6eN2h'}
headers = {'Content-Type': 'application/json'}

res = requests.post(url, data=json.dumps(payload), headers=headers)

if (res.status_code == 200):
  print(res.text)
else:
  print(res.status_code)
```

## Get an access token from Keyrock

You can get an access token using resource owner password credentials grant from Keyrock.
In addition to a username and a password, you need a client id and a client secret.
They are in a `.env` file.

```bash
cat .env | grep TOKENPROXY_CLIENT_ID
```

```bash
TOKENPROXY_CLIENT_ID=c33dc1ca-a9a3-4607-8102-11875e3ee3fc
```

```bash
cat .env | grep TOKENPROXY_CLIENT_SECRET
```

```bash
TOKENPROXY_CLIENT_SECRET=697f517e-d351-47de-83bd-b913b0351d6e
```

And the URL of Keyrock is in a `.env` file. The path is `/oauth2/token`.

```bash
cat .env | grep KEYROCK
```

```bash
KEYROCK=keyrock.example.com
```

#### Request:

```bash
curl https://keyrock.example.com/oauth2/token \
  --user c33dc1ca-a9a3-4607-8102-11875e3ee3fc:697f517e-d351-47de-83bd-b913b0351d6e \
  --data "grant_type=password" \
  --data "username=admin@example.com" \
  --data "password=zVBSpufGQpg6eN2h"
```

#### Response:

```json
{
  "access_token": "d3ea43a2bb9784baaa8b9d79756163bc7f36e6d5",
  "token_type": "bearer",
  "expires_in": 3599,
  "refresh_token": "ebc53954a8905f3e33647fdde06369ce1b4c147d",
  "scope": [
    "bearer"
  ]
}
```

## Get an access token with NGSI Go

### Get an access token with NGSI Go

#### Request:

```bash
ngsi token --host orion.example.com
```

#### Response:

```text
73b60e9440a43f503264d4b064f89ea48f55e9f6
```

### Store an access token into environment variable

#### Request:

```bash
export TOKEN=$(ngsi token --host orion.example.com)
```


```bash
echo $TOKEN
```

#### Response:

```text
73b60e9440a43f503264d4b064f89ea48f55e9f6
```

### Get an access token with NGSI Go (verbose)

#### Request:

```bash
ngsi token --host orion.example.com --verbose
```

#### Response:

```json
{
  "access_token": "73b60e9440a43f503264d4b064f89ea48f55e9f6",
  "expires_in": 3599,
  "refresh_token": "68ca9efd955d178ea98e833f4920b904a0646d3d",
  "scope": [
    "bearer"
  ],
  "token_type": "bearer"
}
```
## Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/get-token).

## Related information

-   [Keyrock - FIWARE IDM](https://fiware-idm.readthedocs.io/)
-   [NGSI Go](https://ngsi-go.letsfiware.jp/)


:information_source: **Note:** The value of an access token is invalid as it is a dummy to show an example.
