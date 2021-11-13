# Node-RED

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Sanity check for Node-RED](#sanity-check-node-red)
-   [Access Node-RED API](#access-node-red-api)
-   [How to use NGSI node](#how-to-use-ngsi-node)
-   [Configration for Context-Broker node](#configration-for-context-broker-node)
-   [Related information](#related-information)

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name                   | Description                      | Default value |
| ------------------------------- | -------------------------------- | ------------- |
| NODE\_RED                       | A sub-domain name of Node-RED    | (empty)       |
| NODE\_RED\_INSTANCE\_NUMBER     | Number of Node-RED instance.     | 1             |
| NODE\_RED\_INSTANCE\_USERNAME   | Username for Node-RED instance.  | node-red      |
| NODE\_RED\_INSTANCE\_HTTP\_ROOT | HTTP root for Node-RED instance. | /node-red     |

## How to setup

### Single-instance

To set up Node-RED, configure an environment variable in config.sh. Set a sub-domain name
for Node-RED to `NODE_RED` as shown:

```bash
NODE_RED=node-red
```

### Multi-instance

To set up multiple Node-RED instances, configure an environment variable in config.sh.
Set a sub-domain name for Node-RED to `NODE_RED` and set number of instances to
`NODE_RED_INSTANCE_NUMBER` as shown:

```bash
NODE_RED=node-red
NODE_RED_INSTANCE_NUMBER=5
```

After installation, the `node-red_users.txt` file has been created in a directory you ran the
`lets-fiware.sh` script. It has URL, username and password to access each Node-Red instance.

```text
https://node-red.example.com/node-red001        node-red001@example.com oS7O0tqhLPPFSflF
https://node-red.example.com/node-red002        node-red002@example.com hs7Nrt8PZLTsJlnS
https://node-red.example.com/node-red003        node-red003@example.com W1XEgeJjsXr0q5UI
https://node-red.example.com/node-red004        node-red004@example.com jdZV5SGXEZbtGjTP
https://node-red.example.com/node-red005        node-red005@example.com XgnFHj63gqxfqyE1
```

## Sanity check for Node-RED

Open at `https://node-red.example.com` to access the Node-RED GUI.

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

### Create flow

![](./images/node-red-001.png)

```
[{"id":"22c1abd2f3953dc4","type":"tab","label":"flow1","disabled":false,"info":""},{"id":"ca443434c8b99c5a","type":"inject","z":"22c1abd2f3953dc4","name":"","props":[{"p":"payload"}],"repeat":"","crontab":"","once":false,"onceDelay":0.1,"topic":"","payload":"device001","payloadType":"str","x":300,"y":180,"wires":[["354b5c13a6eda39a"]]},{"id":"43be416d8e939507","type":"debug","z":"22c1abd2f3953dc4","name":"","active":true,"tosidebar":true,"console":false,"tostatus":false,"complete":"false","statusVal":"","statusType":"auto","x":690,"y":180,"wires":[]},{"id":"354b5c13a6eda39a","type":"NGSI-Entity","z":"22c1abd2f3953dc4","name":"","endpoint":"802c3058092a74ab","protocol":"v2","ldContext":"https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld","mode":"normalized","mimeType":"application/ld+json","attrs":"","x":490,"y":180,"wires":[["43be416d8e939507"]]},{"id":"802c3058092a74ab","type":"Context-Broker","name":"orion","endpoint":"https://orion.example.com","service":"","servicepath":"","idmEndpoint":"https://orion.example.com"}]
```

## Configuration for Context-Broker node

### Connection

-   Endpoint: `https://orion.example.com`

![](./images/node-red-002.png)

### Security

-   IdM Endpoint: `https://orion.example.com`
-   Username: `admin@example.com`
-   Password: `Your password`

![](./images/node-red-003.png)

### Inject payload

![](./images/node-red-004.png)

## Related information

-   [FIWARE/node-red-contrib-FIWARE_official - GitHub](https://github.com/FIWARE/node-red-contrib-FIWARE_official)
-   [Node-RED - GitHub](https://github.com/node-red/node-red)
-   [Node-RED portal site](https://nodered.org/)
