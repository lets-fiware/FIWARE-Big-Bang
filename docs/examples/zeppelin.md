# Apache Zeppelin (Experimental support)

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Sanity check for Zeppelin](#sanity-check-for-zeppelin)
-   [Print historical data on Zeppelin notebook](#print-historical-data-on-zeppelin-notebook)

</details>

## Sanity check for Zeppelin

Once Zeppelin is running, you can access the Zeppelin web application.
Open at `https://zeppelin.example.com` to access the Zeppelin GUI.
You will be redirected to the Keyrock login page.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-01.jpg)

Once you have logged in, you will be redirected to the Zeppelin GUI.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-02.jpg)

### Get Zeppelin version

You can get the Zeppelin version by the following command:

#### Request:

```bash
curl -s https://zeppelin.example.com/api/version
```

#### Response:

```json
{
  "status": "OK",
  "message": "Zeppelin version",
  "body": {
    "git-commit-id": "",
    "git-timestamp": "",
    "version": "0.9.0"
  }
}
```

## Print historical data on Zeppelin notebook

### Setup instance

First, setup Orion, Cygnus and Zeppelin as shown:

```
ORION=orion
CYGNUS=cygnus
CYGNUS_MONGO=true
ZEPPELIN=zeppelin
```

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

### Reading historical data from MongoDB on notebook

Open the `FIWARE Big Bang Example` notebook from Notebook menu.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-03.jpg)

You can read historical data from MongoDB by the following script.

```
%mongodb
db["sth_/_device001_device"].find({},{attrValue:1,recvTime:1}).table()
```

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-04.jpg)

Run the paragraph on the notebook.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-05.jpg)

You will see a historical data on the notebook.

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-06.jpg)

#### Bar Chart

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-07.jpg)

#### Pie Chart

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-08.jpg)

#### Area Chart

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-09.jpg)

#### Line Chart

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-10.jpg)

#### Scatter Chart

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-11.jpg)
