[![FIWARE Big BangBanner](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/FIWARE-Big-Bang-non-free.png)](https://www.letsfiware.jp/)
[![NGSI v2](https://img.shields.io/badge/NGSI-v2-5dc0cf.svg)](https://fiware-ges.github.io/orion/api/v2/stable/)
[![NGSI LD](https://img.shields.io/badge/NGSI-LD-d6604d.svg)](https://www.etsi.org/deliver/etsi_gs/CIM/001_099/009/01.05.01_60/gs_CIM009v010501p.pdf)

![FIWARE: Tools](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/deployment-tools.svg)
[![License: MIT](https://img.shields.io/github/license/lets-fiware/FIWARE-Big-Bang.svg)](https://opensource.org/licenses/MIT)
[![GitHub Discussions](https://img.shields.io/github/discussions/lets-fiware/FIWARE-Big-Bang)](https://github.com/lets-fiware/FIWARE-Big-Bang/discussions)
<br/>
[![Lint](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/lint.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/lint.yml)
[![Tests](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-latest.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-latest.yml)
[![codecov](https://codecov.io/gh/lets-fiware/FIWARE-Big-Bang/branch/main/graph/badge.svg?token=OHFTT6TUIS)](https://codecov.io/gh/lets-fiware/FIWARE-Big-Bang)
<br/>
[![Ubuntu 20.04](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-20.04.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-20.04.yml)
[![Ubuntu 22.04](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-22.04.yml/badge.svg)](https://github.com/lets-fiware/FIWARE-Big-Bang/actions/workflows/ubuntu-22.04.yml)
<br/>

FIWARE Big Bang は、クラウドに FIWARE インスタンスをセットアップするためのターンキー・ソリューションです。

| :books: [Documentation](https://fi-bb.letsfiware.jp/ja/) | :dart: [Roadmap](./ROADMAP.md) |
|-------------------------------------------------------|--------------------------------|

## FIWARE Big Bang とは

> I am at all events convinced that He does not play dice.
>
> — Albert Einstein

FIWARE Big Bang を使用すると、FIWARE Generic enablers をクラウド内の仮想マシンに簡単にインストールできます。
FI-BB は FIWARE Big Bang の略名です。

## サポートしている FIWARE GEs とサードパーティ・オープンソース・ソフトウェア

### サポートしている FIWARE GEs

-   Keyrock
-   Wilma
-   Orion
-   Orion-LD
-   Mintaka
-   Cygnus
-   Comet
-   Perseo
-   QuantumLeap
-   Draco
-   WireCloud
-   Ngsiproxy
-   IoT Agent for UltraLight (over HTTP および MQTT)
-   IoT Agent for JSON (over HTTP および MQTT)

### サポートしているサードパーティ・オープンソース・ソフトウェア

-   Node-RED
-   Grafana
-   Apache Zeppelin (実験的サポート)
-   Mosquitto
-   Elasticsearch (コンテキスト・データを永続化するためのデータベースとして使用)

## 要件

-   パブリック IP アドレス (グローバル IP アドレス) を持つ仮想マシン、またはネットワーク機器を介して
    インターネットからアクセスできる仮想マシン
-   独自ドメイン
-   インターネット上で公開するポート
    -   443 (HTTPS)
    -   80 (HTTP)
    -   MQTT を有効にしたとき、1883
    -   MQTT TLS を有効にしたとき、8883
-   サポートしている Linux ディストリビューション
    -   [Ubuntu 22.04 LTS](https://github.com/lets-fiware/FIWARE-Big-Bang/discussions/304) (推奨 Linux ディストリビューション)
    -   [Ubuntu 20.04 LTS](https://github.com/lets-fiware/FIWARE-Big-Bang/discussions/305)
    -   [CentOS Stream release 9](https://github.com/lets-fiware/FIWARE-Big-Bang/discussions/330)
    -   [CentOS Stream release 8](https://github.com/lets-fiware/FIWARE-Big-Bang/discussions/331)
    -   [Rocky Linux 9](https://github.com/lets-fiware/FIWARE-Big-Bang/discussions/306)
    -   [Rocky Linux 8](https://github.com/lets-fiware/FIWARE-Big-Bang/discussions/309)
    -   [AlmaLinux 9](https://github.com/lets-fiware/FIWARE-Big-Bang/discussions/307)
    -   [AlmaLinux 8](https://github.com/lets-fiware/FIWARE-Big-Bang/discussions/308)

## 前提条件

セットアップ・スクリプトを実行する前に、A レコードまたは CNAME レコードを使用して、FIWARE GEs
のサブドメイン名を DNS に登録する必要があります。

-   keyrock.example.com
-   orion.example.com

## 使用方法

FIWARE Big Bang の tar.gz ファイルをダウンロードします。

```bash
curl -sL https://github.com/lets-fiware/FIWARE-Big-Bang/releases/download/v0.37.0/FIWARE-Big-Bang-0.37.0.tar.gz | tar zxf -
```

`FIWARE-Big-Bang-0.37.0` ディレクトリに移動します。

```bash
cd FIWARE-Big-Bang-0.37.0/
```

独自のドメイン名とパブリック IP アドレスを指定して、`lets-fiware.sh` スクリプトを実行します。

```bash
./lets-fiware.sh example.com XX.XX.XX.XX
```

詳細については、[こちら](https://fi-bb.letsfiware.jp/ja/) のドキュメントを参照してください。

## FIWARE Big Bang の名前の由来は

このプロダクトの名前は、宇宙のビッグバン理論に由来しています。コア・コンテキスト管理のチャプターのほとんどの
FIWARE generic enablers は星座の名前を持ち、このプロダクトは、様々 FIWARE GE を実行する FIWARE インスタンスを
作成するためです。それはあなたの宇宙です。

## Copyright and License

Copyright (c) 2021-2024 Kazuhito Suda<br>
Licensed under the [MIT License](./LICENSE).
