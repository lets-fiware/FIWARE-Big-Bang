# IoT Agent for UltraLight 2.0

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Sanity check for IoT Agent for UltraLight 2.0](#sanity-check-for-iot-agent-for-ul)
-   [IoT Agent for UL over MQTT](#iot-agent-for-ul-over-mqtt)
    -   [Create service](#create-service)
    -   [List services](#list-services)
    -   [Create device](#create-device)
    -   [List devices](#list-devices)
    -   [Send data](#send-data)
    -   [Get entity](#get-entity)
    -   [Examples](#examples)
-   [IoT Agent for UL over HTTP](#iot-agent-for-ul-over-http)
    -   [Create service](#create-service-1)
    -   [List services](#list-services-1)
    -   [Create device](#create-device-1)
    -   [List devices](#list-devices-1)
    -   [Send data](#send-data-1)
    -   [Get entity](#get-entity)
    -   [Examples](#examples-1)
-   [Related information](#related-information)

</details>

## Sanity check for IoT Agent for UL

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

## IoT Agent for UL over MQTT

### Create service

#### Request:

```bash
ngsi services \
  --host iotagent-ul.example.com \
  create \
  --apikey 8f9z57ahxmtzx21oczr5vaabot \
  --type Thing \
  --resource /iot/ul \
   --cbroker http://orion:1026
```

### List services

#### Request:

```bash
ngsi services \
  --host iotagent-ul.example.com \
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
      "_id": "618cff6b36b21980226fffc2",
      "resource": "/iot/ul",
      "apikey": "8f9z57ahxmtzx21oczr5vaabot",
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
  --host iotagent-ul.example.com \
  create \
  --data '{ \
  "devices": [
    {
      "device_id":   "sensor001",
      "entity_name": "urn:ngsi-ld:WeatherObserved:sensor001",
      "entity_type": "Sensor",
      "timezone":    "Asia/Tokyo",
      "protocol":    "PDI-IoTA-UltraLight",
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
  --host iotagent-ul.example.com \
  list \
  --pretty
```

#### Response:

```json
{
  "count": 1,
  "devices": [
    {
      "device_id": "sensor001",
      "service": "openiot",
      "service_path": "/",
      "entity_name": "urn:ngsi-ld:WeatherObserved:sensor001",
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
      "protocol": "PDI-IoTA-UltraLight",
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
  --username fiware --pw ZSpi0wAz1e1ZImd8 \
  --topic "/8f9z57ahxmtzx21oczr5vaabot/sensor001/attrs" \
  --message "d|2021-11-11T11:36:49+0000|t|10465|h|27378|p|20617" \
  --cafile ./config/mosquitto/isrgrootx1.pem
```

### Get entity

#### Request:

```bash
ngsi get \
  --host orion.example.com \
  --service openiot \
  --path / \
  entity \
  --id urn:ngsi-ld:WeatherObserved:sensor001 \
  --pretty
```

#### Response:

```json
{
  "id": "urn:ngsi-ld:WeatherObserved:sensor001",
  "type": "Sensor",
  "TimeInstant": {
    "type": "DateTime",
    "value": "2021-11-11T11:36:49.576Z",
    "metadata": {}
  },
  "atmosphericPressure": {
    "type": "Number",
    "value": 20617,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-11T11:36:49.576Z"
      }
    }
  },
  "dateObserved": {
    "type": "DateTime",
    "value": "2021-11-11T11:36:49.000Z",
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-11T11:36:49.576Z"
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
        "value": "2021-11-11T11:36:49.576Z"
      }
    }
  },
  "relativeHumidity": {
    "type": "Number",
    "value": 27378,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-11T11:36:49.576Z"
      }
    }
  },
  "temperature": {
    "type": "Number",
    "value": 10465,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-11T11:36:49.576Z"
      }
    }
  }
}
```

### Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/iotagent-ul-mqtt).

## IoT Agent for UL over HTTP

### Create service

#### Request:

```bash
ngsi services \
  --host iotagent-ul.example.com \
  create \
  --apikey Dk8A0vfwTkTiAY71QyyKzOv9CT \
  --type Thing \
  --resource /iot/ul \
  --cbroker http://orion:1026
```

### List services

#### Request:

```bash
ngsi services \
  --host iotagent-ul.example.com \
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
      "_id": "618d03230e779727e4443d1a",
      "resource": "/iot/ul",
      "apikey": "Dk8A0vfwTkTiAY71QyyKzOv9CT",
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
  --host iotagent-ul.example.com \
  create \
  --data '{
  "devices": [
    {
      "device_id":   "sensor003",
      "entity_name": "urn:ngsi-ld:WeatherObserved:sensor003",
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
  --host iotagent-ul.example.com \
  list \
  --pretty
```

#### Response:

```json
  "count": 1,
  "devices": [
    {
      "device_id": "sensor003",
      "service": "openiot",
      "service_path": "/",
      "entity_name": "urn:ngsi-ld:WeatherObserved:sensor003",
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
 curl -X POST "https://iotagent-http.example.com/iot/ul?k=Dk8A0vfwTkTiAY71QyyKzOv9CT&i=sensor003" \
   -u "fiware:AEAtp3JC6qxtPKah" \
   -H "Content-Type: text/plain" \
   -d "d|2021-11-11T11:59:14+0000|t|20641|h|8290|p|5371"
```

### Get entity

#### Request:

```bash
ngsi get \
  --host orion.example.com \
  --service openiot \
  --path / \
  entity \
  --id urn:ngsi-ld:WeatherObserved:sensor003 \
  --pretty
```

#### Response:

```json
{
  "id": "urn:ngsi-ld:WeatherObserved:sensor003",
  "type": "Sensor",
  "TimeInstant": {
    "type": "DateTime",
    "value": "2021-11-11T11:59:14.440Z",
    "metadata": {}
  },
  "atmosphericPressure": {
    "type": "Number",
    "value": 5371,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-11T11:59:14.440Z"
      }
    }
  },
  "dateObserved": {
    "type": "DateTime",
    "value": "2021-11-11T11:59:14.000Z",
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-11T11:59:14.440Z"
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
        "value": "2021-11-11T11:59:14.440Z"
      }
    }
  },
  "relativeHumidity": {
    "type": "Number",
    "value": 8290,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-11T11:59:14.440Z"
      }
    }
  },
  "temperature": {
    "type": "Number",
    "value": 20641,
    "metadata": {
      "TimeInstant": {
        "type": "DateTime",
        "value": "2021-11-11T11:59:14.440Z"
      }
    }
  }
}
```

### Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/iotagent-ul-http).

## Related information

-   [iotagent-ul - GitHub](https://github.com/telefonicaid/iotagent-ul)
-   [iotagnet-node-lib - GitHub](https://github.com/telefonicaid/iotagent-node-lib)
-   [iotagent-ul - Read the docs](https://fiware-iotagent-ul.readthedocs.io/en/latest/)
-   [iotagent-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent configuration API - Apiary](https://telefonicaiotiotagents.docs.apiary.io/#reference/configuration-api)
-   [iotagnet-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent for UltraLight - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-agent.html)
-   [IoT Agent over MQTT - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt.html)
-   [NGSI Go tutorial for IoT Agent](https://ngsi-go.letsfiware.jp/tutorial/iot-agent/)
-   [telefonicaiot/iotagent-ul - Docker Hub](https://hub.docker.com/r/telefonicaiot/iotagent-ul)
