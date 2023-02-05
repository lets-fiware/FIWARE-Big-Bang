# Multi-server installation

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [マルチサーバ・インストールとは](#what-is-multi-server-installation)
-   [構成パラメータ](#configuration-parameters)
-   [設定方法](#how-to-setup)
-   [例](#example)

</details>

<a name=""></a>

## マルチサーバ・インストールとは

マルチサーバ・インストールは、複数の VMs で FIWARE インスタンスを構成する方法です。
Keyrock がインストールされた VM と他の FIWARE GEs がインストールされた VMs で FIWARE
インスタンスを構成できます。Keyrock がインストールされた VM は、メイン VM と呼ばれます。
他の FIWARE GEs をインストールした VM を追加 VM と呼びます。

<a name="configuration-parameters"></a>

## 構成パラメータ

`config.sh` ファイルを編集して構成を指定できます。

| 変数名                              | 説明                                                                                          | 既定値 |
| ----------------------------------- | --------------------------------------------------------------------------------------------- | ------ |
| MULTI\_SERVER\_KEYROCK              | Keyrock URLの URL。例) https://keyrock.exmaple.com                                            | (なし) |
| MULTI\_SERVER\_ADMIN\_EMAIL         | Keyrock の管理者ユーザのメールアドレス。例) admin@example.com                                 | (なし) |
| MULTI\_SERVER\_ADMIN\_PASS          | Keyrock の管理者ユーザのパスワード                                                            | (なし) |
| MULTI\_SERVER\_PEP\_PROXY\_USERNAME | Wilma PEP Proxy のユーザ名                                                                    | (なし) |
| MULTI\_SERVER\_PEP\_PASSWORD        | Wilma PEP Proxy のパスワード                                                                  | (なし) | 
| MULTI\_SERVER\_CLIENT\_ID           | client id                                                                                     | (なし) |
| MULTI\_SERVER\_CLIENT\_SECRET       | client secret                                                                                 | (なし) |
| MULTI\_SERVER\_ORION\_HOST          | WireCloud をインストールするときの Orion ホスト (必須)。例) orion.exmaple.com                 | (なし) |
| MULTI\_SERVER\_QUANTUMLEAP\_HOST    | WireCloud をインストールするときの Orion ホスト (オプション)。例) quantumleap.exmaple.com     | (なし) |
| MULTI\_SERVER\_ORION\_INTERNAL\_IP  | IoT Agent または Perseo をインストールする際の Orion 内部 IP アドレス (必須)。例) 192.168.0.1 | (なし) |

<a name="how-to-setup"></a>

## 設定方法

マルチサーバ・インストールの必須変数の値を取得するには、Keyrock がインストールされている VM
で次のコマンドを実行します。それらを別の VM の `config.sh` に追加します。

#### リクエスト:

```bash
make multi-server
```

#### レスポンス:

```bash
MULTI_SERVER_KEYROCK=https://keyrock.example.com
MULTI_SERVER_ADMIN_EMAIL=admin@example.com
MULTI_SERVER_ADMIN_PASS=JSyJiEVon6MIliBL

MULTI_SERVER_PEP_PROXY_USERNAME=pep_proxy_a3aff992-c3a2-4b39-8728-22eed803ccda
MULTI_SERVER_PEP_PASSWORD=pep_proxy_a00226e8-5c6e-47de-9137-40a9a932bda0

MULTI_SERVER_CLIENT_ID=1db4e864-851e-4b39-a952-ac70ca8f6bfc
MULTI_SERVER_CLIENT_SECRET=8cb45711-b992-4ef4-9eb4-cb6391d48b9a
```

<a name="example"></a>

## 例 

マルチサーバ・インストールの構成例を以下に示します:

### 例 1

Keyrock と Orion を別々の VM にインストールします。

| VMs       | FIWARE GEs |
| --------- | ---------- |
| メイン VM | Keyrock    |
| 追加 VM   | Orion      |

#### メイン VM の構成

```bash
KEYROCK=keyrock
ORION=
```

#### 追加の VM の構成

```bash
KEYROCK=
ORION=orion

MULTI_SERVER_KEYROCK=https://keyrock.example.com
MULTI_SERVER_ADMIN_EMAIL=admin@example.com
MULTI_SERVER_ADMIN_PASS=JSyJiEVon6MIliBL

MULTI_SERVER_PEP_PROXY_USERNAME=pep_proxy_a3aff992-c3a2-4b39-8728-22eed803ccda
MULTI_SERVER_PEP_PASSWORD=pep_proxy_a00226e8-5c6e-47de-9137-40a9a932bda0

MULTI_SERVER_CLIENT_ID=1db4e864-851e-4b39-a952-ac70ca8f6bfc
MULTI_SERVER_CLIENT_SECRET=8cb45711-b992-4ef4-9eb4-cb6391d48b9a
```

### 例 2

Keyrock と Orion をメイン VM にインストールします。
WireCloud を追加の VM にインストールします。

| VMs       | FIWARE GEs     |
| --------- | -------------- |
| メイン VM | Keyrock, Orion |
| 追加 VM   | WireCloud      |

#### メイン VM の構成

