# Install

## Requirements

-   A virtual machine with a global IP address
-   A domain name
-   Supported Linux distribution:
    -   Ubuntu 18.04, 20.04
    -   CentOS 7, 8
-   Supported FIWARE GEs:
    -   Keyrock
    -   Wilma
    -   Orion
    -   Cygnus
    -   Comet
    -   QuantumLeap
    -   WireCloud
    -   Ngsiproxy
    -   IoT Agent for UltraLight 2.0
-   Supported third party OSS:
    -   Node-RED
    -   Grafana

## Prerequisite

Before running the setup script, you need to register sub-domain names of FIWARE GEs that you want to use as shown:

-   keyrock.example.com
-   orion.example.com
-   wirecloud.example.com
-   ngsiproxy.example.com

## Getting Started

Clone the FIWARE Big Bang repository and run the `lets-fiware.sh` script with your domain name.

```
curl -sL https://github.com/lets-fiware/FIWARE-Big-Bang/archive/refs/tags/v0.6.0.tar.gz | tar zxf -
cd FIWARE-Big-Bang-0.6.0/
./lets-fiware.sh example.com
```

## Command syntax

The `lets-fiware.sh` command accepts two arguments. The first argument is a domain name. The second one is
a global IP address. It's an optional.

```
./lets-fiware.sh DOMAIN_NAME [GLOBAL_IP_ADDRESS]
```

Examples:

-   ./lets-fiware.sh example.com
-   ./lets-fiware.sh example.com XX:XX:XX:XX

## Configuration

You can specify configurations by editing the `config.sh` file.

| Variable name                   | Description                                         | Default value                                   |
| ------------------------------- | --------------------------------------------------- | ----------------------------------------------- |
| KEYROCK                         | A sub-domain name of Keyrock (Required)             | keyrock                                         |
| ORION                           | A sub-domain name of Orion (Required)               | orion                                           |
| COMET                           | A sub-domain name of Comet                          | (empty)                                         |
| QUANTUMLEAP                     | A sub-domain name of QuantumLeap                    | (empty)                                         |
| WIRECLOUD                       | A sub-domain name of WireCloud                      | (empty)                                         |
| NGSIPROXY                       | A sub-domain name of Ngsiproxy                      | (empty)                                         |
| NODE\_RED                       | A sub-domain name of Node-RED                       | (empty)                                         |
| GRAFANA                         | A sub-domain name of Grafana                        | (empty)                                         |
| IOTAGENT                        | A sub-domain name of IoT Agent                      | (empty)                                         |
| MOSQUITTO                       | A sub-domain name of MOSQUITTO                      | (empty)                                         |
| IDM\_ADMIN\_NAME                | A name of an admin user for Keyrock                 | admin                                           |
| IDM\_ADMIN\_EMAIL               | An email address of an admin user for Keyrock       | IDM\_ADMIN\_NAME @ DOMAIN\_NAME                 |
| IDM\_ADMIN\_PASS                | A password of an admin user for Keyrock             | (Automatically generated)                       |
| FIREWALL                        | Enable firewall. true or false                      | false                                           |
| CERT\_EMAIL                     | An email address for certbot                        | (An email address of an admin user for Keyrock) |
| CERT\_REVOKE                    | Revoke and reacquire the certificate. true or false | false                                           |
| CERT\_TEST                      | Use --test-cert option. true or false               | false                                           |
| CERT\_FORCE\_RENEWAL            | Use --force-renewal option. true or false           | false                                           |
| QUERYPROXY                      | Use queryproxy. true or false                       | false                                           |
| REGPROXY                        | Use regproxy. true or false                         | false                                           |
| REGPROXY\_NGSITYPE              | NgsiType for remote broker. (v2 or ld) Default: v2  | (empty)                                         |
| REGPROXY\_HOST                  | Host for remote broker.                             | (empty)                                         |
| REGPROXY\_IDMTYPE               | IdM type for remote broker.                         | (empty)                                         |
| REGPROXY\_IDMHOST               | IdM host for remote broker.                         | (empty)                                         |
| REGPROXY\_USERNAME              | A username for remote broker.                       | (empty)                                         |
| REGPROXY\_PASSWORD              | A password for remote broker.                       | (empty)                                         |
| REGPROXY\_CLIENT\_ID            | A client id for remote broker.                      | (empty)                                         |
| REGPROXY\_CLIENT\_SECRET        | A client secret for remote broker.                  | (empty)                                         |
| MQTT\_1883                      | Use MQTT 1883 Port. true or false                   | false                                           |
| MQTT\_TLS                       | Use MQTT TLS. true or false                         | true                                            |
| NODE\_RED\_INSTANCE\_NUMBER     | Number of Node-RED instance.                        | 1                                               |
| NODE\_RED\_INSTANCE\_USERNAME   | Username for Node-RED instance.                     | node-red                                        |
| NODE\_RED\_INSTANCE\_HTTP\_ROOT | HTTP root for Node-RED instance.                    | /node-red                                       |
| POSTFIX                         | Use Postfix (local delivery). (true or false)       | false                                           |


## Files and directories layout

| File or directory             | Description                                                                             |
| ----------------------------- | --------------------------------------------------------------------------------------- |
| .                             | A root directory of FI-BB. It's a directory in which you ran lets-fiware.sh command.    |
| ./docker-compose.yml          | A config file for docker-compose which has the configuration information of FIWARE GEs. |
| ./.env                        | A file which has environment variables for docker-compose.yml file.                     |
| ./config                      | A directory which has configuration files for running Docker containers.                |
| ./data                        | A directory which has persistent data for running Docker containers.                    |
| /etc/letsencrypt              | A directory which has server certificate files.                                         |
| /var/log/fiware               | A directory which has log files.                                                        |
| /etc/rsyslog.d/10-fiware.conf | A config file for rsyslog. In the case of CentOS, the filename is 'fiware.conf'.        |
| /etc/logrotate.d/fiware       | A config file for logroate.                                                             |
| /etc/cron.d/fiware-big-bang   | A config file for cron                                                                  |

## Copyright and License

Copyright (c) 2021 Kazuhito Suda<br>
Licensed under the MIT License.
