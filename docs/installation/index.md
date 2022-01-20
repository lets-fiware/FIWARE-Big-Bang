# Installation

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Supported FIWARE GEs and third-party open source software](#supported-fiware-ges-and-third-party-open-source-software)
-   [Requirements](#requirements)
-   [Prerequisite](#prerequisite)
-   [Getting Started](#getting-started)
-   [Command syntax](#command-syntax)
-   [Configuration](#configuration)
-   [Multi-server installation](#multi-server-installation)
-   [Expose ports](#expose-ports)
-   [Examples](#examples)

</details>

## Supported FIWARE GEs and third-party open source software

### Supported FIWARE GEs

-   Keyrock
-   Wilma
-   Orion
-   Cygnus
-   Comet
-   Perseo
-   QuantumLeap
-   WireCloud
-   Ngsiproxy
-   IoT Agent for UltraLight (over HTTP and MQTT)
-   IoT Agent for JSON (over HTTP and MQTT)

### Supported third-party open source software

-   Node-RED
-   Grafana (Experimental support)
-   Mosquitto
-   Elasticsearch (as a database for persitenting context data)

## Requirements

### Virtual machine

A virtual machine with a public IP address (global IP address) or a virtual machine that can be accessed
from the Internet via a network equipment

### Supported Linux distribution

The FIWARE Big Bang supports CentOS and Ubuntu as Linux distribution.
The recommended Linux distribution is Ubuntu 20.04.

-   Ubuntu 20.04
-   Ubuntu 18.04
-   CentOS 7, 8

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

```bash
curl -sL https://github.com/lets-fiware/FIWARE-Big-Bang/archive/refs/tags/v0.10.0.tar.gz | tar zxf -
```

Move to the `FIWARE-Big-Bang-0.10.0` directory.

```bash
cd FIWARE-Big-Bang-0.10.0/
```

Run the `lets-fiware.sh` script with your own domain name and a public IP address.

```bash
./lets-fiware.sh example.com XX.XX.XX.XX
```

## Command syntax

The `lets-fiware.sh` command accepts two arguments. The first argument is a domain name. The second one is
a public IP address. It can be omitted when your virtual machine has a public IP address.

```bash
./lets-fiware.sh DOMAIN_NAME [PUBLIC_IP_ADDRESS]
```

Examples:

-   ./lets-fiware.sh example.com
-   ./lets-fiware.sh example.com XX:XX:XX:XX

## Configuration

You can specify configurations by editing the `config.sh` file.
Please see each documentation for details as below:

-   [Keyrock](keyrock.md)
-   [Orion](orion.md)
-   [Cygnus](cygnus.md)
-   [Comet](comet.md)
-   [Perseo](perseo.md)
-   [Quantumleap](quantumleap.md)
-   [IoT Agent for UltraLight](iotagent-ul.md)
-   [IoT Agent for JSON](iotagent-json.md)
-   [WireCloud](wirecloud.md)
-   [Node-RED](node-red.md)
-   [Grafana](grafana.md) (Experimental support)
-   [Regproxy](regproxy.md)
-   [Queryproxy](queryproxy.md)
-   [Certbot](certbot.md)
-   [Firewall](firewall.md)

## Multi-server installation

The multi-server installation allows to install FIWARE GEs and other OSS to multiple servers.
Please see [this documentation](multi_server.md) for details.

## Expose ports

Some FIWARE GEs and other OSS running in a Docker container can expose a port for their service.
Please see [this documentation](expose-ports.md) for details.

## Examples

Configuration examples are as shown:

### Examples 1

Configure Orion Context broker.

```bash
KEYROCK=keyrock
ORION=orion
```

### Examples 2

To store persistent context data to PostgreSQL, configure Cygnus and PostgreSQL.

```bash
KEYROCK=keyrock
ORION=orion
CYGNUS=cygnus
CYGNUS_POSTGRES=true
```

### Examples 3

To persists Time Series Context Data, configure Comet and Cygnus.

```bash
KEYROCK=keyrock
ORION=orion
COMET=comet
CYGNUS=cygnus
```

### Examples 4

Configure IoT Agent for UltraLight 2.0 over HTTP with basic authentication.

```bash
KEYROCK=keyrock
ORION=orion
IOTAGENT_UL=iotagent-ul
IOTAGENT_HTTP=iotagent-http
IOTA_HTTP_AUTH=basic
```
### Examples 5

Configure IoT Agent for UltraLight 2.0 over MQTT TLS.

```bash
KEYROCK=keyrock
ORION=orion
IOTAGENT_JSON=iotagent-json
MOSQUITTO=mosquitto
MQTT_TLS=true
```

### Examples 6

Configure WireCloud.

```bash
KEYROCK=keyrock
ORION=orion
WIRECLOUD=wirecloud
NGSIPROXY=ngsiproxy
```

### Examples 7

Configure Node-RED..

```bash
KEYROCK=keyrock
ORION=orion
NODE_RED=node-red
```
