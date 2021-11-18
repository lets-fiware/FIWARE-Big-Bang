# Installation

### Supported Linux distribution

The FIWARE Big Bang supports CentOS and Ubuntu as Linux distribution.
The recommended Linux distribution is Ubuntu 20.04.

-   Ubuntu 20.04
-   Ubuntu 18.04
-   CentOS 7, 8

## Supported FIWARE GEs and third-party open source software

### Supported FIWARE GEs

-   Keyrock
-   Wilma
-   Orion
-   Cygnus
-   Comet
-   QuantumLeap
-   WireCloud
-   Ngsiproxy
-   IoT Agent for UltraLight (over HTTP and MQTT)
-   IoT Agent for JSON (over HTTP and MQTT)
-   Perseo

### Supported third-party open source software

-   Node-RED
-   Grafana (Experimental support)
-   Mosquitto
-   Elasticsearch (as a database for persitenting context data)

## Requirements

### Virtual machine

A virtual machine with a public IP address (global IP address) or a virtual machine that can be accessed
from the Internet via a network equipment

### Domain name

An own domain name is needed to access Web Applications and APIs with a domain name.
You can access each Web Application or API with a sub-domain name.

### Ports exposed on the internet

The Web Applications and APIs installed by FIWARE Big Bang uses some ports.

-   Port 443 (HTTPS) is used by Web Applications and APIs
-   Port 80 (HTTP) is used to get Let's encrypt Server certificates
-   Port 1883 is used by Mosquitto when enabling MQTT
-   Port 8883 is used by Mosquitto when enabling MQTT TLS

## Prerequisite

Before running the setup script, you need to register sub-domain names of FIWARE GEs in DNS using A records
or CNAME records.

-   keyrock.example.com
-   orion.example.com

## Getting Started

Download a tar.gz file for the FIWARE Big Bang.

```
curl -sL https://github.com/lets-fiware/FIWARE-Big-Bang/archive/refs/tags/v0.7.0.tar.gz | tar zxf -
```

Move to the `FIWARE-Big-Bang-0.7.0` directory.

```
cd FIWARE-Big-Bang-0.7.0/
```

Run the `lets-fiware.sh` script with your own domain name and a public IP address.

```
./lets-fiware.sh example.com XX.XX.XX.XX
```

## Command syntax

The `lets-fiware.sh` command accepts two arguments. The first argument is a domain name. The second one is
a public IP address. It can be omitted when your virtual machine has a public IP address.

```
./lets-fiware.sh DOMAIN_NAME [PUBLIC_IP_ADDRESS]
```

Examples:

-   ./lets-fiware.sh example.com
-   ./lets-fiware.sh example.com XX:XX:XX:XX

## Configuration

You can specify configurations by editing the `config.sh` file.

### Keyrock

| Variable name     | Description                                                      | Default value                   |
| ----------------- | ---------------------------------------------------------------- | ------------------------------- |
| KEYROCK           | A sub-domain name of Keyrock (Required)                          | keyrock                         |
| IDM\_ADMIN\_NAME  | A name of an admin user for Keyrock                              | admin                           |
| IDM\_ADMIN\_EMAIL | An email address of an admin user for Keyrock                    | IDM\_ADMIN\_NAME @ DOMAIN\_NAME |
| IDM\_ADMIN\_PASS  | A password of an admin user for Keyrock                          | (Automatically generated)       |
| KEYROCK\_POSTGRES | Use PostgreSQL as backend database for Keyrock. (true or false)  | false                           |

### Orion

| Variable name | Description                           | Default value |
| ------------- | ------------------------------------- | ------------- |
| ORION         | A sub-domain name of Orion (Required) | orion         |

### Cygnus

| Variable name         | Description                                      | Default value |
| --------------------- | ------------------------------------------------ | ------------- |
| CYGNUS                | A sub-domain name of Cygnus                      | (empty)       |
| ELASTICSEARCH         | A sub-domain name of Elasticsearch               | (empty)       |
| CYGNUS\_MONGO         | Use MongoDB sink for Cygnus. true or false       | false         |
| CYGNUS\_MYSQL         | Use MySQL sink for Cygnus. true or false         | false         |
| CYGNUS\_POSTGRES      | Use PostgreSQL sink for Cygnus. true or false    | false         |
| CYGNUS\_ELASTICSEARCH | Use Elasticsearch sink for Cygnus. true or false | false         |

### Comet

| Variable name | Description                | Default value |
| ------------- | -------------------------- | ------------- |
| COMET         | A sub-domain name of Comet | (empty)       |

### Quantumleap

| Variable name | Description                      | Default value |
| ------------- | -------------------------------- | ------------- |
| QUANTUMLEAP   | A sub-domain name of QuantumLeap | (empty)       |

### IoT Agent (Common to UltraLight and JSON)

| Variable name           | Description                                                    | Default value             |
| ----------------------- | -------------------------------------------------------------- | ------------------------- |
| MOSQUITTO               | A sub-domain name of MOSQUITTO                                 | (empty)                   |
| MQTT\_1883              | Use MQTT 1883 Port. true or false                              | false                     |
| MQTT\_TLS               | Use MQTT TLS. true or false                                    | true                      |
| IOTAGENT\_HTTP          | Set a sub-domain name to use IoT Agent over HTTP.              | (empty)                   |
| IOTA\_HTTP\_AUTH        | Authorization for IoT Agent over HTTP. (none, basic or bearer) | bearer                    |
| IOTA\_HTTP\_BASIC\_USER | User for Basic authorization for IoT Agent over HTTP.          | fiware                    |
| IOTA\_HTTP\_BASIC\_PASS | Password for Basic authorization for IoT Agent over HTTP.      | (Automatically generated) |

