# Node-RED

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [Node-RED の健全性チェック](#sanity-check-node-red)
-   [Node-RED API へのアクセス](#access-node-red-api)
-   [NGSI node の使用方法](#how-to-use-ngsi-node)
-   [Context-Broker node の構成](#configration-for-context-broker-node)
-   [例](#examples)
-   [関連情報](#related-information)

</details>

<a name="sanity-check-node-red"></a>

## Node-RED の健全性チェック

Web ブラウザで、`https://node-red.big-bang.letsfiware.jp` を開いて、 Node-RED GUI にアクセスします。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-sign-in.png)

<a name="access-node-red-api"></a>

## Node-RED API へのアクセス

Node-RED API エンドポイントは Wilma によって保護されているため、OAuth2 アクセス・トークンを使用して、
Node-RED Admin HTTP API にアクセスします。

### アクセス・トークンを取得

#### リクエスト:

```bash
ngsi token --host orion.big-bang.letsfiware.jp
```

#### レスポンス:

```text
75eaea327a874b7e78be78364493b2e5906996ae
```

### Node-RED Admin HTTP API へのアクセス

#### リクエスト:

```bash
curl https://node-red.big-bang.letsfiware.jp/settings \
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

<a name="how-to-use-ngsi-node"></a>

## NGSI node の使用方法

### エンティティを作成

#### リクエスト:

```
ngsi create \
  --host orion.big-bang.letsfiware.jp \
  entity \
  --data '{"id":"device001"}' \
  --keyValues
```

### エンティティを取得

#### リクエスト:

```bash
ngsi get \
  --host orion.big-bang.letsfiware.jp \
  entity \
  --id device001 \
  --pretty
```

#### レスポンス:

```json
{
  "id": "device001",
  "type": "Thing"
}
```

## フローを作成

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-001.png)

```
[{"id":"f5717ef56f6b92ee","type":"tab","label":"Flow 1","disabled":false,"info":"","env":[]},{"id":"d64a75632b691651","type":"NGSI Entity","z":"f5717ef56f6b92ee","openapis":"c574ed7e49fe8012","servicepath":"/","mode":"normalized","entitytype":"","attrs":"","x":410,"y":100,"wires":[["1600fecad297713b"]]},{"id":"ac8c9b2cb6a23119","type":"inject","z":"f5717ef56f6b92ee","name":"","props":[{"p":"payload"}],"repeat":"","crontab":"","once":false,"onceDelay":0.1,"topic":"","payload":"device001","payloadType":"str","x":240,"y":100,"wires":[["d64a75632b691651"]]},{"id":"1600fecad297713b","type":"debug","z":"f5717ef56f6b92ee","name":"","active":true,"tosidebar":true,"console":false,"tostatus":false,"complete":"false","statusVal":"","statusType":"auto","x":590,"y":100,"wires":[]},{"id":"c574ed7e49fe8012","type":"Open APIs","name":"","brokerEndpoint":"https://orion.big-bang.letsfiware.jp","service":"","idmEndpoint":"https://orion.big-bang.letsfiware.jp","idmType":"tokenproxy"}]
```

## ノードの構成

### NGSI Entity node の構成

新しい Open API エンドポイントを追加します。

-   Open APIs endpoint の構成

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-002.png)

### Context-Broker node の構成

ブローカー・エンドポイントとセキュリティ構成をセットアップします。

-   Broker Endpoint: `https://orion.big-bang.letsfiware.jp`
-   IdM Type: `Tokenproxy`
-   IdM Endpoint: `https://orion.big-bang.letsfiware.jp`
-   Username: `admin@big-bang.letsfiware.jp`
-   Password: `Your password`

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-003.png)

### ペイロードを挿入

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-004.png)

<a name="examples"></a>

## 例

[こちら](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/node-red)の例を参照ください。

<a name="related-information"></a>

## 関連情報

-   [lets-fiware / node-red-contrib-letsfiware-NGSI - GitHub](https://github.com/lets-fiware/node-red-contrib-letsfiware-NGSI)
-   [node-red-contrib-letsfiware-NGSI documentation](https://node-red-contrib-letsfiware-ngsi.letsfiware.jp/)
-   [Node-RED - GitHub](https://github.com/node-red/node-red)
-   [Node-RED portal site](https://nodered.org/)
-   [nodered/node-red - Docker Hub](https://hub.docker.com/r/nodered/node-red)
