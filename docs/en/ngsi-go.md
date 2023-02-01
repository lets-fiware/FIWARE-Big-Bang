# NGSI Go

The NGSI Go is a command-line interface supporting FIWARE Open APIs for FIWARE developers.
You will have easy access to FIWARE Open APIs by installing NGSI Go on your client PC.
See full documentation [here](https://ngsi-go.letsfiware.jp/) for details.

## Install

### Install NGSI Go binary

The NGSI Go binary is installed in `/usr/local/bin`.

#### Installation on Linux

```console
curl -OL https://github.com/lets-fiware/ngsi-go/releases/download/v0.12.0/ngsi-v0.12.0-linux-amd64.tar.gz
sudo tar zxvf ngsi-v0.12.0-linux-amd64.tar.gz -C /usr/local/bin
```

`ngsi-v0.12.0-linux-arm.tar.gz` and `ngsi-v0.12.0-linux-arm64.tar.gz` binaries are also available.

#### Installation on Mac

```console
curl -OL https://github.com/lets-fiware/ngsi-go/releases/download/v0.12.0/ngsi-v0.12.0-darwin-amd64.tar.gz
sudo tar zxvf ngsi-v0.12.0-darwin-amd64.tar.gz -C /usr/local/bin
```

`ngsi-v0.12.0-darwin-arm64.tar.gz` binary is also available.

### Install bash autocomplete file for NGSI Go

Install ngsi_bash_autocomplete file in `/etc/bash_completion.d`.

```console
curl -OL https://raw.githubusercontent.com/lets-fiware/ngsi-go/main/autocomplete/ngsi_bash_autocomplete
sudo mv ngsi_bash_autocomplete /etc/bash_completion.d/
source /etc/bash_completion.d/ngsi_bash_autocomplete
echo "source /etc/bash_completion.d/ngsi_bash_autocomplete" >> ~/.bashrc
```

## Set up

The followings are setting-up examples to access each FIWARE GE.

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

## Related information

-   [NGSI Go - GitHub](https://github.com/lets-fiware/ngsi-go)
-   [NGSI Go - Full documentation](https://ngsi-go.letsfiware.jp/)
