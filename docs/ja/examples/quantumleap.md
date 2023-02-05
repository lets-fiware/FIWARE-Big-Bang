# QuantumLeap

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [バージョンを取得](#get-version)
-   [QuantumLeap の健全性チェック](#sanity-check-for-quantumLeap)
-   [QuantumLeap へのコンテキスト・データの永続化](#persisting-context-data-into-quantumLeap)
-   [例](#examples)
-   [関連情報](#related-information)

</details>

<a name="get-version"></a>

## バージョンを取得

QuantumLeap が起動したら、次のコマンドでバージョンを取得できます:

#### リクエスト:

```bash
ngsi version --host quantumleap.example.com
```

#### レスポンス:

```json
{
  "version": "0.8.1"
}
```

<a name="sanity-check-for-quantumLeap"></a>

## QuantumLeap の健全性チェック

次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi health --host quantumleap.example.com
```

#### レスポンス:

```json
{
  "status": "pass"
}
```

<a name="persisting-context-data-into-quantumLeap"></a>

## QuantumLeap へのコンテキスト・データの永続化

### コンテキストの変更をサブスクライブ

サブスクリプションを作成して、コンテキストの変更を QuantumLeap に通知します。

#### リクエスト:

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

#### レスポンス:

```text
61874444911a7c471a3120cd
```

### コンテキスト・データを作成

次のスクリプトを実行して、コンテキスト・データを生成します:

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

### サブスクリプションを取得

#### リクエスト:

```bash
ngsi get \
  --host orion.example.com \
  --service openiot \
  --path / subscription \
  --id 61874444911a7c471a3120cd \
  --pretty
```

#### レスポンス:

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

### すべてのエンティティ Id の一覧取得

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

### 属性の履歴を取得

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

<a name="examples"></a>

## 例

[こちら](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/quantumleap)の例を見てください。

<a name="related-information"></a>

## 関連情報

-   [NGSI Timeseries API - GitHub](https://github.com/orchestracities/ngsi-timeseries-api)
-   [QuantumLeap - Read the docs](https://quantumleap.readthedocs.io/en/latest/)
-   [QuantumLeap API - SwaggerHub](https://app.swaggerhub.com/apis/smartsdk/ngsi-tsdb/)
-   [Time-Series Data - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/time-series-data.html)
-   [NGSI Go tutorial for QuantumLeap](https://ngsi-go.letsfiware.jp/tutorial/quantumleap/)
-   [orchestracities/quantumleap - Docker Hub](https://hub.docker.com/r/orchestracities/quantumleap)
