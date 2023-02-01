# Perseo

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

| 変数名               | 説明                                                        | 既定値 |
| -------------------- | ----------------------------------------------------------- | ------ |
| PERSEO               | Perseo のサブドメイン名                                     | (なし) |
| PERSEO\_MAX\_AGE     | ダングリング・ルール (dangling rules) の有効期限 (ミリ秒)   | 6000   |
| PERSEO\_SMTP\_HOST   | Perseo の SMTP サーバのホスト.                              | (なし) |
| PERSEO\_SMTP\_PORT   | Perseo の SMTP サーバのポート                               | (なし) |
| PERSEO\_SMTP\_SECURE | SMTP サーバーで SSL を使用するかどうか。(true または false) | (なし) |
| PERSEO\_LOG\_LEVEL   | Perseo のロギング・レベルを設定                             | info   |

<a name="how-to-setup"></a>

## 設定方法

Perseo を設定するには、config.sh の環境変数を構成します。
次のように、Perseo のサブドメイン名を `PERSEO=` に設定します:

```bash
PERSEO=perseo
```

<a name="related-information"></a>

## 関連情報

-   [Perseo Context-Aware CEP - GitHub](https://github.com/telefonicaid/perseo-fe)
-   [Perseo-core (EPL server) - GitHub](https://github.com/telefonicaid/perseo-core)
-   [NGSI Go tutorial for Perseo](https://ngsi-go.letsfiware.jp/tutorial/perseo/)
-   [telefonicaiot/perseo-fe - Docker Hub](https://hub.docker.com/r/telefonicaiot/perseo-fe)
-   [telefonicaiot/perseo-core - Docker Hub](https://hub.docker.com/r/telefonicaiot/perseo-core)
