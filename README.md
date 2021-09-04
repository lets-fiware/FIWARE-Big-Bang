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

## Copyright and License

Copyright (c) 2021 Kazuhito Suda<br>
Licensed under the [MIT License](./LICENSE).
