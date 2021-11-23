# IoT Agent for UltraLight 2.0

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
    -   [IoT Agent for UL over MQTT](#iot-agent-for-ul-over-mqtt)
    -   [IoT Agent for UL over HTTP](#iot-agent-for-ul-over-http)
-   [Related information](#related-information)

## Configuration parameters

You can specify configurations for IoT Agent for UL by editing the `config.sh` file.

| Variable name               | Description                                                                                                   | Default value |
| --------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------- |
| IOTAGENT\_UL                | A sub-domain name of IoT Agent for UltraLight 2.0                                                             | (empty)       |
| IOTA\_UL\_DEFAULT\_RESOURCE | The default path the IoT Agent uses listening for UltraLight measures.                                        | /iot/ul       |
| IOTA\_UL\_TIMESTAMP         | Whether to supply timestamp information with each measurement received from attached devices. (true or false) | true          |
| IOTA\_UL\_AUTOCAST          | Ensure JSON number values are read as numbers not strings. (true or false)                                    | true          |

### IoT Agent for UL over MQTT

| Variable name | Description                             | Default value |
| ------------- | --------------------------------------- | ------------- |
| MOSQUITTO     | A sub-domain name of Mosquitto          | (empty)       |
| MQTT\_1883    | Use MQTT Port 1883. true or false       | false         |
| MQTT\_TLS     | Use MQTT TLS (Port 8883). true or false | true          |

### IoT Agent for UL over HTTP

| Variable name           | Description                                                    | Default value             |
| ----------------------- | -------------------------------------------------------------- | ------------------------- |
| IOTAGENT\_HTTP          | Set a sub-domain name to use IoT Agent over HTTP.              | (empty)                   |
| IOTA\_HTTP\_AUTH        | Authorization for IoT Agent over HTTP. (none, basic or bearer) | bearer                    |
| IOTA\_HTTP\_BASIC\_USER | User for Basic authorization for IoT Agent over HTTP.          | fiware                    |
| IOTA\_HTTP\_BASIC\_PASS | Password for Basic authorization for IoT Agent over HTTP.      | (Automatically generated) |

## How to setup

### IoT Agent for UL over MQTT

To set up IoT Agent for UL over MQTT, configure some environment variables in config.sh.

First, set a sub-domain name for IoT Agent to `IOTAGENT_UL` and `MOSQUITTO` as shown:

```bash
IOTAGENT_UL=iotagent-ul
MOSQUITTO=mosquitto
```

To specify ports to use for the listener of Mosquitto, set `MQTT_1883` and/or `MQTT_TLS` to true.
The default listener is 8883 port (TLS).

```bash
MQTT_1883=
MQTT_TLS=
```

### IoT Agent for UL over HTTP

To set up IoT Agent for UL over HTTP, configure some environment variables in config.sh.

First, set a sub-domain name for IoT Agent to `IOTAGENT_UL` and `IOTAGENT_HTTP` as shown:

```bash
IOTAGENT_UL=iotagent-ul
IOTAGENT_HTTP=iotagent-http
```

The HTTP for southbound uses the port 443 (HTTPS). 

To specify an authorization type, set `IOTA_HTTP_AUTH` to `none`, `basic` or `bearer`.
The default value is `bearer`.

It is necessary to set a username and a password when using the basic authorization.
If not specified, the default value be used. The default username is `fiware`. The default
password is automatically generated.

```bash
IOTA_HTTP_BASIC_USER=
IOTA_HTTP_BASIC_PASS=
```

## Related information

-   [iotagent-ul - GitHub](https://github.com/telefonicaid/iotagent-ul)
-   [iotagnet-node-lib - GitHub](https://github.com/telefonicaid/iotagent-node-lib)
-   [iotagent-ul - Read the docs](https://fiware-iotagent-ul.readthedocs.io/en/latest/)
-   [iotagent-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent configuration API - Apiary](https://telefonicaiotiotagents.docs.apiary.io/#reference/configuration-api)
-   [iotagnet-node-lib - Read the docs](https://iotagent-node-lib.readthedocs.io/en/latest/)
-   [IoT Agent for UltraLight - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-agent.html)
-   [IoT Agent over MQTT - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt.html)
-   [NGSI Go tutorial for IoT Agent](https://ngsi-go.letsfiware.jp/tutorial/iot-agent/)
