# After installation

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Installation completion message](#installation-completion-message)
-   [Sanity check procedures](#sanity-check-procedures)
    -   [Get the status of docker containers](#get-the-status-of-docker-containers)
    -   [Get an access token](#get-an-access-token)
    -   [Get Orion version](#get-orion-version)
    -   [Get Keyrock version](#get-keyrock-version)
    -   [Keyrock GUI](#keyrock-gui)
    -   [Sanity check for Cygnus](#sanity-check-for-cygnus)
    -   [Sanity check for Comet](#sanity-check-for-comet)
    -   [Sanity check for Perseo](#sanity-check-for-perseo)
    -   [Get QuantumLeap version](#get-quantumleap-version)
    -   [Sanity check for QuantumLeap](#sanity-check-for-quantumleap)
    -   [Sanity check for Draco](#sanity-check-for-draco)
    -   [Sanity check for IoT Agent for UL](#sanity-check-for-iot-agent-for-ul)
    -   [Sanity check for IoT Agent for JSON](#sanity-check-for-iot-agent-for-json)
    -   [Sanity check for WireCloud](#sanity-check-for-wirecloud)
    -   [Sanity check for Node-RED](#sanity-check-for-node-red)
    -   [Access Node-RED API](#access-node-red-api)
    -   [Sanity check for Grafana](#sanity-check-for-grafana)
    -   [Snaity check for Zeppelin](#sanity-check-for-zeppelin)

</details>

## Installation completion message

After installation, you will get a completion message as shown:

```text
*** Setup has been completed ***
IDM: https://keyrock.example.com
User: admin@example.com
Password: 6efQS9g8Hhffj4zo
docs: https://fi-bb.letsfiware.jp/
Please see the .env file for details.
```

It has a URL, a username and a password for Keyrock.

## Sanity check procedures

You can check if the FIWARE instance is healthy by running some commands.

### Get the status of docker containers

#### Request:

```bash
make ps
```

#### Response:

```text
sudo /usr/local/bin/docker-compose ps
            Name                          Command                   State                                        Ports
-------------------------------------------------------------------------------------------------------------------------------------------------------
fiware-big-bang_keyrock_1      docker-entrypoint.sh npm start   Up (healthy)     3000/tcp
fiware-big-bang_mongo_1        docker-entrypoint.sh --noj ...   Up               27017/tcp
fiware-big-bang_mysql_1        docker-entrypoint.sh mysqld      Up               3306/tcp, 33060/tcp
fiware-big-bang_nginx_1        /docker-entrypoint.sh ngin ...   Up               0.0.0.0:443->443/tcp,:::443->443/tcp, 0.0.0.0:80->80/tcp,:::80->80/tcp
fiware-big-bang_orion_1        sh -c rm /tmp/contextBroke ...   Up               1026/tcp
fiware-big-bang_tokenproxy_1   docker-entrypoint.sh             Up               1029/tcp
fiware-big-bang_wilma_1        docker-entrypoint.sh npm start   Up (unhealthy)   1027/tcp
```

### Get an access token

Run the following command in a directory you ran the lets-fiware.sh script.

#### Request:

```bash
make get-token
```

#### Response:

```text
./config/script/get_token.sh
d56dc45e4285fe25b42fd205da9a2733ca58c697
```

### Get Orion version

You can get the Orion version with NGSI Go.

```bash
ngsi version --host orion.example.com
```

```json
{
"orion" : {
  "version" : "3.7.0",
  "uptime" : "0 d, 0 h, 0 m, 1 s",
  "git_hash" : "8b19705a8ec645ba1452cb97847a5615f0b2d3ca",
  "compile_time" : "Thu May 26 11:45:49 UTC 2022",
  "compiled_by" : "root",
  "compiled_in" : "025d96e1419a",
  "release_date" : "Thu May 26 11:45:49 UTC 2022",
  "machine" : "x86_64",
  "doc" : "https://fiware-orion.rtfd.io/en/3.7.0/",
  "libversions": {
     "boost": "1_74",
     "libcurl": "libcurl/7.74.0 OpenSSL/1.1.1n zlib/1.2.11 brotli/1.0.9 libidn2/2.3.0 libpsl/0.21.0 (+libidn2/2.3.0) libssh2/1.9.0 nghttp2/1.43.0 librtmp/2.3",
     "libmosquitto": "2.0.12",
     "libmicrohttpd": "0.9.70",
     "openssl": "1.1",
     "rapidjson": "1.1.0",
     "mongoc": "1.17.4",
     "bson": "1.17.4"
  }
}
}
```

### Get Keyrock version

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

### Keyrock GUI

To access the Keyrock GUI,  Open at `https://keyrock.example.com` with Web browser.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/keyrock/keyrock-sign-in.png)

### Sanity check for Cygnus

Once Cygnus is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host cygnus.example.com --pretty
```

#### Response:

```json
{
  "success": "true",
  "version": "2.10.0.5bb41dfcca1e25db664850e6b7806e3cf6a2aa7b"
}
```

### Sanity check for Comet

Once Comet is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host comet.example.com
```

#### Response:

```json
{"version":"2.8.0-next"}
```

### Sanity check for Perseo

Once Perseo is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host perseo.example.com --pretty
```

#### Response:

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

### Get QuantumLeap version

Once QuantumLeap is running, you can get the version by the following command:

#### Request:

```bash
ngsi version --host quantumleap.example.com
```

#### Response:

```json
{
  "version": "0.8.1"
}
```

### Sanity check for QuantumLeap

You can check the status by the following command:

#### Request:

```bash
ngsi health --host quantumleap.example.com
```

#### Response:

```json
{
  "status": "pass"
}
```

### Sanity check for Draco

Open at `https://draco.example.com` to access the Draco GUI.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-01.png)

### Sanity check for IoT Agent for UL

Once IoT Agent for UltraLight 2.0 is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host iotagent-ul.example.com --pretty
```

#### Response:

```json
{
  "libVersion": "2.15.1",
  "port": "4041",
  "baseRoot": "/",
  "version": "1.16.2"
}
```

### Sanity check for IoT Agent for JSON

Once IoT Agent for JSON is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host iotagent-json.example.com --pretty
```

#### Response:

```json
{
  "libVersion": "2.17.0",
  "port": "4041",
  "baseRoot": "/",
  "version": "1.19.0"
}
```

### Sanity check for WireCloud 

Open at `https://wirecloud.example.com` to access the WireCloud GUI.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/wirecloud/wirecloud-sign-in.png)

### Sanity check for Node-RED

Open at `https://node-red.example.com` to access the Node-RED GUI.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/node-red/node-red-sign-in.png)

### Access Node-RED API

Access Node-RED Admin HTTP API with an OAuth2 access token as the Node-RED API endpoint is
protected by Wilma.

#### Request:

```bash
ngsi token --host orion.example.com
```

#### Response:

```text
75eaea327a874b7e78be78364493b2e5906996ae
```

And request to the Admin HTTP API with an access token.

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

### Sanity check for Grafana

Open at `https://grafana.example.com` to access the Grafana GUI.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/grafana/grafana-sign-in.png)

## Sanity check for Zeppelin

Once Zeppelin is running, you can access the Zeppelin web application.
Open at `https://zeppelin.example.com` to access the Zeppelin GUI.
You will be redirected to the Keyrock login page.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-01.jpg)

Once you have logged in, you will be redirected to the Zeppelin GUI.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-02.jpg)

### Get Zeppelin version

You can get the Zeppelin version by the following command:

#### Request:

```bash
curl -s https://zeppelin.example.com/api/version
```

#### Response:

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
