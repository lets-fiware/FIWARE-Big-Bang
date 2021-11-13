[![FIWARE Big BangBanner](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/FIWARE-Big-Bang-non-free.png)](https://www.letsfiware.jp/)
[![NGSI v2](https://img.shields.io/badge/NGSI-v2-5dc0cf.svg)](https://fiware-ges.github.io/orion/api/v2/stable/)

![FIWARE: Tools](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/deployment-tools.svg)
[![License: MIT](https://img.shields.io/github/license/lets-fiware/FIWARE-Big-Bang.svg)](https://opensource.org/licenses/MIT)
[![Support badge](https://img.shields.io/badge/tag-fiware-orange.svg?logo=stackoverflow)](https://stackoverflow.com/questions/tagged/fiware+fi-bb)
<br/>
[![Lint](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/lint.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/lint.yml)
[![Tests](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-latest.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-latest.yml)
[![codecov](https://codecov.io/gh/lets-fiware/FIWARE-Big-Bang/branch/main/graph/badge.svg?token=OHFTT6TUIS)](https://codecov.io/gh/lets-fiware/FIWARE-Big-Bang)
<br/>
[![Ubuntu 18.04](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-18.04.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-18.04.yml)
[![Ubuntu 20.04](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-20.04.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-20.04.yml)
<br/>

The FIWARE Big Bang is a turnkey solution for setting up a FIWARE instance in the cloud.

| :books: [Documentation](https://fi-bb.letsfiware.jp/) | :dart: [Roadmap](./ROADMAP.md) |
|-------------------------------------------------------|--------------------------------|

## What is FIWARE Big Bang?

> I am at all events convinced that He does not play dice.
>
> — Albert Einstein

The FIWARE Big Bang allows you to install FIWARE Generic enablers easily into your virtual machine in the cloud.
FI-BB stands for FIWARE Big Bang.

## Requirements

-   A virtual machine with a public IP address (global IP address) or a virtual machine that can be accessed
    from the Internet via a network equipment
-   An own domain name
-   Ports exposed on the internet
    -   443 (HTTPS)
    -   80 (HTTP)
    -   1883 when enabling MQTT
    -   8883 when enabling MQTT TLS
-   Supported Linux distribution
    -   Ubuntu 20.04 (Recommended Linux distribution)
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

### Supported third-party open source software

-   Node-RED
-   Grafana
-   Mosquitto
-   Elasticsearch (as a database for persitenting context data)

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

See full documentation [here](https://fi-bb.letsfiware.jp/) for details.

## Why is it named FIWARE Big Bang?

The name of this product comes from the Big Bang theory of the universe. Because most FIWARE generic enablers in
the Core Context Management chapter have an astrology name and this product creates a FIWARE instance as your own
universe in which various FIWARE GEs run.

## Copyright and License

Copyright (c) 2021 Kazuhito Suda<br>
Licensed under the [MIT License](./LICENSE).
