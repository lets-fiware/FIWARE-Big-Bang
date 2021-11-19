# Cygnus

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Sanity check for Cygnus](#sanity-check-for-cygnus)
-   [Persisting Context Data into MongoDB](#persisting-context-data-into-mongodb)
-   [Persisting Context Data into MySQL](#persisting-context-data-into-mysql)
-   [Persisting Context Data into PostgreSQL](#persisting-context-data-into-postgresql)
-   [Persisting Context Data into Elasticsearch](#persisting-context-data-into-elasticsearch)
-   [Examples](#examples)
-   [Related information](#related-information)

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name               | Description                                                                                                       | Default value     |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------- |
| CYGNUS                      | A sub-domain name of Cygnus                                                                                       | (empty)           |
| CYGNUS\_MONGO               | Use MongoDB sink for Cygnus. true or false                                                                        | false             |
| CYGNUS\_MYSQL               | Use MySQL sink for Cygnus. true or false                                                                          | false             |
| CYGNUS\_POSTGRES            | Use PostgreSQL sink for Cygnus. true or false                                                                     | false             |
| CYGNUS\_ELASTICSEARCH       | Use Elasticsearch sink for Cygnus. true or false                                                                  | false             |
| CYGNUS\_EXPOSE\_PORT        | Expose port for Cygnus. (none, local, all) 5051 for Mongo, 5050 for MySQL, 5055 for Postgres, 5058 for PostgreSQL | none              |
| CYGNUS\_LOG\_LEVEL          | Set logging level for Cygnus. (INFO, DEBUG)                                                                       | info              |
| ELASTICSEARCH               | A sub-domain name of Elasticsearch                                                                                | (empty)           |
| ELASTICSEARCH\_JAVA\_OPTS   | Set Java options for Elasticsearch                                                                                | -Xmx256m -Xms256m |
| ELASTICSEARCH\_EXPOSE\_PORT | Expose port (none, local, all) for Elasticsearch                                                                  | none              |

## How to setup

To set up Cygnus, configure some environment variables in config.sh.

First, set a sub-domain name for Cygnus to `CYGNUS=` as shown:

```bash
CYGNUS=cygnus
```

And set one or more databases used for storing persistent data to `true`:

```bash
CYGNUS_MONGO=
CYGNUS_MYSQL=
CYGNUS_POSTGRES=
CYGNUS_ELASTICSEARCH=
```

When using Elasticsearch, set a sub-domain name for Elasticsearch as shown:

```bash
ELASTICSEARCH=elasticsearch
```

## Sanity check for Cygnus

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

## Persisting Context Data into MongoDB

### Subscribing to Context Changes

Create a subscription to notify Cygnus of changes in context and store it into MongoDB.

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

### Reading historical data from MongoDB

To read MongoDB data from the command line, you need to be in a MongoDB container.

#### Command:

```bash
docker-compose exec mongo bash
```

#### Result:

```bash
root@15101e538fde:/# 
```

Then, run the MongoDB shell.

#### Command:

```text
mongo 
```

#### Result:

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

To show the list of available databases, run the statement as shown:

#### Query:

```text
show dbs
```

#### Result:

```text
admin          0.000GB
config         0.000GB
local          0.000GB
orion          0.000GB
orion-openiot  0.000GB
orionld        0.000GB
sth_openiot    0.000GB
```

Switch to a database you want to access:

#### Query:

```text
use sth_openiot
```

#### Result:

```text
switched to db sth_openiot
```

List collections in the databases:

#### Query:

```text
show collections
```

#### Result:

```text
sth_/_device001_device
sth_/_device001_device.aggr
```

Read historical data by running the following query:

#### Query:

```text
db["sth_/_device001_device"].find().limit(10)
```

#### Result:

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

## Persisting Context Data into MySQL

### Subscribing to Context Changes

Create a subscription to notify Cygnus of changes in context and store it into MySQL.

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

### Reading historical data from MySQL

To read MySQL data from the command line, you need to be in a MySQL container.

#### Command:

```bash
docker-compose exec mysql bash
```

#### Result:

```bash
root@898cef135030:/#
```

Then, run the MySQL shell.

#### Command:

```bash
root@898cef135030:/# mysql -uroot -p
```

#### Result:

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

To show the list of available databases, run the statement as shown:

#### Query:

```
show databases;
```

#### Result:

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

Switch to a database you want to access:

#### Query:

```text
use openiot;
```

#### Result:

```text
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
```

List tables in the databases:

#### Query:

```text
show tables;
```

#### Result:

```text
+-------------------+
| Tables_in_openiot |
+-------------------+
| device001_device  |
+-------------------+
1 row in set (0.01 sec)
```

Read historical data by running the following query:

#### Query:

```text
SELECT * FROM openiot.device001_device;
```

#### Result:

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

## Persisting Context Data into PostgreSQL

### Subscribing to Context Changes

Create a subscription to notify Cygnus of changes in context and store it into PostgreSQL.

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

### Reading historical data from PostgreSQL 

To read PostgreSQL data from the command line, you need to be in a PostgreSQL container.

#### Command:

```bash
docker-compose exec postgres bash
```

#### Result:

```bash
root@72b468efeb11:/#
```

Then, run the psql shell.

#### Command:

```bash
psql -U postgres
```

#### Result:

```text
psql (11.13 (Debian 11.13-1.pgdg90+1))
Type "help" for help.
```

To show the list of available databases, run the statement as shown:

#### Query:

```text
\l
```

#### Result:

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

To show the list of available schemas, run the statement as shown:

#### Query:

```text
\dn
```

#### Result:

```text
  List of schemas
  Name   |  Owner   
---------+----------
 openiot | postgres
 public  | postgres
(2 rows)
```

To show the list of available tables, run the statement as shown:

#### Query:

```text
SELECT table_schema,table_name FROM information_schema.tables WHERE table_schema ='openiot' ORDER BY table_schema,table_name;
```

#### Result:

```text
 table_schema |    table_name    
--------------+------------------
 openiot      | device001_device
(1 row)
```

Read historical data by running the following query:

#### Query:

```text
SELECT * FROM openiot.device001_device;
```

#### Result:

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

## Persisting Context Data into Elasticsearch

### Subscribing to Context Changes

Create a subscription to notify Cygnus of changes in context and store it into Elasticsearch.

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

### Reading historical data from Elasticsearch

To read Elasticsearch from the command line, you need to set OAuth2 token to an environment variable `TOKEN` as shown:

```bash
export TOKEN=`ngsi token --host orion.example.com`
```

To show the list of available databases, run the statement as shown:

#### Query:

```bash
curl -sXGET 'https://elasticsearch.example.com/_cat/indices?v&pretty' -H "Authorization: Bearer $TOKEN"
```

#### Result:

```text
health status index                                       pri rep docs.count docs.deleted store.size pri.store.size 
yellow open   cygnus-openiot--device001-device-2021.11.05   5   1         10            0     35.7kb         35.7kb 
```

Read historical data by running the following query:

#### Query:

```
curl -sXGET "https://elasticsearch.example.com/_sql?format=json" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $TOKEN" \
-d'
{
  "query": " select * from \"cygnus-openiot--device001-device-2021.11.05\" limit 2 "
}'
```

#### Result:

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

## Examples

Look at examples [here](https://github.com/fisuda/FIWARE-Big-Bang/tree/update/documentaion/examples/cygnus).

## Related information

-   [FIWARE Cygnus documentation](https://fiware-cygnus.readthedocs.io/en/latest/)
-   [FIWARE Cygnus - GitHub](https://github.com/telefonicaid/fiware-cygnus)
-   [Persisting context (Apache Flume) - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/historic-context-flume.html)
