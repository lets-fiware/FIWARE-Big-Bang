# Keyrock

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

| 変数名            | 説明                                                                              | 既定値                          |
| ----------------- | --------------------------------------------------------------------------------- | ------------------------------- |
| KEYROCK           | Keyrock のサブドメイン名 (必須)                                                   | keyrock                         |
| IDM\_ADMIN\_USER  | Keyrock の管理者ユーザの名前                                                      | admin                           |
| IDM\_ADMIN\_EMAIL | Keyrock の管理者ユーザのメールアドレス                                            | IDM\_ADMIN\_USER @ DOMAIN\_NAME |
| IDM\_ADMIN\_PASS  | Keyrock の管理者ユーザのパスワード                                                | (自動生成)                      |
| IDM\_DEBUG        | Keyrock のロギングを使用。(true または false)                                     | false                           |
| POSTFIX           | Postfix を使用 (ローカル配信)。(true または false)                                | false                           |

<a name="how-to-setup"></a>

## 設定方法

Keyrock を設定するには、config.sh の環境変数を構成します。
次のように、Keyrock のサブドメイン名を `KEYROCK` に設定します:

```bash
KEYROCK=keyrock
```

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
