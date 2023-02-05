# IoT Agent for UltraLight 2.0

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [構成パラメータ](#configuration-parameters)
    -   [IoT Agent for UL over MQTT](#iot-agent-for-ul-over-mqtt)
    -   [IoT Agent for UL over HTTP](#iot-agent-for-ul-over-http)
-   [設定方法](#how-to-setup)
    -   [IoT Agent for UL over MQTT](#iot-agent-for-ul-over-mqtt-1)
    -   [IoT Agent for UL over HTTP](#iot-agent-for-ul-over-http-1)
-   [関連情報](#related-information)

</details>

<a name="configuration-parameters"></a>

## 構成パラメータ

`config.sh` ファイルを編集して IoT Agent for JSON の構成を指定できます。

| 変数名                      | 説明                                                                                              | 既定値  |
| --------------------------- | ------------------------------------------------------------------------------------------------- | ------- |
| IOTAGENT\_UL                | IoT Agent for UltraLight 2.0 のサブドメイン名                                                     | (なし)  |
| IOTA\_UL\_DEFAULT\_RESOURCE | IoT Agent for UltraLight 2.0 が測定値のリッスンに使用するデフォルト・パス                         | /iot/ul |
| IOTA\_UL\_TIMESTAMP         | 接続されたデバイスから受信した各測定値にタイムスタンプ情報を付与するかどうか。(true または false) | true    |
| IOTA\_UL\_AUTOCAST          | JSON の数値を文字列ではなく数値として読み取るかどうか。(true または false)                        | true    |

<a name="iot-agent-for-ul-over-mqtt"></a>

### IoT Agent for UL over MQTT

| 変数名     | 説明                                                 | 既定値 |
| ---------- | ---------------------------------------------------- | ------ |
| MOSQUITTO  | Mosquitto サブドメイン名                             | (なし) |
| MQTT\_1883 | MQTT ポート 1883 を使用する。(true または false)     | false  |
| MQTT\_TLS  | MQTT TLS ポート 8883 を使用する。(true または false) | true   |

<a name="iot-agent-for-ul-over-http"></a>

### IoT Agent for UL over HTTP

| 変数名                  | 説明                                                            | 既定値     |
| ----------------------- | --------------------------------------------------------------- | ---------- |
| IOTAGENT\_HTTP          | IoT Agent for UL over HTTP を使用するためのサブドメイン名を設定 | (なし)     |
| IOTA\_HTTP\_AUTH        | IoT Agent for UL over HTTP の認証 (none, basic または bearer)   | bearer     |
| IOTA\_HTTP\_BASIC\_USER | IoT Agent for UL over HTTP の Basic 認証のユーザ                | fiware     |
| IOTA\_HTTP\_BASIC\_PASS | IoT Agent for UL over HTTP の Basic 認証のパスワード            | (自動生成) |

<a name="how-to-setup"></a>

## 設定方法

<a name="iot-agent-for-ul-over-mqtt-1"></a>

### IoT Agent for UL over MQTT

IoT Agent for UL over MQTT をセットアップするには、config.sh の環境変数を構成します。

まず、次のように、IoT Agent と Mosquitto のサブドメイン名を `IOTAGENT_UL=` と `MOSQUITTO=` に設定します:

```bash
IOTAGENT_UL=iotagent-ul
MOSQUITTO=mosquitto
```

Mosquitto のリスナーに使用するポートを指定するには、`MQTT_1883=` および/または `MQTT_TLS=` を true
に設定します。デフォルトのリスナーは 8883 ポート (TLS) です。

```bash
MQTT_1883=
MQTT_TLS=
```

<a name="iot-agent-for-ul-over-http-1"></a>

### IoT Agent for UL over HTTP

IoT Agent for UL over HTTP をセットアップするには、config.sh の環境変数を構成します。

まず、次のように、IoT Agent と HTTP のサブドメイン名を `IOTAGENT_UL=` と `IOTAGENT_HTTP=` に設定します:

```bash
IOTAGENT_UL=iotagent-ul
IOTAGENT_HTTP=iotagent-http
```

サウスバウンドの HTTP は、ポート 443 (HTTPS) を使用します。

認証タイプを指定するには、または `IOTA_HTTP_AUTH` に `none`, `basic` または `bearer` を設定します。
デフォルト値は `bearer` です。

Basic 認証を使用する場合は、ユーザ名とパスワードを設定する必要があります。指定しない場合は、
デフォルト値が使用されます。デフォルトのユーザ名は fiware です。デフォルトのパスワードは自動的に生成されます。

```bash
IOTA_HTTP_BASIC_USER=
IOTA_HTTP_BASIC_PASS=
```

<a name="related-information"></a>

## 関連情報

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
