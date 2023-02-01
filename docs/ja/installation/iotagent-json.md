# IoT Agent for JSON

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [構成パラメータ](#configuration-parameters)
    -   [IoT Agent for JSON over MQTT](#iot-agent-for-json-over-mqtt)
    -   [IoT Agent for JSON over HTTP](#iot-agent-for-json-over-http)
-   [設定方法](#how-to-setup)
    -   [IoT Agent for JSON over MQTT](#iot-agent-for-json-over-mqtt-1)
    -   [IoT Agent for JSON over HTTP](#iot-agent-for-json-over-http-1)
-   [関連情報](#related-information)

</details>

<a name="configuration-parameters"></a>

## 構成パラメータ

`config.sh` ファイルを編集して IoT Agent for JSON の構成を指定できます。

| 変数名                        | 説明                                                                                              | 既定値    |
| ----------------------------- | ------------------------------------------------------------------------------------------------- | --------- |
| IOTAGENT\_JSON                | IoT Agent for JSON のサブドメイン名                                                               | (なし)    |
| IOTA\_JSON\_DEFAULT\_RESOURCE | IoT Agent for JSON が測定値のリッスンに使用するデフォルト・パス                                   | /iot/json |
| IOTA\_JSON\_TIMESTAMP         | 接続されたデバイスから受信した各測定値にタイムスタンプ情報を付与するかどうか。(true または false) | true      |
| IOTA\_JSON\_AUTOCAST          | JSON の数値を文字列ではなく数値として読み取るかどうか。(true または false)                        | true      |

<a name="iot-agent-for-json-over-mqtt"></a>

### IoT Agent for JSON over MQTT

| 変数名     | 説明                                                 | 既定値 |
| ---------- | ---------------------------------------------------- | ------ |
| MOSQUITTO  | Mosquitto サブドメイン名                             | (なし) |
| MQTT\_1883 | MQTT ポート 1883 を使用する。(true または false)     | false  |
| MQTT\_TLS  | MQTT TLS ポート 8883 を使用する。(true または false) | true   |

<a name="iot-agent-for-json-over-http"></a>

## IoT Agent for JSON over HTTP

| 変数名                  | 説明                                                     | 既定値     |
| ----------------------- | -------------------------------------------------------- | ---------- |
| IOTAGENT\_HTTP          | IoT Agent over HTTP を使用するためのサブドメイン名を設定 | (なし)     |
| IOTA\_HTTP\_AUTH        | IoT Agent over HTTP の認証 (none, basic または bearer)   | bearer     |
| IOTA\_HTTP\_BASIC\_USER | IoT Agent over HTTP の Basic 認証のユーザ                | fiware     |
| IOTA\_HTTP\_BASIC\_PASS | IoT Agent over HTTP の Basic 認証のパスワード            | (自動生成) |

<a name="how-to-setup"></a>

## 設定方法

<a name="iot-agent-for-json-over-mqtt-1"></a>

### IoT Agent for JSON over MQTT

IoT Agent for JSON over MQTT をセットアップするには、config.sh の環境変数を構成します。

まず、次のように、IoT Agent と Mosquitto のサブドメイン名を `IOTAGENT_JSON=` と `MOSQUITTO=`
に設定します:

```bash
IOTAGENT_JSON=iotagent-json
MOSQUITTO=mosquitto
```

Mosquitto のリスナーに使用するポートを指定するには、`MQTT_1883=` および/または `MQTT_TLS=`
を true に設定します。デフォルトのリスナーは 8883 ポート (TLS) です。

```bash
MQTT_1883=
MQTT_TLS=
```

<a name="iot-agent-for-json-over-http-1"></a>

### IoT Agent for JSON over HTTP

IoT Agent for JSON over HTTP をセットアップするには、config.sh の環境変数を構成します。

まず、次のように、IoT Agent と HTTP のサブドメイン名を `IOTAGENT_JSON=` と `IOTAGENT_HTTP=`
に設定します:

```bash
IOTAGENT_JSON=iotagent-json
IOTAGENT_HTTP=iotagent-http
```

サウスバウンドの HTTP は、ポート 443 (HTTPS) を使用します。

認証タイプを指定するには、または `IOTA_HTTP_AUTH` に `none`, `basic` または `bearer` を設定します。
デフォルト値は `bearer` です。

Basic 認証を使用する場合は、ユーザ名とパスワードを設定する必要があります。指定しない場合は、
デフォルト値が使用されます。デフォルトのユーザ名は `fiware` です。デフォルトのパスワードは自動的に生成されます。

```bash
IOTA_HTTP_BASIC_USER=
IOTA_HTTP_BASIC_PASS=
```

<a name=""></a>

## 関連情報

-   [iotagent-json - GitHub](https://github.com/telefonicaid/iotagent-json)
-   [iotagnet-node-lib - GitHub](https://github.com/telefonicaid/iotagent-node-lib)
-   [iotagent-json - Read the docs](https://fiware-iotagent-json.readthedocs.io/en/latest/)
-   [iotagent-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent configuration API - Apiary](https://telefonicaiotiotagents.docs.apiary.io/#reference/configuration-api)
-   [iotagnet-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent for JSON - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-agent-json.html)
-   [IoT Agent over MQTT - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt.html)
-   [NGSI Go tutorial for IoT Agent](https://ngsi-go.letsfiware.jp/tutorial/iot-agent/)
-   [telefonicaiot/iotagent-json - Docker Hub](https://hub.docker.com/r/telefonicaiot/iotagent-json)
