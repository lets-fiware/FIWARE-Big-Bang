# Comet

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [最小モード (STH-Comet のみ)](#minimal-mode-sth-comet-only)
    -   [Comet の健全性チェック](#sanity-check-for-comet)
    -   [コンテキストの変更をサブスクライブ](subscribing-to-context-changes)
    -   [コンテキスト・データの作成](#create-context-data)
    -   [サブスクリプションの一覧表示](#list-subscriptions)
    -   [Raw データの取得](#raw-data-consumption)
    -   [集計方法と解像度による集計データの取得](#aggregated-data-consumption-by-aggregation-method-and-resolution)
    -   [例](#examples)
-   [フォーマル・モード (Cygnus + STH-Comet)](#formal-mode-cygnus--sth-comet)
    -   [Cygnus と comet の健全性チェック](#sanity-check-for-cygnus-and-comet)
    -   [コンテキストの変更をサブスクライブ](#subscribing-to-context-changes-1)
    -   [コンテキスト・データの作成](#create-context-data-1)
    -   [サブスクリプションの一覧表示](#list-subscriptions-1)
    -   [Raw データの取得](#raw-data-consumption-1)
    -   [集計方法と解像度による集計データの取得](#aggregated-data-consumption-by-aggregation-method-and-resolution-1)
    -   [例](#examples-1)
-   [関連情報](#related-information)

</details>

<a name="minimal-mode-sth-comet-only"></a>

## 最小モード (STH-Comet のみ)

Comet を介して時系列コンテキスト・データを MongoDB に永続化します。

<a name="sanity-check-for-comet"></a>

### Comet の健全性チェック

Comet が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host comet.example.com
```

#### レスポンス:

```json
{"version":"2.8.0-next"}
```

<a name="subscribing-to-context-changes"></a>

### コンテキストの変更をサブスクライブ

サブスクリプションを作成して、Comet にコンテキストの変更を通知し、それを MongoDB に保存します:

#### リクエスト:

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

#### レスポンス:

```text
618ba41e0e94f32bac78451d
```

<a name="create-context-data"></a>

### コンテキスト・データの作成

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

<a name="list-subscriptions"></a>

### サブスクリプションの一覧表示

次のスクリプトを実行して、サブスクリプションを一覧表示します:

#### リクエスト:

```bash
ngsi list \
  --host "orion.example.com" \
  --service openiot \
  --path / \
  subscriptions \
  --pretty
```

#### レスポンス:

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

<a name="raw-data-consumption"></a>

### Raw データの取得

最後のエントリ数でフィルタリングして、コンテキスト・エンティティ属性の短期履歴を取得します:

#### リクエスト:

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

#### レスポンス:

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

<a name="aggregated-data-consumption-by-aggregation-method-and-resolution"></a>

### 集計方法と解像度による集計データの取得

aggrMethod、aggrPeriod でフィルタリングして、コンテキスト・エンティティ属性の値の合計を一覧表示します:

#### リクエスト:

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

#### レスポンス:

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

<a name="examples"></a>

### 例

[こちら](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/comet) の例を参照ください。

<a name="formal-mode-cygnus--sth-comet"></a>

## フォーマル・モード (Cygnus + STH-Comet)

Cygnus を介して時系列コンテキスト・データを MongoDB に永続化します。

<a name="sanity-check-for-cygnus-and-comet"></a>

### Cygnus と comet の健全性チェック

Cygnus が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host cygnus.example.com --pretty
```

#### レスポンス:

```json
{
  "success": "true",
  "version": "2.10.0.5bb41dfcca1e25db664850e6b7806e3cf6a2aa7b"
}
```

Comet が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host comet.example.com
```

#### レスポンス:

```json
{"version":"2.8.0-next"}
```

<a name="subscribing-to-context-changes-1"></a>

### コンテキストの変更をサブスクライブ

Cygnus にコンテキストの変更を通知するサブスクリプションを作成し、それを MongoDB に保存します:

#### リクエスト:

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

#### レスポンス:

```text
618bb2ba926e5a749721fc6b
```

<a name="create-context-data-1"></a>

### コンテキスト・データの作成

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

<a name="list-subscriptions-1"></a>

### サブスクリプションの一覧表示

次のスクリプトを実行して、サブスクリプションを一覧表示します:

#### リクエスト:

```bssh
ngsi list \
  --host "orion.example.com" \
  --service openiot \
  --path / \
  subscriptions \
  --pretty
```

#### レスポンス:

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

<a name="raw-data-consumption-1"></a>

### Raw データの取得

最後のエントリ数でフィルタリングして、コンテキスト・エンティティ属性の短期履歴を取得します:

#### リクエスト:

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

#### レスポンス:

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

<a name="aggregated-data-consumption-by-aggregation-method-and-resolution-1"></a>

### 集計方法と解像度による集計データの取得

aggrMethod、aggrPeriod でフィルタリングして、コンテキスト・エンティティ属性の値の合計を一覧表示します:

#### リクエスト:

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

#### レスポンス:

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

<a name="examples-1"></a>

### 例

[こちら](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/comet-cygnus) の例を参照ください。

<a name="related-information"></a>

## 関連情報

-   [STH-Comet - GitHub](https://github.com/telefonicaid/fiware-sth-comet)
-   [STH-Comet - Read the docs](https://fiware-sth-comet.readthedocs.io/en/latest/)
-   [Short Term History - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/short-term-history.html)
-   [NGSI Go tutorial for STH-Comet](https://ngsi-go.letsfiware.jp/tutorial/comet/)
-   [telefonicaiot/fiware-sth-comet - Docker HUB](https://hub.docker.com/r/telefonicaiot/fiware-sth-comet)