### IoT Agent for UltraLight

| Variable name               | Description                                                                                   | Default value |
| --------------------------- | --------------------------------------------------------------------------------------------- | ------------- |
| IOTAGENT\_UL                | A sub-domain name of IoT Agent for UltraLight 2.0                                             | (empty)       |
| IOTA\_UL\_DEFAULT\_RESOURCE | The default path the IoT Agent uses listening for UltraLight measures.                        | /iot/ul       |
| IOTA\_UL\_TIMESTAMP         | Whether to supply timestamp information with each measurement received from attached devices. | true          |
| IOTA\_UL\_AUTOCAST          | Ensure JSON number values are read as numbers not strings                                     |               |

### IoT Agent for JSON

| Variable name                 | Description                                                                                   | Default value |
| ----------------------------- | --------------------------------------------------------------------------------------------- | ------------- |
| IOTAGENT\_JSON                | A sub-domain name of IoT Agent for JSON                                                       | (empty)       |
| IOTA\_JSON\_DEFAULT\_RESOURCE | The default path the IoT Agent uses listening for JSON measures.                              | /iot/json     |
| IOTA\_JSON\_TIMESTAMP         | Whether to supply timestamp information with each measurement received from attached devices. | true          |
| IOTA\_JSON\_AUTOCAST          | Ensure JSON number values are read as numbers not strings                                     |               |

### Perseo

| Variable name        | Description                                                      | Default value |
| -------------------- | ---------------------------------------------------------------- | ------------- |
| PERSEO               | A sub-domain name of Perseo                                      | (empty)       |
| PERSEO\_MAX\_AGE     | The expiration time for dangling rules in milliseconds.          | 6000          |
| PERSEO\_SMTP\_HOST   | Host of the SMTP server for Perseo.                              | (empty)       |
| PERSEO\_SMTP\_PORT   | Port of the SMTP server for Perseo.                              | (empty)       |
| PERSEO\_SMTP\_SECURE | true if SSL should be used with the SMTP server. (true or false) | (empty)       |
| PERSEO\_LOG\_LEVEL   | Log level for Perseo.                                            | info          |

### WireCloud

| Variable name | Description                    | Default value |
| ------------- | ------------------------------ | ------------- |
| WIRECLOUD     | A sub-domain name of WireCloud | (empty)       |
| NGSIPROXY     | A sub-domain name of Ngsiproxy | (empty)       |

### Node-RED

| Variable name                   | Description                      | Default value |
| ------------------------------- | -------------------------------- | ------------- |
| NODE\_RED                       | A sub-domain name of Node-RED    | (empty)       |
| NODE\_RED\_INSTANCE\_NUMBER     | Number of Node-RED instance.     | 1             |
| NODE\_RED\_INSTANCE\_USERNAME   | Username for Node-RED instance.  | node-red      |
| NODE\_RED\_INSTANCE\_HTTP\_ROOT | HTTP root for Node-RED instance. | /node-red     |

### Grafana (Experimental support)

| Variable name | Description                  | Default value |
| ------------- | ---------------------------- | ------------- |
| GRAFANA       | A sub-domain name of Grafana | (empty)       |

### Queryproxy

| Variable name | Description                   | Default value |
| ------------- | ----------------------------- | ------------- |
| QUERYPROXY    | Use queryproxy. true or false | false         |

### Regproxy

| Variable name            | Description                            | Default value |
| ------------------------ | -------------------------------------- | ------------- |
| REGPROXY                 | Use regproxy. true or false            | false         |
| REGPROXY\_NGSITYPE       | NgsiType for remote broker. (v2 or ld) | v2            |
| REGPROXY\_HOST           | Host for remote broker.                | (empty)       |
| REGPROXY\_IDMTYPE        | IdM type for remote broker.            | (empty)       |
| REGPROXY\_IDMHOST        | IdM host for remote broker.            | (empty)       |
| REGPROXY\_USERNAME       | A username for remote broker.          | (empty)       |
| REGPROXY\_PASSWORD       | A password for remote broker.          | (empty)       |
| REGPROXY\_CLIENT\_ID     | A client id for remote broker.         | (empty)       |
| REGPROXY\_CLIENT\_SECRET | A client secret for remote broker.     | (empty)       |

### Postfix

| Variable name | Description                                   | Default value |
| ------------- | --------------------------------------------- | ------------- |
| POSTFIX       | Use Postfix (local delivery). (true or false) | false         |

### Firewall

| Variable name | Description                    | Default value |
| ------------- | ------------------------------ | ------------- |
| FIREWALL      | Enable firewall. true or false | false         |

### Certbot

| Variable name        | Description                                         | Default value                                   |
| -------------------- | --------------------------------------------------- | ----------------------------------------------- |
| CERT\_EMAIL          | An email address for certbot                        | (An email address of an admin user for Keyrock) |
| CERT\_REVOKE         | Revoke and reacquire the certificate. true or false | false                                           |
| CERT\_TEST           | Use --test-cert option. true or false               | false                                           |
| CERT\_FORCE\_RENEWAL | Use --force-renewal option. true or false           | false                                           |

## Copyright and License

Copyright (c) 2021 Kazuhito Suda<br>
Licensed under the MIT License.
