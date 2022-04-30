# Node-RED

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Sanity check for Node-RED](#sanity-check-node-red)
-   [Access Node-RED API](#access-node-red-api)
-   [How to use NGSI node](#how-to-use-ngsi-node)
-   [Configration for Context-Broker node](#configration-for-context-broker-node)
-   [Examples](#examples)
-   [Related information](#related-information)

</details>

## Sanity check for Node-RED

Open at `https://node-red.big-bang.letsfiware.jp` to access the Node-RED GUI.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-sign-in.png)

## Access Node-RED API

Access Node-RED Admin HTTP API with an OAuth2 access token as the Node-RED API endpoint is
protected by Wilma.

### Get an access token.

#### Request:

```bash
ngsi token --host orion.big-bang.letsfiware.jp
```

#### Response:

```text
75eaea327a874b7e78be78364493b2e5906996ae
```

### Access Node-RED Admin HTTP API

#### Request:

```bash
curl https://node-red.big-bang.letsfiware.jp/settings \
  --header 'Authorization: Bearer 75eaea327a874b7e78be78364493b2e5906996ae'
```

#### Response:

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

## How to use NGSI node

### Create entity

#### Request:

```
ngsi create \
  --host orion.big-bang.letsfiware.jp \
  entity \
  --data '{"id":"device001"}' \
  --keyValues
```

### Get entity

#### Request:

```bash
ngsi get \
  --host orion.big-bang.letsfiware.jp \
  entity \
  --id device001 \
  --pretty
```

#### Response:

```json
{
  "id": "device001",
  "type": "Thing"
}
```

## Create flow

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-001.png)

```
[{"id":"f5717ef56f6b92ee","type":"tab","label":"Flow 1","disabled":false,"info":"","env":[]},{"id":"d64a75632b691651","type":"NGSI Entity","z":"f5717ef56f6b92ee","openapis":"c574ed7e49fe8012","servicepath":"/","mode":"normalized","entitytype":"","attrs":"","x":410,"y":100,"wires":[["1600fecad297713b"]]},{"id":"ac8c9b2cb6a23119","type":"inject","z":"f5717ef56f6b92ee","name":"","props":[{"p":"payload"}],"repeat":"","crontab":"","once":false,"onceDelay":0.1,"topic":"","payload":"device001","payloadType":"str","x":240,"y":100,"wires":[["d64a75632b691651"]]},{"id":"1600fecad297713b","type":"debug","z":"f5717ef56f6b92ee","name":"","active":true,"tosidebar":true,"console":false,"tostatus":false,"complete":"false","statusVal":"","statusType":"auto","x":590,"y":100,"wires":[]},{"id":"c574ed7e49fe8012","type":"Open APIs","name":"","brokerEndpoint":"https://orion.big-bang.letsfiware.jp","service":"","idmEndpoint":"https://orion.big-bang.letsfiware.jp","idmType":"tokenproxy"}]
```

## Configuration for nodes

### Configuration for NGSI Entity node

Add new Open APIs endpoint.

-   Context Broker: Open APIs endpoint

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-002.png)

### Configuration for Context-Broker node

Set up an broker endpoint and security configuration.

-   Broker Endpoint: `https://orion.big-bang.letsfiware.jp`
-   IdM Type: `Tokenproxy`
-   IdM Endpoint: `https://orion.big-bang.letsfiware.jp`
-   Username: `admin@big-bang.letsfiware.jp`
-   Password: `Your password`

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-003.png)

## Inject payload

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-004.png)

## Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/node-red).

## Related information

-   [lets-fiware / node-red-contrib-letsfiware-NGSI - GitHub](https://github.com/lets-fiware/node-red-contrib-letsfiware-NGSI)
-   [node-red-contrib-letsfiware-NGSI documentation](https://node-red-contrib-letsfiware-ngsi.letsfiware.jp/)
-   [Node-RED - GitHub](https://github.com/node-red/node-red)
-   [Node-RED portal site](https://nodered.org/)
-   [nodered/node-red - Docker Hub](https://hub.docker.com/r/nodered/node-red)
