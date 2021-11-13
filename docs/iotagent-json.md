# IoT Agent for JSON

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Sanity check for IoT Agent for JSON](#sanity-check-for-iot-agent-for-json)
-   [IoT Agent for JSON over MQTT](#iot-agent-for-json-over-mqtt-1)
    -   [Create service](#create-service)
    -   [List services](#list-services)
    -   [Create device](#create-device)
    -   [List devices](#list-devices)
    -   [Send data](#send-data)
    -   [List entities](#list-entities)
    -   [Examples](#examples)
-   [IoT Agent for JSON over HTTP](#iot-agent-for-json-over-http-1)
    -   [Create service](#create-service-1)
    -   [List services](#list-services-1)
    -   [Create device](#create-device-1)
    -   [List devices](#list-devices-1)
    -   [Send data](#send-data-1)
    -   [Get entity](#get-entity)
    -   [Examples](#examples-1)
-   [Related information](#related-information)


## Configuration parameters

You can specify configurations for IoT Agent for JSON by editing the `config.sh` file.

| Variable name                 | Description                                                                                                   | Default value             |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------- |
| IOTAGENT\_JSON                | A sub-domain name of IoT Agent for JSON                                                                       | (empty)                   |
| MOSQUITTO                     | A sub-domain name of Mosquitto                                                                                | (empty)                   |
| MQTT\_1883                    | Use MQTT Port 1883. true or false                                                                             | false                     |
| MQTT\_TLS                     | Use MQTT TLS (Port 8883). true or false                                                                       | true                      |
| IOTAGENT\_HTTP                | Set a sub-domain name to use IoT Agent over HTTP.                                                             | (empty)                   |
| IOTA\_HTTP\_AUTH              | Authorization for IoT Agent over HTTP. (none, basic or bearer)                                                | bearer                    |
| IOTA\_HTTP\_BASIC\_USER       | User for Basic authorization for IoT Agent over HTTP.                                                         | fiware                    |
| IOTA\_HTTP\_BASIC\_PASS       | Password for Basic authorization for IoT Agent over HTTP.                                                     | (Automatically generated) |
| IOTA\_JSON\_DEFAULT\_RESOURCE | The default path the IoT Agent uses listening for UltraLight measures.                                        | /iot/ul                   |
| IOTA\_JSON\_TIMESTAMP         | Whether to supply timestamp information with each measurement received from attached devices. (true or false) | true                      |
| IOTA\_JSON\_AUTOCAST          | Ensure JSON number values are read as numbers not strings. (true or false)                                    | true                      |

## How to setup

### IoT Agent for JSON over MQTT

To set up IoT Agent for JSON over MQTT, configure some environment variables in config.sh.

First, set a sub-domain name for IoT Agent to `IOTAGENT_JSON` and `MOSQUITTO` as shown:

```bash
IOTAGENT_JSON=iotagent-json
MOSQUITTO=mosquitto
```

To specify ports to use for the listener of Mosquitto, set `MQTT_1883` and/or `MQTT_TLS` to true.
The default listener is 8883 port (TLS).

```bash
MQTT_1883=
MQTT_TLS=
```

### IoT Agent for JSON over HTTP

To set up IoT Agent for JSON over HTTP, configure some environment variables in config.sh.

First, Set a sub-domain name for IoT Agent to `IOTAGENT_JSON` and `IOTAGENT_HTTP` as shown:

```bash
IOTAGENT_JSON=iotagent-json
IOTAGENT_HTTP=iotagent-http
```

The HTTP for southbound uses the port 443 (HTTPS). 

To specify an authorization type, set `IOTA_HTTP_AUTH` to `none`, `basic` or `bearer`.
The default value is `bearer`.

It is necessary to set a username and a password when using the basic authorization.
If not specified, the default value be used. The default username is `fiware`. The default
password is automatically generated.

```bash
IOTA_HTTP_BASIC_USER=
IOTA_HTTP_BASIC_PASS=
```

## Sanity check for IoT Agent for JSON

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

## IoT Agent for JSON over MQTT

### Create service

#### Request:

```bash
ngsi services \
  --host iotagent-json.example.com \
  create \
  --apikey  SMoCnNjlrAfeFOtlaC8XAhM8o1 \
  --type Thing \
  --resource /iot/json \
   --cbroker http://orion:1026
```

### List services

#### Request:

```bash
ngsi services \
  --host iotagent-json.example.com \
  list \
  --pretty
```

#### Response:

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

### Create device

#### Request:

```bash
ngsi devices \
  --host iotagent-json.example.com \
  create \
  --data '{ \
  "devices": [
    {
      "device_id":   "sensor002",
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

### List devices

#### Request:

```bash
ngsi devices \
  --host iotagent-json.example.com \
  list \
  --pretty
```

#### Response:

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

### Send data 

#### Request:

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

### List entities

#### Request:

```bash
ngsi get \
  --host orion.example.com \
  --service openiot \
  --path / \
  entity \
  --id urn:ngsi-ld:WeatherObserved:sensor00 \
  --pretty
```

#### Response:

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

### Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/iotagent-json-mqtt).

## IoT Agent for JSON over HTTP

### Create service

#### Request:

```bash
ngsi services \
  --host iotagent-json.example.com \
  create \
  --apikey XaEMQ86tTBHCwN0C9MjiHXcYFX \
  --type Thing \
  --resource /iot/json \
  --cbroker http://orion:1026
```
### List services

#### Request:

```bash
ngsi services \
  --host iotagent-json.example.com \
  list \
  --pretty
```

#### Response:

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

### Create device

#### Request:

```bash
ngsi devices \
  --host iotagent-json.example.com \
  create \
  --data '{
  "devices": [
    {
      "device_id":   "sensor004",
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

### List devices

#### Request:

```bash
ngsi devices \
  --host iotagent-json.example.com \
  list \
  --pretty
```

#### Response:

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

### Send data 

#### Request:

```bash
 curl -X POST "https://iotagent-http.example.com/iot/ul?k=XaEMQ86tTBHCwN0C9MjiHXcYFX&i=sensor004" \
   -u "fiware:1HAmMeajDpPSuTaF" \
   -H "Content-Type: text/plain" \
   -d '{"d":"2021-11-12T08:48:06+0000","t":16207,"h":2061,"p":11022}'
```

### Get entity

#### Request:

```bash
ngsi get \
  --host orion.example.com \
  --service openiot \
  --path / \
  entity \
  --id urn:ngsi-ld:WeatherObserved:sensor004 \
  --pretty
```

#### Response:

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

### Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/iotagent-json-http).

## Related information

-   [iotagent-json - GitHub](https://github.com/telefonicaid/iotagent-json)
-   [iotagnet-node-lib - GitHub](https://github.com/telefonicaid/iotagent-node-lib)
-   [iotagent-json - Read the docs](https://fiware-iotagent-json.readthedocs.io/en/latest/)
-   [iotagent-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent configuration API - Apiary](https://telefonicaiotiotagents.docs.apiary.io/#reference/configuration-api)
-   [iotagnet-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent for JSON - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-agent-json.html)
-   [IoT Agent over MQTT - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt.html)
-   [NGSI Go tutorial for IoT Agent](https://ngsi-go.letsfiware.jp/tutorial/iot-agent/)
