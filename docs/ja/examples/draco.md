# Draco

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [Draco の健全性チェック](#sanity-check-for-draco)
-   [Draco GUI にログイン](#login-to-draco-gui)
-   [アクセス・ポリシを追加](#add-access-policies)
-   [MongoDB へのコンテキスト・データの永続化](#persisting-context-data-into-mongodb)
-   [MySQL へのコンテキスト・データの永続化](#persisting-context-data-into-mysql)
-   [PostgreSQL へのコンテキスト・データの永続化](#persisting-context-data-into-postgresql)
-   [例](#examples)
-   [関連情報](#related-information)

</details>

<a name="sanity-check-for-draco"></a>

## Draco の健全性チェック

Webブラウザで `https://draco.example.com` を開いて、Draco GUI にアクセスします。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-01.png)

<a name="login-to-draco-gui"></a>

## Draco GUI にログイン

Draco GU にログインするために、Webブラウザで `https://draco.example.com/nifi` を開きます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-02.png)

次に、Keyrock サインイン・ページにリダイレクトされます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-03.png)

Draco GUI にログインすると、次のようなページが表示されます:

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-04.png)

<a name="add-access-policies"></a>

## アクセス・ポリシを追加

コンポーネント・ツールバーの項目を選択できるようにするには、いくつかのアクセス・ポリシを追加する
必要があります。`Operate` ウィンドウ内の `Access Policies` ボタンをクリックして、`Access Policies`
ページを開きます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-10.png)

`view the component`、`modify the component` および `operate the component` で新しいポリシを作成します。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-11.png)

管理者の電子メールをユーザとして新しいポリシに追加します。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-12.png)

アクセス・ポリシを追加すると、コンポーネント・ツールバーの項目を選択できるようになります。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-13.png)

<a name="persisting-context-data-into-mongodb"></a>

## MongoDB へのコンテキスト・データの永続化

NiFi GUI の上部にあるコンポーネント・ツールバーに移動し、テンプレート・アイコンを見つけて、Draco ユーザ・スペース内に
ドラッグ・アンド・ドロップします。この時点で、使用可能なすべてのテンプレートのリストを含むポップアップが表示されます。
そして、`ORION-TO-MONGO.xml` テンプレートを選択してください。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-20.png)

すべてのプロセッサを選択し (Shift キーを押してすべてのプロセッサをクリックします)、開始ボタンをクリックして開始します。
これで、各プロセッサのステータス・アイコンが赤から緑に変わったことがわかります。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-21.png)

### コンテキストの変更をサブスクライブ

サブスクリプションを作成して、Draco にコンテキストの変更を通知し、それを MongoDB に保存します。

```bash
ngsi create \
  --host orion.example.com \
  --service openiot \
  --path / \
  subscription \
  --description "Notify Draco of all context changes" \
  --idPattern ".*" \
  --uri "http://draco:5050/notify"
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

### MongoDB から履歴データを読み取り

コマンドラインから MongoDB データを読み取るには、MongoDB コンテナ内にいる必要があります。

#### コマンド:

```bash
docker compose exec mongo bash
```

#### 結果:

```bash
root@15101e538fde:/# 
```

次に、MongoDB シェルを実行します:

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

<a name="persisting-context-data-into-mysql"></a>

## MySQL へのコンテキスト・データの永続化

NiFi GUI の上部にあるコンポーネント・ツールバーに移動し、テンプレート・アイコンを見つけて、Draco ユーザ・スペース内に
ドラッグ・アンド・ドロップします。この時点で、使用可能なすべてのテンプレートのリストを含むポップアップが表示されます。
そして、`ORION-TO-MYSQL.xml` テンプレートを選択してください。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-30.png)

Draco GUI ユーザ・スペースの任意の部分を右クリックし、`configure`  をクリックします。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-31.png)

サンダー・アイコンをクリックしてプロセッサを有効にします。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-32.png)

そして、`ENABLE` ボタンをクリックします。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-33.png)

次に、コントローラー構成ページを閉じます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-34.png)

NGSToMySQL プロセッサのステータス・アイコンが赤くなります。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-35.png)

すべてのプロセッサを選択し (Shift キーを押してすべてのプロセッサをクリックします)、開始ボタンをクリックして開始します。
これで、各プロセッサのステータス・アイコンが赤から緑に変わったことがわかります。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-36.png)


### コンテキストの変更をサブスクライブ

サブスクリプションを作成して、Draco にコンテキストの変更を通知し、それを MySQL に保存します:

```bash
ngsi create \
  --host orion.example.com \
  --service openiot \
  --path / \
  subscription \
  --description "Notify Draco of all context changes" \
  --idPattern ".*" \
  --uri "http://draco:5050/notify"
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

### MySQL から履歴データを読み取り

