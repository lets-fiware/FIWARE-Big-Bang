[![FIWARE Big BangBanner](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/FIWARE-Big-Bang-non-free.png)](https://www.letsfiware.jp/)
[![NGSI v2](https://img.shields.io/badge/NGSI-v2-5dc0cf.svg)](https://fiware-ges.github.io/orion/api/v2/stable/)

![FIWARE: Tools](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/deployment-tools.svg)
[![License: MIT](https://img.shields.io/github/license/lets-fiware/FIWARE-Big-Bang.svg)](https://opensource.org/licenses/MIT)
[![Support badge](https://img.shields.io/badge/tag-fiware-orange.svg?logo=stackoverflow)](https://stackoverflow.com/questions/tagged/fiware+fi-bb)
<br/>
[![Lint](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/lint.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/lint.yml)
[![codecov](https://codecov.io/gh/lets-fiware/FIWARE-Big-Bang/branch/main/graph/badge.svg?token=OHFTT6TUIS)](https://codecov.io/gh/lets-fiware/FIWARE-Big-Bang)
<br/>
[![Ubuntu 18.04](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-18.04.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-18.04.yml)
[![Ubuntu 20.04](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-20.04.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-20.04.yml)
<br/>

The FIWARE Big Bang is a turnkey solution for setting up a FIWARE instance in the cloud.

## What is FIWARE Big Bang?

> I am at all events convinced that He does not play dice.
>
> — Albert Einstein

The FIWARE Big Bang allows you to install FIWARE Generic enablers easily into your virtual machine in the cloud.
FI-BB stands for FIWARE Big Bang.

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
-   Supported third party OSS:
    -   Node-RED
    -   Grafana

## Prerequisite

Before running the setup script, you need to register sub-domain names of FIWARE GEs that you want to use as shown:

-   keyrock.letsfiware.jp
-   orion.letsfiware.jp
-   wirecloud.letsfiware.jp
-   ngsiproxy.letsfiware.jp

## Getting Started

Clone the FIWARE Big Bang repository and run the `lets-fiware.sh` script with your domain name.

```
curl -sL https://github.com/lets-fiware/FIWARE-Big-Bang/archive/refs/tags/v0.2.0.tar.gz | tar zxf -
cd FIWARE-Big-Bang-0.2.0/
./lets-fiware.sh letsfiware.jp
```

## Command syntax

The `lets-fiware.sh` command accepts two arguments. The first argument is a domain name. The second one is
a global IP address. It's an optional.

```
./lets-fiware.sh DOMAIN_NAME [GLOBAL_IP_ADDRESS]
```

Examples:

-   ./lets-fiware.sh letsfiware.jp
-   ./lets-fiware.sh letsfiware.jp XX:XX:XX:XX

## Configuration

You can specify configurations by editing the `config.sh` file.

| Variable name        | Description                                                    | Default value                                    |
| -------------------- | -------------------------------------------------------------- | ------------------------------------------------ |
| KEYROCK              | A sub-domain name of Keyrock (Required)                        | keyrock                                          |
| ORION                | A sub-domain name of Orion (Required)                          | orion                                            |
| COMET                | A sub-domain name of Comet                                     | (empty)                                          |
| QUANTUMLEAP          | A sub-domain name of QuantumLeap                               | (empty)                                          |
| WIRECLOUD            | A sub-domain name of WireCloud                                 | (empty)                                          |
| NGSIPROXY            | A sub-domain name of Ngsiproxy                                 | (empty)                                          |
| NODE\_RED            | A sub-domain name of Node-RED                                  | (empty)                                          |
| GRAFANA              | A sub-domain name of Grafana                                   | (empty)                                          |
| IDM\_ADMIN\_NAME     | A name of an admin user for Keyrock                            | admin                                            |
| IDM\_ADMIN\_EMAIL    | An email address of an admin user for Keyrock                  | IDM\_ADMIN\_NAME @ DOMAIN\_NAME                  |
| IDM\_ADMIN\_PASS     | A password of an admin user for Keyrock                        | (Automatically generated)                        |
| KEYROCK\_POSTGRES    | Use PostgreSQL as back-end database for Keyrock. true of false | false                                            |
| FIREWALL             | Enable firewall. true or false                                 | false                                            |
| CERT\_EMAIL          | An email address for certbot                                   | (An email address of an admin user for Keyrock)  |
| CERT\_REVOKE         | Revoke and reacquire the certificate. true or false            | false                                            |
| CERT\_TEST           | Use --test-cert option. Set `--test-cert` to enable it.        | (empty)                                          |
| CERT\_FORCE\_RENEWAL | Use --force-renewal option. true or false                      | false                                            |

## Copyright and License

Copyright (c) 2021 Kazuhito Suda<br>
Licensed under the [MIT License](./LICENSE).
