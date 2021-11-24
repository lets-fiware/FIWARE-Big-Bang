# QuantumLeap

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Get version](#get-version)
-   [Sanity check for QuantumLeap](#sanity-check-for-quantumLeap)
-   [Persisting Context Data into QuantumLeap](#persisting-context-data-into-quantumLeap)
-   [Examples](#examples)
-   [Related information](#related-information)

</details>

## Get version

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

## Sanity check for QuantumLeap

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

## Persisting Context Data into QuantumLeap

### Subscribing to Context Changes

Create a subscription to notify QuantumLeap of changes in context.

#### Request:

```bash
ngsi create \
  --host orion.example.com \
  --service openiot \
  --path / \
  subscription \
  --description "Notify QuantumLeap of all context changes" \
  --idPattern ".*" \
  --uri "http://quantumleap:8668/v2/notify"
```

#### Response:

```text
61874444911a7c471a3120cd
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

### Get subscription

#### Request:

```bash
ngsi get \
  --host orion.example.com \
  --service openiot \
  --path / subscription \
  --id 61874444911a7c471a3120cd \
  --pretty
```

#### Response:

```json
{
  "id": "61874444911a7c471a3120cd",
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
    "lastNotification": "2021-11-07T03:14:41.000Z",
    "lastSuccess": "2021-11-07T03:14:41.000Z",
    "lastSuccessCode": 200,
    "onlyChangedAttrs": false,
    "http": {
      "url": "http://quantumleap:8668/v2/notify"
    },
    "attrsFormat": "normalized"
  },
  "status": "active"
}
```

### List of all the entity id

```bash
ngsi hget \
  --host quantumleap.example.com \
  --service openiot \
  --path / \
  entities
```

```json
[
  {
    "id": "device001",
    "index": [
      "2021-11-07T03:14:41.740+00:00"
    ],
    "type": "device"
  }
]
```

### Get history of an attribute

```bash
ngsi hget \
  --host quantumleap.example.com \
  --service openiot \
  --path / \
  attr \
  --id device001 \
  --attr temperature
```

```json
{
  "attrName": "temperature",
  "entityId": "device001",
  "index": [
    "2021-11-07T03:14:32.405+00:00",
    "2021-11-07T03:14:33.442+00:00",
    "2021-11-07T03:14:34.480+00:00",
    "2021-11-07T03:14:35.520+00:00",
    "2021-11-07T03:14:36.557+00:00",
    "2021-11-07T03:14:37.593+00:00",
    "2021-11-07T03:14:38.631+00:00",
    "2021-11-07T03:14:39.667+00:00",
    "2021-11-07T03:14:40.704+00:00",
    "2021-11-07T03:14:41.740+00:00"
  ],
  "values": [
    27100.0,
    154.0,
    8349.0,
    9855.0,
    1885.0,
    30714.0,
    29032.0,
    32073.0,
    23074.0,
    28867.0
  ]
}
```

## Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/quantumleap).

## Related information

-   [NGSI Timeseries API - GitHub](https://github.com/orchestracities/ngsi-timeseries-api)
-   [QuantumLeap - Read the docs](https://quantumleap.readthedocs.io/en/latest/)
-   [QuantumLeap API - SwaggerHub](https://app.swaggerhub.com/apis/smartsdk/ngsi-tsdb/)
-   [Time-Series Data - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/time-series-data.html)
-   [NGSI Go tutorial for QuantumLeap](https://ngsi-go.letsfiware.jp/tutorial/quantumleap/)