コマンド・ラインから MySQL データを読み取るには、MySQL コンテナ内にいる必要があります:

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
| x002f             |
+-------------------+
1 row in set (0.01 sec)
```

次のクエリを実行して履歴データを読み取ります:

#### クエリ:

```text
SELECT * FROM openiot.x002f;
```

#### 結果:

```text
+---------------+---------------------+-------------------+-----------+------------+-------------+----------+-----------+--------+
| recvTimeTs    | recvTime            | fiwareServicePath | entityId  | entityType | attrName    | attrType | attrValue | attrMd |
+---------------+---------------------+-------------------+-----------+------------+-------------+----------+-----------+--------+
| 1643187726446 | 01/26/2022 09:02:06 |                   | device001 | device     | temperature | Number   | 30290     | []     |
| 1643187727478 | 01/26/2022 09:02:07 |                   | device001 | device     | temperature | Number   | 8769      | []     |
| 1643187728510 | 01/26/2022 09:02:08 |                   | device001 | device     | temperature | Number   | 4184      | []     |
| 1643187729539 | 01/26/2022 09:02:09 |                   | device001 | device     | temperature | Number   | 9946      | []     |
| 1643187730571 | 01/26/2022 09:02:10 |                   | device001 | device     | temperature | Number   | 17908     | []     |
| 1643187731599 | 01/26/2022 09:02:11 |                   | device001 | device     | temperature | Number   | 19044     | []     |
| 1643187732627 | 01/26/2022 09:02:12 |                   | device001 | device     | temperature | Number   | 435       | []     |
| 1643187733655 | 01/26/2022 09:02:13 |                   | device001 | device     | temperature | Number   | 10452     | []     |
| 1643187734683 | 01/26/2022 09:02:14 |                   | device001 | device     | temperature | Number   | 4405      | []     |
| 1643187735711 | 01/26/2022 09:02:15 |                   | device001 | device     | temperature | Number   | 24210     | []     |
+---------------+---------------------+-------------------+-----------+------------+-------------+----------+-----------+--------+
10 rows in set (0.00 sec)
```

<a name="persisting-context-data-into-postgresql"></a>

## PostgreSQL へのコンテキスト・データの永続化

NiFi GUI の上部にあるコンポーネント・ツールバーに移動し、テンプレート・アイコンを見つけて、Draco ユーザ・スペース内に
ドラッグ・アンド・ドロップします。この時点で、使用可能なすべてのテンプレートのリストを含むポップアップが表示されます。
そして、`ORION-TO-POSTGRESQL.xml` テンプレートを選択してください。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-40.png)

Draco GUI ユーザ・スペースの任意の部分を右クリックし、`configure` をクリックします。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-41.png)

サンダー・アイコンをクリックしてプロセッサを有効にします。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-42.png)

そして、`ENABLE` ボタンをクリックします。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-43.png)

次に、コントローラー構成ページを閉じます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-44.png)

NGSToMySQL プロセッサのステータス・アイコンが赤くなります。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-45.png)

すべてのプロセッサを選択し (Shift キーを押してすべてのプロセッサをクリックします)、開始ボタンをクリックして開始します。
これで、各プロセッサのステータス・アイコンが赤から緑に変わったことがわかります。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/draco/draco-46.png)

### コンテキストの変更をサブスクライブ

サブスクリプションを作成して、Draco にコンテキストの変更を通知し、それを PostgreSQL に保存します。

```bash
ngsi create \
  --host orion.example.com \
  --service openiot \
  --path / \
  subscription \
  --description "Notify Draco of all context changes" \
  --idPattern ".*" \
  --uri "http://draco:5050/notify"
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

### PostgreSQL から履歴データを読み取り

コマンドラインから PostgreSQL データを読み取るには、PostgreSQL コンテナにいる必要があります:

#### コマンド:

```bash
docker compose exec postgres bash
```

#### 結果:

```bash
root@72b468efeb11:/#
```

次に、psql シェルを実行します。

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
 table_schema | table_name
--------------+------------
 openiot      | x002f
(1 row)
```

次のクエリを実行して履歴データを読み取ります:

#### クエリ:

```text
SELECT * FROM openiot.x002f;
```

#### 結果:

```text
  recvtimets   |      recvtime       | fiwareservicepath | entityid  | entitytype |  attrname   | attrtype | attrvalue | attrmd
---------------+---------------------+-------------------+-----------+------------+-------------+----------+-----------+--------
 1643187286219 | 01/26/2022 08:54:46 |                   | device001 | device     | temperature | Number   | 6367      | []
 1643187287236 | 01/26/2022 08:54:47 |                   | device001 | device     | temperature | Number   | 27099     | []
 1643187288272 | 01/26/2022 08:54:48 |                   | device001 | device     | temperature | Number   | 19884     | []
 1643187289301 | 01/26/2022 08:54:49 |                   | device001 | device     | temperature | Number   | 24317     | []
 1643187290334 | 01/26/2022 08:54:50 |                   | device001 | device     | temperature | Number   | 18696     | []
 1643187291389 | 01/26/2022 08:54:51 |                   | device001 | device     | temperature | Number   | 27072     | []
 1643187292420 | 01/26/2022 08:54:52 |                   | device001 | device     | temperature | Number   | 16981     | []
 1643187293467 | 01/26/2022 08:54:53 |                   | device001 | device     | temperature | Number   | 25624     | []
 1643187294499 | 01/26/2022 08:54:54 |                   | device001 | device     | temperature | Number   | 6011      | []
 1643187295528 | 01/26/2022 08:54:55 |                   | device001 | device     | temperature | Number   | 17796     | []
(10 rows)
```

<a name="examples"></a>

## 例

[こちら](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/draco)の例を参照ください。

<a name="related-information"></a>

## 関連情報

-   [ging / fiware-draco - GitHub](https://github.com/ging/fiware-draco)
-   [FIWARE Draco - readthedocs.io](https://fiware-draco.readthedocs.io/en/latest/)
-   [Apache NiFi System Administrator’s Guide](https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html)
-   [ging/fiware-draco - Docker Hub](https://hub.docker.com/r/ging/fiware-draco)
