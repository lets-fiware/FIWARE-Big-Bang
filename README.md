![FIWARE: Tools](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/deployment-tools.svg)
[![License: MIT](https://img.shields.io/github/license/lets-fiware/FIWARE-Big-Bang.svg)](https://opensource.org/licenses/MIT)
<br/>

The FIWARE Big Bang is a turnkey solution for setting up a FIWARE instance in the cloud.

## What is FIWARE Big Bang?

> I am at all events convinced that He does not play dice.
>
> — Albert Einstein

The FIWARE Big Bang allows you to install FIWARE Generic enablers easily into your virtual mache in the cloud.
FI-BB stands for FIWARE Big Bang.

## Requirements

-   A virtual machine with a global IP address
-   A domain name
-   Supported Linux distribution:
    -   Ubuntu 18.04, 20.04
    -   CentOS 7, 8
-   Supported FIWARE GEs and other OSS:
    -   Keyrock
    -   Wilma
    -   Orion
    -   Cygnus
    -   Comet
    -   QuantumLeap
    -   WireCloud
    -   Ngsiproxy
    -   Node-RED
    -   Grafana

## Prerequisite

Before run the setup script, you need to register sub-domain names of FIWARE GEs that you want to use as shown:

-   keyrock.letsfiware.jp
-   orion.letsfiware.jp
-   wirecloud.letsfiware.jp
-   ngsiproxy.letsfiware.jp

## Getting Started

Clone the FIWARE Big Bang repogitry and run the `lets-fiware.sh` script with your domain name.

```
git clone https://github.com/lets-fiware/FIWARE-Big-Bang.git
cd ./FIWARE-Big-Bang
./lets-fiware.sh letsfiware.jp
```

## Command syntax

The `lets-fiware.sh` command accepts two arguments. The first argument is a domain name. The second one is
a global ip address. It's a optional.

```
./lets-fiware.sh DOMAIN_NAME [GLOBAL_IP_ADDRESS]
```

Examples:

-   ./lets-fiware.sh letsfiware.jp
-   ./lets-fiware.sh letsfiware.jp XX:XX:XX:XX

## Configuration

You can specify configurations by editing the `config.sh` file.

| Variable name           | Description                                                | Default value                                    |
| ----------------------- | ---------------------------------------------------------- | ------------------------------------------------ |
| KEYROCK                 | A sub-domain name of Keyrock (Required)                    | keyrock                                          |
| ORION                   | A sub-domain name of Orion (Required)                      | orion                                            |
| COMET                   | A sub-domain name of Comet                                 | (empty)                                          |
| QUANTUMLEAP             | A sub-domain name of QuantumLeap                           | (empty)                                          |
| WIRECLOUD               | A sub-domain name of WireCloud                             | (empty)                                          |
| NGSIPROXY               | A sub-domain name of Ngsiproxy                             | (empty)                                          |
| NODE\_RED               | A sub-domain name of Node-RED                              | (empty)                                          |
| GRAFANA                 | A sub-domain name of Grafana                               | (empty)                                          |
| IDM\_ADMIN\_EMAIL\_NAME | A name of e-mail of an admin user for Keyrock              | admin                                            |
| IDM\_ADMIN\_PASS        | A password of an admin user for Keyrock                    | (automatically generated)                        |
| FIREWALL                | Enable firewall. true or false                             | false                                            |
| LOGGING                 | Enable log file creation in /var/log/fiware. true of false | true                                             |
| CERT\_EMAIL             | An e-mail address for certbot                              | (an e-mail address of an admin user for Keyrock) |
| CERT\_REVOKE            | Revoke and reacquire the certificate: true or false        | false                                            |

## Copyright and License

Copyright (c) 2021 Kazuhito Suda<br>
Licensed under the [MIT License](./LICENSE).
