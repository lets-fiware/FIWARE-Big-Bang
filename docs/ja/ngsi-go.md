# NGSI Go

NGSI Go は、FIWARE 開発者向けに FIWARE Open APIs をサポートするコマンドライン・インターフェイスです。
クライアント PC に NGSI Go をインストールすることで、FIWARE Open APIs に簡単にアクセスできます。
詳細については、[こちら](https://ngsi-go.letsfiware.jp/)のドキュメントを参照してください。

## インストール

### NGSI Go バイナリをインストール

NGSI Go バイナリは `/usr/local/bin` にインストールされます。

#### Linux へのインストール

```console
curl -OL https://github.com/lets-fiware/ngsi-go/releases/download/v0.12.0/ngsi-v0.12.0-linux-amd64.tar.gz
sudo tar zxvf ngsi-v0.12.0-linux-amd64.tar.gz -C /usr/local/bin
```

`ngsi-v0.12.0-linux-arm.tar.gz` and `ngsi-v0.12.0-linux-arm64.tar.gz` binaries are also available.

#### Mac へのインストール

```console
curl -OL https://github.com/lets-fiware/ngsi-go/releases/download/v0.12.0/ngsi-v0.12.0-darwin-amd64.tar.gz
sudo tar zxvf ngsi-v0.12.0-darwin-amd64.tar.gz -C /usr/local/bin
```

`ngsi-v0.12.0-darwin-arm64.tar.gz` binary is also available.

### NGSI Go の bash オートコンプリート・ファイルをインストール

ngsi_bash_autocomplete ファイルを `/etc/bash_completion.d` にインストールします。

```console
curl -OL https://raw.githubusercontent.com/lets-fiware/ngsi-go/main/autocomplete/ngsi_bash_autocomplete
sudo mv ngsi_bash_autocomplete /etc/bash_completion.d/
source /etc/bash_completion.d/ngsi_bash_autocomplete
echo "source /etc/bash_completion.d/ngsi_bash_autocomplete" >> ~/.bashrc
```

## セットアップ

以下は、各 FIWARE GE にアクセスするための設定例です。

### Keyrock

```bash
ngsi server \
  add \
  --host keyrock.example.com \
  --serverType keyrock \
  --serverHost "https://keyrock.example.com" \
  --username "admin@example.com" \
  --password "password"
```

### Orion

```bash
ngsi broker \
  add \
  --host orion.example.com \
  --ngsiType v2 \
  --brokerHost "https://orion.example.com" \
  --idmType tokenproxy \
  --idmHost "https://keyrock.example.com/token" \
  --username "admin@example.com" \
  --password "password"
```

### Orion-LD

```bash
ngsi broker \
  add \
  --host orion-ld.example.com \
  --ngsiType ld \
  --brokerHost "https://orion-ld.example.com" \
  --idmType tokenproxy \
  --idmHost "https://keyrock.example.com/token" \
  --username "admin@example.com" \
  --password "password"
```

### Cygnus

```bash
ngsi server add \
  --host cygnus.example.com \
  --serverType cygnus \
  --serverHost "https://cygnus.example.com" \
  --idmType tokenproxy \
  --idmHost "https://keyrock.example.com/token" \
  --username "admin@example.com" \
  --password "password"
```

### Comet

```bash
ngsi server add \
  --host "comet.example.com" \
  --serverType comet \
  --serverHost "https://comet.example.com" \
  --idmType tokenproxy \
  --idmHost "https://keyrock.example.com/token" \
  --username "admin@example.com" \
  --password "password"
```

### QuantumLeap

```bash
ngsi server add \
  --host "quantumleap.example.com" \
  --serverType quantumleap \
  --serverHost "https://${VAL}" \
  --idmType tokenproxy \
  --idmHost "https://keyrock.example.com/token" \
  --username "admin@example.com" \
  --password "password"
```

### IoT Agent for UltraLight

```bash
ngsi server add \
  --host "iotagent-ul.example.com" \
  --serverType iota \
  --serverHost "https://iotagent-ul.example.com" \
  --idmType tokenproxy \
  --idmHost "https://keyrock.example.com/token" \
  --username "admin@example.com" \
  --password "password" ^
  --service openiot \
  --path /
```

### IoT Agent for JSON

```bash
ngsi server add \
  --host "iotagent-json.example.com" \
  --serverType iota \
  --serverHost "https://iotagent-json.example.com" \
  --idmType tokenproxy \
  --idmHost "https://keyrock.example.com/token" \
  --username "admin@example.com" \
  --password "password" \
  --service openiot \
  --path /
```

### WireCloud

```bash
ngsi server add \
  --host "wirecloud.example.com" \
  --serverType wirecloud \
  --serverHost "https://wirecloud.example.com" \
  --idmType keyrock \
  --idmHost "https://keyrock.example.com/oauth2/token" \
  --username "admin@example.com" \
  --password "password" \
  --clientId "wirecloud_client_id" \
  --clientSecret "wirecloud_client_secret"
```

## 関連情報

-   [NGSI Go - GitHub](https://github.com/lets-fiware/ngsi-go)
-   [NGSI Go - Full documentation](https://ngsi-go.letsfiware.jp/)
