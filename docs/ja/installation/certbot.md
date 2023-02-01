# Certbot

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [構成パラメータ](#configuration-parameters)

</details>

<a name="configuration-parameters"></a>

## 構成パラメータ

`config.sh` ファイルを編集して構成を指定できます。

| 変数名               | 説明                                                | 既定値                                   |
| -------------------- | --------------------------------------------------- | ---------------------------------------- |
| CERT\_EMAIL          | certbot のメールアドレス                            | (Keyrock の管理者ユーザのメールアドレス) |
| CERT\_REVOKE         | 証明書を取り消して再取得。true または false         | false                                    |
| CERT\_TEST           | --test-cert オプションを使用。true または false     | false                                    |
| CERT\_FORCE\_RENEWAL | --force-renewal オプションを使用。true または false | false                                    |
