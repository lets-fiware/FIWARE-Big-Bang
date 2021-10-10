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

| :books: [Documentation](https://fi-bb.letsfiware.jp/) | :dart: [Roadmap](./ROADMAP.md) |
|-------------------------------------------------------|--------------------------------|

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
    -   Ubuntu 20.04 (Recommended Linux distribution)
    -   Ubuntu 18.04
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
    -   IoT Agent for UltraLight
-   Supported third party OSS:
    -   Node-RED
    -   Grafana
    -   Mosquitto

## Prerequisite

Before running the setup script, you need to register sub-domain names of FIWARE GEs that you want to use as shown:

-   keyrock.letsfiware.jp
-   orion.letsfiware.jp
-   wirecloud.letsfiware.jp
-   ngsiproxy.letsfiware.jp

## Getting Started

Download a tar.gz file for the FIWARE Big Bang and run the `lets-fiware.sh` script with your domain name.

```
curl -sL https://github.com/lets-fiware/FIWARE-Big-Bang/archive/refs/tags/v0.5.0.tar.gz | tar zxf -
```

```
cd FIWARE-Big-Bang-0.5.0/
./lets-fiware.sh letsfiware.jp
```

## Why is it named FIWARE Big Bang?

The name of this product comes from the Big Bang theory of the universe. Because most FIWARE generic enablers in
the Core Context Management chapter have an astrology name and this product creates a FIWARE instance as your own
universe in which various FIWARE GEs run.

## Copyright and License

Copyright (c) 2021 Kazuhito Suda<br>
Licensed under the [MIT License](./LICENSE).
