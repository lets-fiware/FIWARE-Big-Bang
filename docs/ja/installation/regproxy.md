# Regproxy

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [構成パラメータ](#configuration-parameters)
-   [設定方法](#how-to-setup)
-   [関連情報](#related-information)

</details>

<a name="configuration-parameters"></a>

## 構成パラメータ

`config.sh` ファイルを編集して構成を指定できます。

| 変数名            | 説明                                                   | 既定値 |
| ------------------------ | ----------------------------------------------- | ------ |
| REGPROXY                 | Regproxyを使用するかどうか。(true または false) | false  |
| REGPROXY\_NGSITYPE       | リモート・ブローカーの NgsiType。(v2 また ld)   | v2     |
| REGPROXY\_HOST           | リモート・ブローカーのホスト                    | (なし) |
| REGPROXY\_IDMTYPE        | リモート・ブローカーの IdM タイプ               | (なし) |
| REGPROXY\_IDMHOST        | リモート・ブローカーの IdM ホスト               | (なし) |
| REGPROXY\_USERNAME       | リモート・ブローカーのユーザ名                  | (なし) |
| REGPROXY\_PASSWORD       | リモート・ブローカーのパスワード                | (なし) |
| REGPROXY\_CLIENT\_ID     | リモート・ブローカーの client id                | (なし) |
| REGPROXY\_CLIENT\_SECRET | リモート・ブローカーの client secret            | (なし) |

<a name="how-to-setup"></a>

## 設定方法

```bash
REGPROXY=false
REGPROXY_HOST=https://remote-orion.example.com/
REGPROXY_IDMTYPE=keyrock
REGPROXY_IDMHOST=http://keyrock.example.com/oauth2/token
REGPROXY_USERNAME=admin@test.com
REGPROXY_PASSWORD=1234
REGPROXY_CLIENT_ID=a1a6048b-df1d-4d4f-9a08-5cf836041d14
REGPROXY_CLIENT_SECRET=e4cc0147-e38f-4211-b8ad-8ae5e6a107f9
```

<a name="related-information"></a>

## 関連情報

-   [regproxy - NGSI Go](https://ngsi-go.letsfiware.jp/convenience/regproxy/)
-   [regproxy example - NGSI Go](https://github.com/lets-fiware/ngsi-go/tree/main/extras/registration_proxy)
