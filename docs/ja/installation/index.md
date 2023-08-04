# Installation

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [サポートしている FIWARE GEs とサードパーティ・オープンソース・ソフトウェア](#supported-fiware-ges-and-third-party-open-source-software)
-   [要件](#requirements)
-   [前提条件](#prerequisite)
-   [使用方法](#getting-started)
-   [コマンド構文](#command-syntax)
-   [構成](#configuration)
-   [マルチ・サーバのインストール](#multi-server-installation)
-   [ポートを公開](#expose-ports)
-   [例](#examples)

</details>

<a name="supported-fiware-ges-and-third-party-open-source-software"></a>

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

<a name="requirements"></a>

## 要件 

### 仮想マシン

パブリック IP アドレス (グローバル IP アドレス) を持つ仮想マシン、またはネットワーク機器を介して
インターネットからアクセスできる仮想マシン

### サポートしている Linux ディストリビューション

FIWARE Big Bang は、Linux ディストリビューションとして Ubuntu と CentOS をサポートしています。
推奨の Linux ディストリビューションは Ubuntu 22.04 です。

-   Ubuntu 22.04 (推奨 Linux ディストリビューション)
-   Ubuntu 20.04
-   CentOS 7, 8

### ドメイン名 

ドメイン名で Web アプリケーションや API にアクセスするには、独自のドメイン名が必要です。
サブドメイン名を使用して、各 Web アプリケーションまたは APIs にアクセスできます。

### インターネットに公開されるポート

FIWARE Big Bang によってインストールされた Web アプリケーションと APIs は、次のポートを使用します。

-   ポート 443 (HTTPS) は Web アプリケーションと API で使用します
-   ポート 80 (HTTP) を Let's encrypt 使用してサーバー証明書を取得するために使用します
-   ポート 1883 は、MQTT を有効にすると、Mosquitto が使用します
-   ポート 8883 は、MQTT TLS を有効にすると、Mosquitto が使用します

<a name="prerequisite"></a>

## 前提条件

セットアップ・スクリプトを実行する前に、A レコードまたは CNAME レコードを使用して、FIWARE GEs
のサブドメイン名を DNS に登録する必要があります。

-   keyrock.example.com
-   orion.example.com

<a name="getting-started"></a>

## 使用方法

FIWARE Big Bang の tar.gz ファイルをダウンロードします。

```bash
curl -sL https://github.com/lets-fiware/FIWARE-Big-Bang/archive/refs/tags/v0.30.0.tar.gz | tar zxf -
```

`FIWARE-Big-Bang-0.30.0` ディレクトリに移動します。

```bash
cd FIWARE-Big-Bang-0.30.0/
```

独自のドメイン名とパブリック IP アドレスを指定して、`lets-fiware.sh` スクリプトを実行します。

```bash
./lets-fiware.sh example.com XX.XX.XX.XX
```

<a name="command-syntax"></a>

## コマンド構文

この `lets-fiware.sh` コマンドには 2 つの引数を指定します。最初の引数はドメイン名です。2番目はパブリック
IP アドレスです。仮想マシンにパブリック IP アドレスが持っている場合は省略できます。

```bash
./lets-fiware.sh DOMAIN_NAME [PUBLIC_IP_ADDRESS]
```

例:

-   ./lets-fiware.sh example.com
-   ./lets-fiware.sh example.com XX:XX:XX:XX

<a name="configuration"></a>

## 構成

`config.sh` ファイルを編集して構成を指定できます。詳細については、以下の各ドキュメントを参照してください。

-   [Keyrock](keyrock.md)
-   [Orion](orion.md)
-   [Orion-LD](orion-ld.md)
-   [Mintaka](orion-ld.md)
-   [Cygnus](cygnus.md)
-   [Comet](comet.md)
-   [Perseo](perseo.md)
-   [Quantumleap](quantumleap.md)
-   [IoT Agent for UltraLight](iotagent-ul.md)
-   [IoT Agent for JSON](iotagent-json.md)
-   [WireCloud](wirecloud.md)
-   [Node-RED](node-red.md)
-   [Grafana](grafana.md)
-   [Zeppelin](zeppelin.md)
-   [Regproxy](regproxy.md)
-   [Queryproxy](queryproxy.md)
-   [Certbot](certbot.md)
-   [Firewall](firewall.md)

<a name="multi-server-installation"></a>

## マルチ・サーバのインストール

マルチ・サーバのインストールでは、FIWARE GEs やその他の OSS を複数のサーバにインストールできます。
詳細については、[このドキュメント](multi_server.md)を参照してください。

<a name="expose-ports"></a>

## ポートを公開

Docker コンテナで実行されている一部の FIWARE GEs およびその他の OSS は、サービスのポートを公開できます。
詳細については、[このドキュメント](expose-ports.md)を参照してください。

<a name="examples"></a>

## 例

設定例は次のとおりです:

### 例 1

Orion Context broker を構成します。

```bash
KEYROCK=keyrock
ORION=orion
```

### 例 2

永続的なコンテキスト・データを PostgreSQL に保存するには、Cygnus と PostgreSQL を構成します。

```bash
KEYROCK=keyrock
ORION=orion
CYGNUS=cygnus
CYGNUS_POSTGRES=true
```

### 例 3

時系列コンテキスト・データを永続化するには、Comet と Cygnus を構成します。

```bash
KEYROCK=keyrock
ORION=orion
COMET=comet
CYGNUS=cygnus
```

### 例 4

Basic 認証を使用して、IoT Agent for UltraLight 2.0 over HTTP を構成します。

```bash
KEYROCK=keyrock
ORION=orion
IOTAGENT_UL=iotagent-ul
IOTAGENT_HTTP=iotagent-http
IOTA_HTTP_AUTH=basic
```

### 例 5

IoT Agent for UltraLight 2.0 over MQTT TLS を構成します。

```bash
KEYROCK=keyrock
ORION=orion
IOTAGENT_JSON=iotagent-json
MOSQUITTO=mosquitto
MQTT_TLS=true
```

### 例 6

WireCloud を構成します。

```bash
KEYROCK=keyrock
ORION=orion
WIRECLOUD=wirecloud
NGSIPROXY=ngsiproxy
```

### 例 7

Node-RED を構成します。

```bash
KEYROCK=keyrock
ORION=orion
NODE_RED=node-red
```
