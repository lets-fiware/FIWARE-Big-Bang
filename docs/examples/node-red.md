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

Open at `https://node-red.example.com` to access the Node-RED GUI.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-sign-in.png)

## Access Node-RED API

Access Node-RED Admin HTTP API with an OAuth2 access token as the Node-RED API endpoint is
protected by Wilma.

### Get an access token.

#### Request:

```bash
ngsi token --host orion.example.com
```

#### Response:

```text
75eaea327a874b7e78be78364493b2e5906996ae
```

### Access Node-RED Admin HTTP API

#### Request:

```bash
curl https://node-red.example.com/settings \
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
  --host orion.example.com \
  entity \
  --data '{"id":"device001"}' \
  --keyValues
```

### Get entity

#### Request:

```bash
ngsi get \
  --host orion.example.com \
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

## Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/node-red).

## Related information

-   [Node-RED - GitHub](https://github.com/node-red/node-red)
-   [Node-RED portal site](https://nodered.org/)
-   [nodered/node-red - Docker Hub](https://hub.docker.com/r/nodered/node-red)
