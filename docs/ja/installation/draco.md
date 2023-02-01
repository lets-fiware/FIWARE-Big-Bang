# Draco

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

| 変数名                     | 説明                                                  | 既定値 |
| -------------------------- | ----------------------------------------------------- | ------ |
| DRACO                      | Draco のサブドメイン名                                | (なし) |
| DRACO\_MONGO               | Draco に MongoDB シンクを使用。(true または false)    | false  |
| DRACO\_MYSQL               | Draco に MySQL シンクを使用。(true または false)      | false  |
| DRACO\_POSTGRES            | Draco に PostgreSQL シンクを使用。(true または false) | false  |
| DRACO\_EXPOSE\_PORT        | Draco のポート 5050 を公開 (none, local または all)   | none   |
| DRACO\_DISABLE\_NIFI\_DOCS | NiFi ドキュメントのパスを有効化 (/nifi-docs)          | true   |

<a name="how-to-setup"></a>

## 設定方法

Draco を設定するには、config.sh の環境変数を構成します。
最初に、次のように、Draco のサブドメイン名を `DRACO=` に設定します:

```bash
DRACO=draco
```

そして、永続データの保存に使用する1つ以上のデータベースを `true` に設定します:

```bash
DRACO_MONGO=
DRACO_MYSQL=
DRACO_POSTGRES=
```

<a name="related-information"></a>

## 関連情報

-   [ging / fiware-draco - GitHub](https://github.com/ging/fiware-draco)
-   [FIWARE Draco - readthedocs.io](https://fiware-draco.readthedocs.io/en/latest/)
-   [Apache NiFi System Administrator’s Guide](https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html)
-   [ging/fiware-draco - Docker Hub](https://hub.docker.com/r/ging/fiware-draco)