```bash
KEYROCK=keyrock
ORION=orion
```

#### 追加の VM の構成

```bash
KEYROCK=
ORION=
WIRECLOUD=wirecloud
NGSIPROXY=ngsiproxy

MULTI_SERVER_KEYROCK=https://keyrock.example.com
MULTI_SERVER_ADMIN_EMAIL=admin@example.com
MULTI_SERVER_ADMIN_PASS=JSyJiEVon6MIliBL

MULTI_SERVER_PEP_PROXY_USERNAME=pep_proxy_a3aff992-c3a2-4b39-8728-22eed803ccda
MULTI_SERVER_PEP_PASSWORD=pep_proxy_a00226e8-5c6e-47de-9137-40a9a932bda0

MULTI_SERVER_CLIENT_ID=1db4e864-851e-4b39-a952-ac70ca8f6bfc
MULTI_SERVER_CLIENT_SECRET=8cb45711-b992-4ef4-9eb4-cb6391d48b9a

MULTI_SERVER_ORION_HOST=orion.exmaple.com
```

### 例 3

Keyrock と Orion をメイン VM にインストールします。Cygnus と PostgreSQL を追加の VM にインストールします。

| VMs       | FIWARE GEs         |
| --------- | ------------------ |
| メイン VM | Keyrock, Orion     |
| 追加 VM   | Cygnus, PostgreSQL |

#### メイン VM の構成

```bash
KEYROCK=keyrock
ORION=orion
```

#### 追加の VM の構成

Cygnus のポートを `CYGNUS_EXPOSE_PORT=all` で公開して、Orion が Cygnus にコンテキストの変更を通知できるようにします。
インターネットからアクセスできないように、ファイアウォールなどのネットワーク機器を使用して露出したポートを閉じる必要があります。

```bash
KEYROCK=
ORION=
CYGNUS=cygnus
CYGNUS_POSTGRES=true
CYGNUS_EXPOSE_PORT=all

MULTI_SERVER_KEYROCK=https://keyrock.example.com
MULTI_SERVER_ADMIN_EMAIL=admin@example.com
MULTI_SERVER_ADMIN_PASS=JSyJiEVon6MIliBL

MULTI_SERVER_PEP_PROXY_USERNAME=pep_proxy_a3aff992-c3a2-4b39-8728-22eed803ccda
MULTI_SERVER_PEP_PASSWORD=pep_proxy_a00226e8-5c6e-47de-9137-40a9a932bda0

MULTI_SERVER_CLIENT_ID=1db4e864-851e-4b39-a952-ac70ca8f6bfc
MULTI_SERVER_CLIENT_SECRET=8cb45711-b992-4ef4-9eb4-cb6391d48b9a

MULTI_SERVER_ORION_HOST=orion.exmaple.com
```

Cygnus のサブスクリプションを作成するときに、Cygnus が実行されている VM のプライベート IP アドレスを指定します。
PostgreSQL のポートは `5055` です。

```bash
ngsi create \
  --host "orion.example.com" \
  --service openiot \
  --path / \
  subscription \
  --description "Notify Cygnus of all context changes and store it into PostgreSQL" \
  --idPattern ".*" \
  --uri "http://192.168.0.2:5055/notify"
```

### 例 4

Keyrock と Orion をメイン VM にインストールします。IoT Agent for JSON は、追加の VM にインストールします。

| VMs       | FIWARE GEs                        |
| --------- | --------------------------------- |
| メイン VM | Keyrock, Orion                    |
| 追加 VM   | IoT Agent for JSON over MQTT TLS  |

#### メイン VM の構成

IoT Agent が Orion にアクセスできるように、Orion のポート 1026 を `ORION_EXPOSE_PORT=all` で公開します。

```bash
KEYROCK=keyrock
ORION=orion
ORION_EXPOSE_PORT=all
```

#### 追加の VM の構成

Orion が実行されている VM のプライベート IP アドレスを `MULTI_SERVER_ORION_INTERNAL_IP` に設定します。
インターネットからアクセスできないように、ファイアウォールなどのネットワーク機器を使用して露出したポートを閉じる必要があります。

```bash
KEYROCK=
ORION=
IOTAGENT_JSON=iotagent-json
MOSQUITTO=mosquitto
MQTT_TLS=true

MULTI_SERVER_KEYROCK=https://keyrock.example.com
MULTI_SERVER_ADMIN_EMAIL=admin@example.com
MULTI_SERVER_ADMIN_PASS=JSyJiEVon6MIliBL

MULTI_SERVER_PEP_PROXY_USERNAME=pep_proxy_a3aff992-c3a2-4b39-8728-22eed803ccda
MULTI_SERVER_PEP_PASSWORD=pep_proxy_a00226e8-5c6e-47de-9137-40a9a932bda0

MULTI_SERVER_CLIENT_ID=1db4e864-851e-4b39-a952-ac70ca8f6bfc
MULTI_SERVER_CLIENT_SECRET=8cb45711-b992-4ef4-9eb4-cb6391d48b9a

MULTI_SERVER_ORION_HOST=orion.exmaple.com

MULTI_SERVER_ORION_INTERNAL_IP=192.168.0.1
```
