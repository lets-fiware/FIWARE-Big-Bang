# IoT Agent for JSON

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [IoT Agent for JSON の健全性チェック](#sanity-check-for-iot-agent-for-json)
-   [IoT Agent for JSON over MQTT](#iot-agent-for-json-over-mqtt)
    -   [サービスの作成](#create-service)
    -   [サービスの一覧表示](#list-services)
    -   [デバイスの作成](#create-device)
    -   [デバイスの一覧表示](#list-devices)
    -   [データの送信](#send-data)
    -   [エンティティの表示](#get-entity)
    -   [例](#examples)
-   [IoT Agent for JSON over HTTP](#iot-agent-for-json-over-http)
    -   [サービスの作成](#create-service-1)
    -   [サービスの一覧表示](#list-services-1)
    -   [デバイスの作成](#create-device-1)
    -   [デバイスの一覧表示](#list-devices-1)
    -   [データの送信](#send-data-1)
    -   [エンティティの表示](#get-entity-1)
    -   [例](#examples-1)
-   [関連情報](#related-information)

</details>

<a name="sanity-check-for-iot-agent-for-json"></a>

## IoT Agent for JSON の健全性チェック

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

<a name="iot-agent-for-json-over-mqtt"></a>

## IoT Agent for JSON over MQTT

<a name="create-service"></a>

### サービスの作成

#### リクエスト:

```bash
ngsi services \
  --host iotagent-json.example.com \
  create \
  --apikey  SMoCnNjlrAfeFOtlaC8XAhM8o1 \
  --type Thing \
  --resource /iot/json \
   --cbroker http://orion:1026
```

<a name="list-services"></a>

### サービスの一覧表示 

#### リクエスト:

```bash
ngsi services \
  --host iotagent-json.example.com \
  list \
  --pretty
```

#### レスポンス:

```json
{
  "count": 1,
  "services": [
    {
      "commands": [],
      "lazy": [],
      "attributes": [],
      "_id": "618e271d12b5ce10113cb4b8",
      "resource": "/iot/json",
      "apikey": "SMoCnNjlrAfeFOtlaC8XAhM8o1",
      "service": "openiot",
      "subservice": "/",
      "__v": 0,
      "static_attributes": [],
      "internal_attributes": [],
      "entity_type": "Thing"
    }
  ]
}
```

<a name="create-device"></a>

### デバイスの作成

#### リクエスト:

```bash
ngsi devices \
  --host iotagent-json.example.com \
  create \
  --data '{ \
  "devices": [
    {
      "device_id":   "sensor002",
      "apikey":      "SMoCnNjlrAfeFOtlaC8XAhM8o1",
      "entity_name": "urn:ngsi-ld:WeatherObserved:sensor002",
      "entity_type": "Sensor",
      "timezone":    "Asia/Tokyo",
      "transport":   "MQTT",
      "attributes": [
        { "object_id": "d", "name": "dateObserved", "type": "DateTime" },
        { "object_id": "t", "name": "temperature", "type": "Number" },
        { "object_id": "h", "name": "relativeHumidity", "type": "Number" },
        { "object_id": "p", "name": "atmosphericPressure", "type": "Number" }
      ],
      "static_attributes": [
        { "name":"location", "type": "geo:json", "value" : { "type": "Point", "coordinates" : [ 139.7671, 35.68117 ] } }
      ]
    }
  ]
}'
```

<a name="list-devices"></a>

### デバイスの一覧表示

#### リクエスト:

```bash
ngsi devices \
  --host iotagent-json.example.com \
  list \
  --pretty
```

#### レスポンス:

```json
{
  "count": 1,
  "devices": [
    {
      "device_id": "sensor002",
      "service": "openiot",
      "service_path": "/",
      "entity_name": "urn:ngsi-ld:WeatherObserved:sensor002",
      "entity_type": "Sensor",
      "transport": "MQTT",
      "attributes": [
        {
          "object_id": "d",
          "name": "dateObserved",
          "type": "DateTime"
        },
        {
          "object_id": "t",
          "name": "temperature",
          "type": "Number"
        },
        {
          "object_id": "h",
          "name": "relativeHumidity",
          "type": "Number"
        },
        {
          "object_id": "p",
          "name": "atmosphericPressure",
          "type": "Number"
        }
      ],
      "lazy": [],
      "commands": [],
      "static_attributes": [
        {
          "name": "location",
          "type": "geo:json",
          "value": {
            "type": "Point",
            "coordinates": [
              139.7671,
              35.68117
            ]
          }
        }
      ],
      "explicitAttrs": false
    }
  ]
}
```

<a name="send-data"></a>

### データの送信

#### リクエスト:

```bash
mosquitto_pub \
  --debug \
  --host mosquitto.example.com
  --port 8883 \
  --username fiware --pw cDQB6DsIy5TFSdjy \
  --topic "/SMoCnNjlrAfeFOtlaC8XAhM8o1/sensor002/attrs" \
  --message '{"d":"2021-11-12T08:37:44+0000","t":9327,"h":3064,"p":27652}' \
  --cafile ./config/mosquitto/isrgrootx1.pem
```

<a name="get-entity"></a>

### エンティティの表示

#### リクエスト:

```bash
ngsi get \
  --host orion.example.com \
  --service openiot \
  --path / \
  entity \
  --id urn:ngsi-ld:WeatherObserved:sensor00 \
  --pretty
```

#### レスポンス:

```json
{
  "id": "urn:ngsi-ld:WeatherObserved:sensor002",
  "type": "Sensor",
  "TimeInstant": {
    "type": "DateTime",
    "value": "2021-11-12T08:37:44.668Z",
    "metadata": {}
  },
  "atmosphericPressure": {
    "type": "Number",
    "value": 27652,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-12T08:37:44.668Z"
      }
    }
  },
  "dateObserved": {
    "type": "DateTime",
    "value": "2021-11-12T08:37:44.000Z",
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-12T08:37:44.668Z"
      }
    }
  },
  "location": {
    "type": "geo:json",
    "value": {
      "type": "Point",
      "coordinates": [
        139.7671,
        35.68117
      ]
    },
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-12T08:37:44.668Z"
      }
    }
  },
  "relativeHumidity": {
    "type": "Number",
    "value": 3064,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-12T08:37:44.668Z"
      }
    }
  },
  "temperature": {
    "type": "Number",
    "value": 9327,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-12T08:37:44.668Z"
      }
    }
  }
}
```

<a name="examples"></a>

### 例

[こちら](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/iotagent-json-mqtt)の例を参照ください。

<a name="iot-agent-for-json-over-http-1"></a>

## IoT Agent for JSON over HTTP

<a name="create-service-1"></a>

### サービスの作成

#### リクエスト:

```bash
ngsi services \
  --host iotagent-json.example.com \
  create \
  --apikey XaEMQ86tTBHCwN0C9MjiHXcYFX \
  --type Thing \
  --resource /iot/json \
  --cbroker http://orion:1026
```

<a name="list-services-1"></a>

### サービスの一覧表示

#### リクエスト:

```bash
ngsi services \
  --host iotagent-json.example.com \
  list \
  --pretty
```

#### レスポンス:

```json
{
  "count": 1,
  "services": [
    {
      "commands": [],
      "lazy": [],
      "attributes": [],
      "_id": "618e296133b2b1c5e3ddfa89",
      "resource": "/iot/json",
      "apikey": "XaEMQ86tTBHCwN0C9MjiHXcYFX",
      "service": "openiot",
      "subservice": "/",
      "__v": 0,
      "static_attributes": [],
      "internal_attributes": [],
      "entity_type": "Thing"
    }
  ]
}
```

<a name="create-device-1"></a>

### デバイスの作成

#### リクエスト:

```bash
ngsi devices \
  --host iotagent-json.example.com \
  create \
  --data '{
  "devices": [
    {
      "device_id":   "sensor004",
      "apikey":      "XaEMQ86tTBHCwN0C9MjiHXcYFX",
      "entity_name": "urn:ngsi-ld:WeatherObserved:sensor004",
      "entity_type": "Sensor",
      "timezone":    "Asia/Tokyo",
      "attributes": [
        { "object_id": "d", "name": "dateObserved", "type": "DateTime" },
        { "object_id": "t", "name": "temperature", "type": "Number" },
        { "object_id": "h", "name": "relativeHumidity", "type": "Number" },
        { "object_id": "p", "name": "atmosphericPressure", "type": "Number" }
      ],
      "static_attributes": [
        { "name":"location", "type": "geo:json", "value" : { "type": "Point", "coordinates" : [ 139.7671, 35.68117 ] } }
      ]
    }
  ]
}'
```

<a name="list-devices-1"></a>

### デバイスの一覧表示

#### リクエスト:

```bash
ngsi devices \
  --host iotagent-json.example.com \
  list \
  --pretty
```

#### レスポンス:

```json
{
  "count": 1,
  "devices": [
    {
      "device_id": "sensor004",
      "service": "openiot",
      "service_path": "/",
      "entity_name": "urn:ngsi-ld:WeatherObserved:sensor004",
      "entity_type": "Sensor",
      "transport": "HTTP",
      "attributes": [
        {
          "object_id": "d",
          "name": "dateObserved",
          "type": "DateTime"
        },
        {
          "object_id": "t",
          "name": "temperature",
          "type": "Number"
        },
        {
          "object_id": "h",
          "name": "relativeHumidity",
          "type": "Number"
        },
        {
          "object_id": "p",
          "name": "atmosphericPressure",
          "type": "Number"
        }
      ],
      "lazy": [],
      "commands": [],
      "static_attributes": [
        {
          "name": "location",
          "type": "geo:json",
          "value": {
            "type": "Point",
            "coordinates": [
              139.7671,
              35.68117
            ]
          }
        }
      ],
      "explicitAttrs": false
    }
  ]
}
```

<a name="send-data-1"></a>

### データの送信

#### リクエスト:

```bash
 curl -X POST "https://iotagent-http.example.com/iot/ul?k=XaEMQ86tTBHCwN0C9MjiHXcYFX&i=sensor004" \
   -u "fiware:1HAmMeajDpPSuTaF" \
   -H "Content-Type: text/plain" \
   -d '{"d":"2021-11-12T08:48:06+0000","t":16207,"h":2061,"p":11022}'
```

<a name="get-entity"></a>

### エンティティの表示

#### リクエスト:

```bash
ngsi get \
  --host orion.example.com \
  --service openiot \
  --path / \
  entity \
  --id urn:ngsi-ld:WeatherObserved:sensor004 \
  --pretty
```

#### レスポンス:

```json
{
  "id": "urn:ngsi-ld:WeatherObserved:sensor004",
  "type": "Sensor",
  "TimeInstant": {
    "type": "DateTime",
    "value": "2021-11-12T08:48:06.476Z",
    "metadata": {}
  },
  "atmosphericPressure": {
    "type": "Number",
    "value": 11022,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-12T08:48:06.476Z"
      }
    }
  },
  "dateObserved": {
    "type": "DateTime",
    "value": "2021-11-12T08:48:06.000Z",
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-12T08:48:06.476Z"
      }
    }
  },
  "location": {
    "type": "geo:json",
    "value": {
      "type": "Point",
      "coordinates": [
        139.7671,
        35.68117
      ]
    },
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-12T08:48:06.476Z"
      }
    }
  },
  "relativeHumidity": {
    "type": "Number",
    "value": 2061,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-12T08:48:06.476Z"
      }
    }
  },
  "temperature": {
    "type": "Number",
    "value": 16207,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-12T08:48:06.476Z"
      }
    }
  }
}
```

<a name="examples-1"></a>

### 例

[こちら](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/iotagent-json-http)の例を参照ください。

<a name="related-information"></a>

## 関連情報

-   [iotagent-json - GitHub](https://github.com/telefonicaid/iotagent-json)
-   [iotagnet-node-lib - GitHub](https://github.com/telefonicaid/iotagent-node-lib)
-   [iotagent-json - Read the docs](https://fiware-iotagent-json.readthedocs.io/en/latest/)
-   [iotagent-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent configuration API - Apiary](https://telefonicaiotiotagents.docs.apiary.io/#reference/configuration-api)
-   [iotagnet-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent for JSON - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-agent-json.html)
-   [IoT Agent over MQTT - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt.html)
-   [NGSI Go tutorial for IoT Agent](https://ngsi-go.letsfiware.jp/tutorial/iot-agent/)
-   [orchestracities/quantumleap - Docker Hub](https://hub.docker.com/r/orchestracities/quantumleap)
