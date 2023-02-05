# アクセス・トークンの取得方法

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [前提条件](#prerequisite)
-   [Tokenproxy からアクセス・トークンを取得](#get-an-access-token-from-tokenproxy)
-   [Get Keyrock からアクセス・トークンを取得](#get-an-access-token-from-keyrock)
-   [NGSI Go でアクセス・トークンを取得](#get-an-access-token-with-ngsi-go)
-   [例](#examples)
-   [関連情報](#related-information)

</details>

<a name="prerequisite"></a>

## 前提条件

アクセス・トークンを取得するには、ユーザ名とパスワードが必要です。これらは、
lets-fiware.sh を実行したディレクトリにある `.env` ファイルにあります。

`IDM_ADMIN_EMAIL` 変数にはユーザ名が設定されています。

```bash
cat .env | grep IDM_ADMIN_EMAIL
```

```bash
IDM_ADMIN_EMAIL=admin@example.com
```

`IDM_ADMIN_PASS` 変数にはパスワードが設定されています。

```bash
cat .env | grep IDM_ADMIN_PASS
```

```bash
IDM_ADMIN_PASS=zVBSpufGQpg6eN2h
```

<a name="get-an-access-token-from-tokenproxy"></a>

## Tokenproxy からアクセス・トークンを取得

Tokenproxy は、urlencoderd 形式または JSON 形式を使用してアクセス・トークンを取得する方法を
サポートしています。Tokenproxy の URL は.envファイルにあります。パスは `/token` です。

```bash
cat .env | grep KEYROCK
```

```bash
KEYROCK=keyrock.example.com
```

### curl で urlencoderd 形式を使用してアクセス・トークンを取得

#### リクエスト:

```bash
curl https://keyrock.example.com/token \
  --data "username=admin@example.com" \
  --data "password=zVBSpufGQpg6eN2h"
```

#### レスポンス:

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

### Python で urlencoderd 形式を使用してアクセス・トークンを取得

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

### curl で JSON 形式を使用してアクセス・トークンを取得

#### リクエスト:

```bash
curl https://keyrock.example.com/token \
  --header 'Content-Type: application/json' \
  --data '{"username":"admin@example.com", "password": "zVBSpufGQpg6eN2h"}'
```

#### レスポンス:

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

### Python で JSON 形式を使用してアクセス・トークンを取得

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

<a name="get-an-access-token-from-tokenproxy"></a>

## Get Keyrock からアクセス・トークンを取得

Keyrock から resource owner password credentials grant を使用して、アクセス・トークンを
取得できます。ユーザ名とパスワードに加えて、client id と client secretが必要です。これらは、
`.env` ファイルにあります。

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

Keyrock の URL は `.env` ファイルに含まれています。パスは `/oauth2/token` です。

```bash
cat .env | grep KEYROCK
```

```bash
KEYROCK=keyrock.example.com
```

#### リクエスト:

```bash
curl https://keyrock.example.com/oauth2/token \
  --user c33dc1ca-a9a3-4607-8102-11875e3ee3fc:697f517e-d351-47de-83bd-b913b0351d6e \
  --data "grant_type=password" \
  --data "username=admin@example.com" \
  --data "password=zVBSpufGQpg6eN2h"
```

#### レスポンス:

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

<a name="get-an-access-token-with-ngsi-go"></a>

## NGSI Go でアクセス・トークンを取得

### NGSI Go でアクセス・トークンを取得

#### リクエスト:

```bash
ngsi token --host orion.example.com
```

#### レスポンス:

```text
73b60e9440a43f503264d4b064f89ea48f55e9f6
```

### アクセス・トークンを環境変数に格納

#### リクエスト:

```bash
export TOKEN=$(ngsi token --host orion.example.com)
```


```bash
echo $TOKEN
```

#### レスポンス:

```text
73b60e9440a43f503264d4b064f89ea48f55e9f6
```

### NGSI Go でアクセス・トークンを取得 (詳細)

#### リクエスト:

```bash
ngsi token --host orion.example.com --verbose
```

#### レスポンス:

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

<a name="examples"></a>

## 例

[こちら](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/get-token) に
例があります。

<a name="related-information"></a>

## 関連情報

-   [Keyrock - FIWARE IDM](https://fiware-idm.readthedocs.io/)
-   [NGSI Go](https://ngsi-go.letsfiware.jp/)


:information_source: **注意:** アクセス・トークンの値は、例を示すためのダミーのため、無効です。
