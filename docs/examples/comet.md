# Comet

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Minimal mode (STH-Comet ONLY)](#minimal-mode-sth-comet-only)
    -   [Sanity check for Comet](#sanity-check-for-comet)
    -   [Subscribing to Context Changes](#subscribing-to-context-changes)
    -   [Create context data](#create-context-data)
    -   [List subscriptions](#list-subscriptions)
    -   [Raw data consumption](#raw-data-consumption)
    -   [Aggregated data consumption by aggregation method and resolution](#aggregated-data-consumption-by-aggregation-method-and-resolution)
    -   [Examples](#examples)
-   [Formal mode (Cygnus + STH-Comet)](#formal-mode-cygnus--sth-comet)
    -   [Sanity check for Cygnus and comet](#sanity-check-for-cygnus-and-comet)
    -   [Subscribing to Context Changes](#subscribing-to-context-changes-1)
    -   [Create context data](#create-context-data-1)
    -   [List subscriptions](#list-subscriptions-1)
    -   [Raw data consumption](#raw-data-consumption-1)
    -   [Aggregated data consumption by aggregation method and resolution](#aggregated-data-consumption-by-aggregation-method-and-resolution-1)
    -   [Examples](#examples-1)
-   [Related information](#related-information)

</details>

## Minimal mode (STH-Comet ONLY)

Persist Time Series Context Data into MongoDB through Comet.

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

### Subscribing to Context Changes

Create a subscription to notify Comet of changes in context and store it into MongoDB.

#### Request:

```bash
ngsi create \
  --host "orion.example.com" \
  --service openiot \
  --path / \
  subscription \
  --description "Notify Comet of all context changes" \
  --idPattern ".*" \
  --uri "http://comet:8666/notify" \
  --attrsFormat "legacy"
```

#### Response:

```text
618ba41e0e94f32bac78451d
```

### Create context data

Generate context data by running the following script:

```bash
#!/bin/bash
set -eu
for i in {0..9}
do
  echo $i
  ngsi upsert \
    --host orion.example.com \
    --service openiot \
    --path / \
    entity \
    --keyValues \
    --data "{\"id\":\"device001\", \"type\":\"device\", \"temperature\":${RANDOM}}"
  sleep 1
done
```

### List subscriptions

List subscriptions by running the following script:

#### Request:

```bash
ngsi list \
  --host "orion.example.com" \
  --service openiot \
  --path / \
  subscriptions \
  --pretty
```

#### Response:

```json
[
  {
    "id": "618ba41e0e94f32bac78451d",
    "subject": {
      "entities": [
        {
          "idPattern": ".*"
        }
      ],
      "condition": {}
    },
    "notification": {
      "timesSent": 10,
      "lastNotification": "2021-11-10T10:51:25.000Z",
      "lastSuccess": "2021-11-10T10:51:25.000Z",
      "lastSuccessCode": 200,
      "onlyChangedAttrs": false,
      "http": {
        "url": "http://comet:8666/notify"
      },
      "attrsFormat": "legacy"
    },
    "status": "active"
  }
]
```

### Raw data consumption

Obtain the short-term history of a context entity attribute by filtering by number of last entries:

#### Request:

```bash
ngsi hget \
  --host comet.example.com \
  --service openiot \
  --path / \
  attr \
  --lastN 3 \
  --type device \
  --id device001 \
  --attr temperature \
  --pretty
```

#### Response:

```json
{
  "type": "StructuredValue",
  "value": [
    {
      "recvTime": "2021-11-10T10:51:23.552Z",
      "attrType": "Number",
      "attrValue": 13021
    },
    {
      "recvTime": "2021-11-10T10:51:24.595Z",
      "attrType": "Number",
      "attrValue": 22143
    },
    {
      "recvTime": "2021-11-10T10:51:25.636Z",
      "attrType": "Number",
      "attrValue": 21341
    }
  ]
}
```

### Aggregated data consumption by aggregation method and resolution

List the sum of values of a context entity attribute by filtering by aggrMethod, aggrPeriod:

#### Request:

```bash
ngsi hget \
  --host comet.example.com \
  --service openiot \
  --path / \
  attr \
  --aggrMethod sum \
  --aggrPeriod day \
  --type device \
  --id device001 \
  --attr temperature \
  --pretty
```

#### Response:

```json
{
  "type": "StructuredValue",
  "value": [
    {
      "_id": {
        "attrName": "temperature",
        "origin": "2021-11-01T00:00:00.000Z",
        "resolution": "day"
      },
      "points": [
        {
          "offset": 10,
          "samples": 10,
          "sum": 170416
        }
      ]
    }
  ]
}
```

### Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/comet).

## Formal mode (Cygnus + STH-Comet)

Persist Time Series Context Data into MongoDB through Cygnus.

### Sanity check for Cygnus and comet

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

Once Comet is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host comet.example.com
```

#### Response:

```json
{"version":"2.8.0-next"}
```

### Subscribing to Context Changes

Create a subscription to notify Cygnus of changes in context and store it into MongoDB.

#### Request:

```bash
ngsi create \
  --host orion.example.com \
  --service openiot \
  --path / \
  subscription \
  --description "Notify Cygnus of all context changes and store it into MongoDB" \
  --idPattern ".*" \
  --uri "http://cygnus:5051/notify"
```

#### Response:

```text
618bb2ba926e5a749721fc6b
```

### Create context data

Generate context data by running the following script:

```bash
#!/bin/bash
set -eu
for i in {0..9}
do
  echo $i
  ngsi upsert \
    --host orion.example.com \
    --service openiot \
    --path / \
    entity \
    --keyValues \
    --data "{\"id\":\"device001\", \"type\":\"device\", \"temperature\":${RANDOM}}"
  sleep 1
done
```

### List subscriptions

List subscriptions by running the following script:

#### Request:

```bssh
ngsi list \
  --host "orion.example.com" \
  --service openiot \
  --path / \
  subscriptions \
  --pretty
```

#### Response:

```json
[
  {
    "id": "618bb2ba926e5a749721fc6b",
    "subject": {
      "entities": [
        {
          "idPattern": ".*"
        }
      ],
      "condition": {}
    },
    "notification": {
      "timesSent": 10,
      "lastNotification": "2021-11-10T11:55:42.000Z",
      "lastSuccess": "2021-11-10T11:55:42.000Z",
      "lastSuccessCode": 200,
      "onlyChangedAttrs": false,
      "http": {
        "url": "http://cygnus:5051/notify"
      },
      "attrsFormat": "normalized"
    },
    "status": "active"
  }
]
```

### Raw data consumption

Obtain the short-term history of a context entity attribute by filtering by number of last entries:

#### Request:

```bash
ngsi hget \
  --host comet.example.com \
  --service openiot \
  --path / \
  attr \
  --lastN 3 \
  --type device \
  --id device001 \
  --attr temperature \
  --pretty
```

#### Response:

```json
{
  "type": "StructuredValue",
  "value": [
    {
      "attrType": "Number",
      "attrValue": 3876,
      "recvTime": "2021-11-10T11:55:40.651Z"
    },
    {
      "attrType": "Number",
      "attrValue": 1629,
      "recvTime": "2021-11-10T11:55:41.690Z"
    },
    {
      "attrType": "Number",
      "attrValue": 28278,
      "recvTime": "2021-11-10T11:55:42.741Z"
    }
  ]
}
```

### Aggregated data consumption by aggregation method and resolution

List the sum of values of a context entity attribute by filtering by aggrMethod, aggrPeriod:

#### Request:

```bash
ngsi hget \
  --host comet.example.com \
  --service openiot \
  --path / \
  attr \
  --aggrMethod sum \
  --aggrPeriod day \
  --type device \
  --id device001 \
  --attr temperature \
  --pretty
```

#### Response:

```json
{
  "type": "StructuredValue",
  "value": [
    {
      "_id": {
        "attrName": "temperature",
        "origin": "2021-11-01T00:00:00.000Z",
        "resolution": "day"
      },
      "points": [
        {
          "offset": 10,
          "samples": 10,
          "sum": 192993
        }
      ]
    }
  ]
}
```

### Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/comet-cygnus).

## Related information

-   [STH-Comet - GitHub](https://github.com/telefonicaid/fiware-sth-comet)
-   [STH-Comet - Read the docs](https://fiware-sth-comet.readthedocs.io/en/latest/)
-   [Short Term History - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/short-term-history.html)
-   [NGSI Go tutorial for STH-Comet](https://ngsi-go.letsfiware.jp/tutorial/comet/)
-   [telefonicaiot/fiware-sth-comet - Docker HUB](https://hub.docker.com/r/telefonicaiot/fiware-sth-comet)
