# インストール後の確認

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [インストール完了メッセージ](#installation-completion-message)
-   [健全性チェック手順](#sanity-check-procedures)
    -   [Docker コンテナのステータスを取得](#get-the-status-of-docker-containers)
    -   [アクセス・トークンを取得](#get-an-access-token)
    -   [Orion のバージョンを取得](#get-orion-version)
    -   [Keyrock のバージョンを取得](#get-keyrock-version)
    -   [Keyrock GUI](#keyrock-gui)
    -   [Cygnus の健全性チェック](#sanity-check-for-cygnus)
    -   [Comet の健全性チェック](#sanity-check-for-comet)
    -   [Perseo の健全性チェック](#sanity-check-for-perseo)
    -   [QuantumLeap のバージョンを取得](#get-quantumleap-version)
    -   [QuantumLeap の健全性チェック](#sanity-check-for-quantumleap)
    -   [Draco の健全性チェック](#sanity-check-for-draco)
    -   [IoT Agent for UL の健全性チェック](#sanity-check-for-iot-agent-for-ul)
    -   [IoT Agent for JSON の健全性チェック](#sanity-check-for-iot-agent-for-json)
    -   [WireCloud の健全性チェック](#sanity-check-for-wirecloud)
    -   [Node-RED の健全性チェック](#sanity-check-for-node-red)
    -   [Node-RED API へアクセス](#access-node-red-api)
    -   [Grafana の健全性チェック](#sanity-check-for-grafana)
    -   [Zeppelin の健全性チェック](#sanity-check-for-zeppelin)
    -   [Zeppelin のバージョンを取得](#get-zeppelin-version)

</details>

<a name="installation-completion-message"></a>

## インストール完了メッセージ

インストール後、次のような完了メッセージが表示されます。

```text
*** Setup has been completed ***
IDM: https://keyrock.example.com
User: admin@example.com
Password: 6efQS9g8Hhffj4zo
docs: https://fi-bb.letsfiware.jp/
Please see the .env file for details.
```

Keyrock の URL、ユーザー名、およびパスワードが含まれています。

<a name="sanity-check-procedures"></a>

## 健全性チェック手順

いくつかのコマンドを実行して、FIWARE インスタンスが正常かどうかを確認できます。

<a name="get-the-status-of-docker-containers"></a>

### Docker コンテナのステータスを取得

#### リクエスト:

```bash
make ps
```

#### レスポンス:

```text
sudo docker compose ps
NAME                           COMMAND                  SERVICE             STATUS                PORTS
fiware-big-bang_keyrock_1      "docker-entrypoint.s…"   keyrock             running (healthy)     3000/tcp
fiware-big-bang_mongo_1        "docker-entrypoint.s…"   mongo               running               27017/tcp
fiware-big-bang_mysql_1        "docker-entrypoint.s…"   mysql               running               33060/tcp
fiware-big-bang_nginx_1        "/docker-entrypoint.…"   nginx               running               0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, :::80->80/tcp, :::443->443/tcp
fiware-big-bang_orion_1        "sh -c 'rm /tmp/cont…"   orion               running               1026/tcp
fiware-big-bang_tokenproxy_1   "docker-entrypoint.sh"   tokenproxy          running               1029/tcp
fiware-big-bang_wilma_1        "docker-entrypoint.s…"   wilma               running (unhealthy)   1027/tcp
```

<a name="get-an-access-token"></a>

### アクセス・トークンを取得

lets-fiware.sh スクリプトを実行したディレクトリで次のコマンドを実行します。

#### リクエスト:

```bash
make get-token
```

#### レスポンス:

```text
./config/script/get_token.sh
d56dc45e4285fe25b42fd205da9a2733ca58c697
```

<a name="get-orion-version"></a>

### Orion のバージョンを取得 

Orion のバージョンは NGSI Go で取得できます。

```bash
ngsi version --host orion.example.com
```

```json
{
"orion" : {
  "version" : "4.0.0",
  "uptime" : "0 d, 0 h, 0 m, 1 s",
  "git_hash" : "4f9f34df07395c54387a53074f98bef00b1130a3",
  "compile_time" : "Thu Jun 6 07:35:47 UTC 2024",
  "compiled_by" : "root",
  "compiled_in" : "buildkitsandbox",
  "release_date" : "Thu Jun 6 07:35:47 UTC 2024",
  "machine" : "x86_64",
  "doc" : "https://fiware-orion.rtfd.io/en/4.0.0/"
}
}
```

<a name="get-keyrock-version"></a>

### Keyrock のバージョンを取得

Keyrock が起動したら、次のコマンドでステータスを取得できます。

#### リクエスト:

```bash
curl https://keyrock.example.com/version
```

#### レスポンス:

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

<a name="keyrock-gui"></a>

### Keyrock GUI

Keyrock の GUI にアクセスするには、Web ブラウザで `https://keyrock.example.com` を開きます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/keyrock/keyrock-sign-in.png)

<a name="sanity-check-for-cygnus"></a>

### Cygnus の健全性チェック

Cygnus が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host cygnus.example.com --pretty
```

#### レスポンス:

```json
{
  "success": "true",
  "version": "2.10.0.5bb41dfcca1e25db664850e6b7806e3cf6a2aa7b"
}
```

<a name="sanity-check-for-comet"></a>

### Comet の健全性チェック

Comet が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host comet.example.com
```

#### レスポンス:

```json
{"version":"2.8.0-next"}
```

<a name="sanity-check-for-perseo"></a>

### Perseo の健全性チェック

Perseo が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host perseo.example.com --pretty
```

#### レスポンス:

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

<a name="get-quantumleap-version"></a>

### QuantumLeap のバージョンを取得

QuantumLeap が起動したら、次のコマンドでバージョンを取得できます:

#### リクエスト:

```bash
ngsi version --host quantumleap.example.com
```

#### レスポンス:

```json
{
  "version": "0.8.1"
}
```

<a name="sanity-check-for-quantumleap"></a>

### QuantumLeap の健全性チェック

次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi health --host quantumleap.example.com
```

#### レスポンス:

```json
{
  "status": "pass"
}
```

<a name="sanity-check-for-draco"></a>

### Draco の健全性チェック

Draco の GUI にアクセスするには、Web ブラウザで、`https://draco.example.com` を開きます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-01.png)

<a name="sanity-check-for-iot-agent-for-ul"></a>

### IoT Agent for UL の健全性チェック

IoT Agent for UltraLight 2.0 が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host iotagent-ul.example.com --pretty
```

#### レスポンス:

```json
{
  "libVersion": "2.15.1",
  "port": "4041",
  "baseRoot": "/",
  "version": "1.16.2"
}
```

<a name="sanity-check-for-iot-agent-for-json"></a>

### IoT Agent for JSON の健全性チェック

IoT Agent for JSON が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host iotagent-json.example.com --pretty
```

#### レスポンス:

```json
{
  "libVersion": "2.17.0",
  "port": "4041",
  "baseRoot": "/",
  "version": "1.19.0"
}
```

<a name="sanity-check-for-wirecloud"></a>

### WireCloud の健全性チェック

WireCloud の GUI にアクセスするには、Web ブラウザで、`https://wirecloud.example.com` を開きます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/wirecloud/wirecloud-sign-in.png)

<a name="sanity-check-for-node-red"></a>

### Node-RED の健全性チェック

Node-RED の GUI にアクセスするには、Web ブラウザで、`https://node-red.example.com` を開きます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-sign-in.png)

<a name="access-node-red-api"></a>

### Node-RED API へアクセス

Node-RED API エンドポイントは Wilma によって保護されているため、OAuth2 アクセス・トークンを使用して Node-RED Admin
HTTP API にアクセスします。

#### リクエスト:

```bash
ngsi token --host orion.example.com
```

#### レスポンス:

```text
75eaea327a874b7e78be78364493b2e5906996ae
```

そして、アクセス・トークンを使用して Admin HTTP API にリクエストします。

#### リクエスト:

```bash
curl https://node-red.example.com/settings \
  --header 'Authorization: Bearer 75eaea327a874b7e78be78364493b2e5906996ae'
```

#### レスポンス:

```json
{
  "httpNodeRoot": "/",
  "version": "2.0.6",
  "user": {
    "username": "admin",
    "permissions": "*"
  },
  "context": {
    "default": "memory",
    "stores": [
      "memory"
    ]
  },
  "libraries": [
    {
      "id": "local",
      "label": "editor:library.types.local",
      "user": false,
      "icon": "font-awesome/fa-hdd-o"
    },
    {
      "id": "examples",
      "label": "editor:library.types.examples",
      "user": false,
      "icon": "font-awesome/fa-life-ring",
      "types": [
        "flows"
      ],
      "readOnly": true
    }
  ],
  "flowFilePretty": true,
  "externalModules": {},
  "flowEncryptionType": "system",
  "functionExternalModules": false,
  "tlsConfigDisableLocalFiles": false,
  "editorTheme": {
    "projects": {
      "enabled": false,
      "workflow": {
        "mode": "manual"
      }
    },
    "languages": [
      "de",
      "en-US",
      "ja",
      "ko",
      "ru",
      "zh-CN",
      "zh-TW"
    ]
  }
}
```

<a name="sanity-check-for-grafana"></a>

### Grafana の健全性チェック

Grafana GUI にアクセスするには、Web ブラウザで、`https://grafana.example.com` を開きます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/grafana/grafana-sign-in.png)

<a name="sanity-check-for-zeppelin"></a>

### Sanity check for Zeppelin

Zeppelin が起動すると、Zeppelin Web アプリケーションにアクセスできます。Web ブラウザで、`https://zeppelin.example.com` を
開いて、Zeppelin の GUI にアクセスします。次に、Keyrock のログイン・ページにリダイレクトされます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-01.jpg)

Keyrock にログインすると、Zeppelin の GUI にリダイレクトされます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-02.jpg)

<a name="get-zeppelin-version"></a>

### Zeppelin のバージョンを取得

Zeppelin のバージョンは、次のコマンドで取得できます:

#### リクエスト:

```bash
curl -s https://zeppelin.example.com/api/version
```

#### レスポンス:

```json
{
  "status": "OK",
  "message": "Zeppelin version",
  "body": {
    "git-commit-id": "",
    "git-timestamp": "",
    "version": "0.9.0"
  }
}
```
