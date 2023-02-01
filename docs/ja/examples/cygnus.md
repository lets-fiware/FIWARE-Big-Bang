# Cygnus

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [Cygnus の健全性チェック](#sanity-check-for-cygnus)
-   [MongoDB へのコンテキスト・データの永続化](#persisting-context-data-into-mongodb)
-   [MySQL へのコンテキスト・データの永続化](#persisting-context-data-into-mysql)
-   [PostgreSQL へのコンテキスト・データの永続化](#persisting-context-data-into-postgresql)
-   [Elasticsearch へのコンテキスト・データの永続化](#persisting-context-data-into-elasticsearch)
-   [例](#examples)
-   [関連情報](#related-information)

</details>

<a name="sanity-check-for-cygnus"></a>

## Cygnus の健全性チェック

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

<a name="persisting-context-data-into-mongodb"></a>

## MongoDB へのコンテキスト・データの永続化

<a name="persisting-context-data-into-mongodb"></a>

### コンテキストの変更をサブスクライブ

Cygnus にコンテキストの変更を通知するサブスクリプションを作成し、それを MongoDB に保存します:

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

### コンテキスト・データを作成

次のスクリプトを実行して、コンテキスト・データを作成します:

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

### MongoDB から履歴データを読み取る

コマンドラインから MongoDB データを読み取るには、MongoDB コンテナ内にいる必要があります:

#### コマンド:

```bash
docker compose exec mongo bash
```

#### 結果:

```bash
root@15101e538fde:/# 
```

Then, run the MongoDB shell.

#### コマンド:

```text
mongo 
```

#### 結果:

```text
MongoDB shell version v4.4.8
connecting to: mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("0a85a937-ea0d-4532-b43e-eca3105f7003") }
MongoDB server version: 4.4.8
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
	https://docs.mongodb.com/
Questions? Try the MongoDB Developer Community Forums
	https://community.mongodb.com
```

使用可能なデータベースのリストを表示するには、次のステートメントを実行します:

#### クエリ:

```text
show dbs
```

#### 結果:

```text
admin          0.000GB
config         0.000GB
local          0.000GB
orion          0.000GB
orion-openiot  0.000GB
orionld        0.000GB
sth_openiot    0.000GB
```

アクセスするデータベースに切り替えます:

#### クエリ:

```text
use sth_openiot
```

#### 結果:

```text
switched to db sth_openiot
```

データベース内のコレクションを一覧表示します:

#### クエリ:

```text
show collections
```

#### 結果:

```text
sth_/_device001_device
sth_/_device001_device.aggr
```

次のクエリを実行して履歴データを読み取ります:

#### クエリ:

```text
db["sth_/_device001_device"].find().limit(10)
```

#### 結果:

```json
{ "_id" : ObjectId("6183c90a39b98320cb0bfffd"), "attrName" : "temperature", "attrType" : "Number", "attrValue" : 16193, "recvTime" : ISODate("2021-11-04T11:50:33.734Z") }
{ "_id" : ObjectId("6183c90a39b98320cb0bfffe"), "attrName" : "temperature", "attrType" : "Number", "attrValue" : 28959, "recvTime" : ISODate("2021-11-04T11:50:34.721Z") }
{ "_id" : ObjectId("6183c90b39b98320cb0bffff"), "attrName" : "temperature", "attrType" : "Number", "attrValue" : 15080, "recvTime" : ISODate("2021-11-04T11:50:35.758Z") }
{ "_id" : ObjectId("6183c90c39b98320cb0c0000"), "attrName" : "temperature", "attrType" : "Number", "attrValue" : 5697, "recvTime" : ISODate("2021-11-04T11:50:36.795Z") }
{ "_id" : ObjectId("6183c90d39b98320cb0c0001"), "attrName" : "temperature", "attrType" : "Number", "attrValue" : 7126, "recvTime" : ISODate("2021-11-04T11:50:37.832Z") }
{ "_id" : ObjectId("6183c90e39b98320cb0c0002"), "attrName" : "temperature", "attrType" : "Number", "attrValue" : 5396, "recvTime" : ISODate("2021-11-04T11:50:38.869Z") }
{ "_id" : ObjectId("6183c90f39b98320cb0c0003"), "attrName" : "temperature", "attrType" : "Number", "attrValue" : 32231, "recvTime" : ISODate("2021-11-04T11:50:39.907Z") }
{ "_id" : ObjectId("6183c91039b98320cb0c0004"), "attrName" : "temperature", "attrType" : "Number", "attrValue" : 30974, "recvTime" : ISODate("2021-11-04T11:50:40.946Z") }
{ "_id" : ObjectId("6183c91139b98320cb0c0005"), "attrName" : "temperature", "attrType" : "Number", "attrValue" : 31005, "recvTime" : ISODate("2021-11-04T11:50:41.984Z") }
{ "_id" : ObjectId("6183c91339b98320cb0c0006"), "attrName" : "temperature", "attrType" : "Number", "attrValue" : 3404, "recvTime" : ISODate("2021-11-04T11:50:43.020Z") }
```

<a name"persisting-context-data-into-mysql"></a>

## MySQL へのコンテキスト・データの永続化

### コンテキストの変更をサブスクライブ

サブスクリプションを作成して、コンテキストの変更を Cygnus に通知し、それを MySQL に保存します:

```bash
ngsi create \
  --host orion.example.com \
  --service openiot \
  --path / \
  subscription \
  --description "Notify Cygnus of all context changes and store it into MySQL" \
  --idPattern ".*" \
  --uri "http://cygnus:5050/notify"
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

### MySQL から履歴データを読み取る

コマンドラインから MySQL データを読み取るには、MySQL コンテナ内にいる必要があります:

#### コマンド:

```bash
docker compose exec mysql bash
```

#### 結果:

```bash
root@898cef135030:/#
```

Then, run the MySQL shell.

#### コマンド:

```bash
root@898cef135030:/# mysql -uroot -p
```

#### 結果:

```text
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 21
Server version: 5.7.35 MySQL Community Server (GPL)

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```

使用可能なデータベースのリストを表示するには、次のステートメントを実行します:

#### クエリ:

```
show databases;
```

#### 結果:

```text
+--------------------+
| Database           |
+--------------------+
| information_schema |
| idm                |
| mysql              |
| openiot            |
| performance_schema |
| sys                |
+--------------------+
6 rows in set (0.00 sec)
```

アクセスするデータベースに切り替えます:

#### クエリ:

```text
use openiot;
```

#### 結果:

```text
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
```

データベース内のテーブルを一覧表示します:

#### クエリ:

```text
show tables;
```

#### 結果:

```text
+-------------------+
| Tables_in_openiot |
+-------------------+
| device001_device  |
+-------------------+
1 row in set (0.01 sec)
```

次のクエリを実行して履歴データを読み取ります:

#### クエリ:

```text
SELECT * FROM openiot.device001_device;
```

#### 結果:

```text
+---------------+-------------------------+-------------------+-----------+------------+-------------+----------+-----------+--------+
| recvTimeTs    | recvTime                | fiwareServicePath | entityId  | entityType | attrName    | attrType | attrValue | attrMd |
+---------------+-------------------------+-------------------+-----------+------------+-------------+----------+-----------+--------+
| 1636026471937 | 2021-11-04 11:47:51.937 | /                 | device001 | device     | temperature | Number   | 27949     | []     |
| 1636026472924 | 2021-11-04 11:47:52.924 | /                 | device001 | device     | temperature | Number   | 12814     | []     |
| 1636026473962 | 2021-11-04 11:47:53.962 | /                 | device001 | device     | temperature | Number   | 27130     | []     |
| 1636026474998 | 2021-11-04 11:47:54.998 | /                 | device001 | device     | temperature | Number   | 17045     | []     |
| 1636026476035 | 2021-11-04 11:47:56.35  | /                 | device001 | device     | temperature | Number   | 21570     | []     |
| 1636026477074 | 2021-11-04 11:47:57.74  | /                 | device001 | device     | temperature | Number   | 20572     | []     |
| 1636026478110 | 2021-11-04 11:47:58.110 | /                 | device001 | device     | temperature | Number   | 19597     | []     |
| 1636026479149 | 2021-11-04 11:47:59.149 | /                 | device001 | device     | temperature | Number   | 22112     | []     |
| 1636026480200 | 2021-11-04 11:48:00.200 | /                 | device001 | device     | temperature | Number   | 23413     | []     |
| 1636026481238 | 2021-11-04 11:48:01.238 | /                 | device001 | device     | temperature | Number   | 1594      | []     |
+---------------+-------------------------+-------------------+-----------+------------+-------------+----------+-----------+--------+
10 rows in set (0.00 sec)
```

<a name="persisting-context-data-into-postgresql"></a>

## PostgreSQL へのコンテキスト・データの永続化

### コンテキストの変更をサブスクライブ

Cygnus にコンテキストの変更を通知するサブスクリプションを作成し、それを PostgreSQL に保存します:

```bash
ngsi create \
  --host orion.example.com \
  --service openiot \
  --path / \
  subscription \
  --description "Notify Cygnus of all context changes and store it into PostgreSQL" \
  --idPattern ".*" \
  --uri "http://cygnus:5055/notify"
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

### PostgreSQL から履歴データを読み取る

コマンド ラインから PostgreSQL データを読み取るには、PostgreSQL コンテナにいる必要があります:

#### コマンド:

```bash
docker compose exec postgres bash
```

#### 結果:

```bash
root@72b468efeb11:/#
```

次に、psql シェルを実行します:

#### コマンド:

```bash
psql -U postgres
```

#### 結果:

```text
psql (11.13 (Debian 11.13-1.pgdg90+1))
Type "help" for help.
```

使用可能なデータベースのリストを表示するには、次のステートメントを実行します:

#### クエリ:

```text
\l
```

#### 結果:

```text
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```

使用可能なスキーマのリストを表示するには、次のようにステートメントを実行します:

#### クエリ:

```text
\dn
```

#### 結果:

```text
  List of schemas
  Name   |  Owner   
---------+----------
 openiot | postgres
 public  | postgres
(2 rows)
```

使用可能なテーブルのリストを表示するには、次のようにステートメントを実行します:

#### クエリ:

```text
SELECT table_schema,table_name FROM information_schema.tables WHERE table_schema ='openiot' ORDER BY table_schema,table_name;
```

#### 結果:

```text
 table_schema |    table_name    
--------------+------------------
 openiot      | device001_device
(1 row)
```

次のクエリを実行して履歴データを読み取ります:

#### クエリ:

```text
SELECT * FROM openiot.device001_device;
```

#### 結果:

```text
  recvtimets   |        recvtime         | fiwareservicepath | entityid  | entitytype |  attrname   | attrtype | attrvalue | attrmd 
---------------+-------------------------+-------------------+-----------+------------+-------------+----------+-----------+--------
 1636025904123 | 2021-11-04 11:38:24.123 | /                 | device001 | device     | temperature | Number   | 11395     | []
 1636025905114 | 2021-11-04 11:38:25.114 | /                 | device001 | device     | temperature | Number   | 28452     | []
 1636025906155 | 2021-11-04 11:38:26.155 | /                 | device001 | device     | temperature | Number   | 23207     | []
 1636025907193 | 2021-11-04 11:38:27.193 | /                 | device001 | device     | temperature | Number   | 19318     | []
 1636025908233 | 2021-11-04 11:38:28.233 | /                 | device001 | device     | temperature | Number   | 26442     | []
 1636025909275 | 2021-11-04 11:38:29.275 | /                 | device001 | device     | temperature | Number   | 24482     | []
 1636025910314 | 2021-11-04 11:38:30.314 | /                 | device001 | device     | temperature | Number   | 6452      | []
 1636025911356 | 2021-11-04 11:38:31.356 | /                 | device001 | device     | temperature | Number   | 12381     | []
 1636025912394 | 2021-11-04 11:38:32.394 | /                 | device001 | device     | temperature | Number   | 15262     | []
 1636025913433 | 2021-11-04 11:38:33.433 | /                 | device001 | device     | temperature | Number   | 9009      | []
(10 rows)
```

<a name="persisting-context-data-into-elasticsearch"></a>

## Elasticsearch へのコンテキスト・データの永続化

### コンテキストの変更をサブスクライブ

Cygnus にコンテキストの変更を通知するサブスクリプションを作成し、それを Elasticsearch に保存します:

```bash
ngsi create \
  --host orion.example.com \
  --service openiot \
  --path / \
  subscription \
  --description "Notify Cygnus of all context changes and store it into Elasticsearch" \
  --idPattern ".*" \
  --uri "http://cygnus:5058/notify"
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

### Elasticsearch から履歴データを読み取る

コマンド ラインから Elasticsearch を読み取るには、次のように OAuth2 トークンを環境変数 `TOKEN` に設定する必要があります:

```bash
export TOKEN=`ngsi token --host orion.example.com`
```

使用可能なデータベースのリストを表示するには、次のステートメントを実行します:

#### クエリ:

```bash
curl -sXGET 'https://elasticsearch.example.com/_cat/indices?v&pretty' -H "Authorization: Bearer $TOKEN"
```

#### 結果:

```text
health status index                                       pri rep docs.count docs.deleted store.size pri.store.size 
yellow open   cygnus-openiot--device001-device-2021.11.05   5   1         10            0     35.7kb         35.7kb 
```

次のクエリを実行して履歴データを読み取ります:

#### クエリ:

```
curl -sXGET "https://elasticsearch.example.com/_sql?format=json" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $TOKEN" \
-d'
{
  "query": " select * from \"cygnus-openiot--device001-device-2021.11.05\" limit 2 "
}'
```

#### 結果:

```
{
  "columns": [
    {
      "name": "attrName",
      "type": "text"
    },
    {
      "name": "attrType",
      "type": "text"
    },
    {
      "name": "attrValue",
      "type": "text"
    },
    {
      "name": "entityId",
      "type": "text"
    },
    {
      "name": "entityType",
      "type": "text"
    },
    {
      "name": "recvTime",
      "type": "datetime"
    }
  ],
  "rows": [
    [
      "temperature",
      "Number",
      "13546",
      "device001",
      "device",
      "2021-11-05T09:29:50.404Z"
    ],
    [
      "temperature",
      "Number",
      "749",
      "device001",
      "device",
      "2021-11-05T09:29:51.401Z"
    ]
  ]
}
```

<a name="examples"></a>

## 例

[こちら](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/cygnus) の例を参照ください。

<a name="related-information"></a>

## 関連情報

-   [FIWARE Cygnus documentation](https://fiware-cygnus.readthedocs.io/en/latest/)
-   [FIWARE Cygnus - GitHub](https://github.com/telefonicaid/fiware-cygnus)
-   [Persisting context (Apache Flume) - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/historic-context-flume.html)
