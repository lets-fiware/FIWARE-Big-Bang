# Keyrock

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [Keyrock の健全性チェック](#sanity-check-for-keyrock)
-   [Keyrock GUI へのアクセス](#access-keyrock-gui)
-   [例](#examples)
-   [関連情報](#related-information)

</details>

<a name="sanity-check-for-keyrock"></a>

## Sanity check for Keyrock の健全性チェック

Keyrock が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host keyrock.example.com --pretty
```

#### レスポンス:

```json
{
  "keyrock": {
    "version": "8.1.0",
    "release_date": "2021-07-22",
    "uptime": "00:23:14.3",
    "git_hash": "https://github.com/ging/fiware-idm/releases/tag/8.1.0",
    "doc": "https://fiware-idm.readthedocs.io/en/8.1.0/",
    "api": {
      "version": "v1",
      "link": "https://keyrock.example.com/v1"
    }
  }
}
```

<a name="access-keyrock-gui"></a>

## Access Keyrock GUI へのアクセス

Web ブラウザで、`https://keyrock.example.com` で開き、Keyrock GUI にアクセスします:

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/keyrock/keyrock-sign-in.png)

## ユーザの作成

次の例を実行するには、`example.com` をドメインまたはサブドメインに置き換えます。別のドメインの電子メール・
アドレスを持つユーザを追加する場合は、それを行う前に、ドメインを `config/keyrock/whitelist.txt` に追加して、
Keyrock インスタンスを再起動します。FIWARE Big Bangは、Keyrock インスタンスを、email list typeとして `whitelist`
でセットアップします。詳細については、[Keyrock のドキュメント](https://fiware-idm.readthedocs.io/en/latest/installation_and_administration_guide/configuration/index.html#email-filtering)
を参照してください 。

### ユーザの作成

#### リクエスト:

```bash
ngsi users create --host keyrock.example.com --username user001 --email user001@example.com --password 1234
```

#### レスポンス:

```text
36d8086c-4fc4-4954-9ee2-592e7debe5a0
```

#### リクエスト:

```bash
ngsi users get --uid 36d8086c-4fc4-4954-9ee2-592e7debe5a0 --pretty
```

#### レスポンス:

```json
{
  "user": {
    "scope": [],
    "id": "36d8086c-4fc4-4954-9ee2-592e7debe5a0",
    "username": "user001",
    "email": "user001@example.com",
    "enabled": true,
    "admin": false,
    "image": "default",
    "gravatar": false,
    "date_password": "2021-12-18T21:26:30.000Z",
    "description": null,
    "website": null
  }
}
```

### 複数ユーザの作成

#### リクエスト:

```bash
#!/bin/sh
set -ue

HOST=keyrock
DOMAIN=example.com

for id in $(seq 10)
do
 USER=$(printf "user%03d" $id)
 PASS=$(pwgen -s 16 1)
 ngsi users create --host "${HOST}.${DOMAIN}" --username "${USER}" --email "${USER}@${DOMAIN}" --password "${PASS}" > /dev/null
 echo "${USER}@${DOMAIN} ${PASS}"
done
```

#### レスポンス:

```text
user001@example.com Uu2HADXh5ITIlIVt
user002@example.com Gbf4njxTp3tZApje
user003@example.com J6aNl3phuOurh8x8
user004@example.com 2Jm5bP7RJJmMD6D9
user005@example.com midj714vE8pD9ULs
user006@example.com jbrk2SC3SdVNsW8W
user007@example.com wlxTAGdRHU6ESmRa
user008@example.com sBfWNhVaye0zLHWh
user009@example.com R6ES3ezcdTXst2TI
user010@example.com A2djP94QYrH2LgVw
```

`pwgen` プログラムはパスワードを生成します。以下の手順に従ってインストールできます:

-   Ubuntu

```bash
apt update
apt install -y pwgen
```

-   Rocky Linux または AlmaLinux

```bash
yum install -y epel-release
yum install -y pwgen
```

<a name="examples"></a>

## 例

[こちら](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/keyrock)の例を参照ください。

<a name="related-information"></a>

## 関連情報

-   [Keyrock - GitHub](https://github.com/ging/fiware-idm)
-   [Keyrock portal site](https://keyrock-fiware.github.io/)
-   [Keyrock API - Apiary](https://keyrock.docs.apiary.io/#)
-   [Keyrock - Read the docs](https://fiware-idm.readthedocs.io/)
-   [Identity Management - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/identity-management.html)
-   [NGSI Go tutorial for Keyrock](https://ngsi-go.letsfiware.jp/tutorial/keyrock/)
-   [ging/fiware-idm - Docker Hub](https://hub.docker.com/r/ging/fiware-idm)
-   [ging/fiware-pep-proxy - Docker Hub](https://hub.docker.com/r/ging/fiware-pep-proxy)
