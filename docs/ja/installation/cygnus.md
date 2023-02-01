# Cygnus

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

| 変数名                      | 説明                                                                                                                      | 既定値            |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| CYGNUS                      | Cygnus のサブドメイン名                                                                                                   | (なし)            |
| CYGNUS\_MONGO               | Cygnus に MongoDB シンクを使用。(true または false)                                                                       | false             |
| CYGNUS\_MYSQL               | Cygnus に MySQL シンクを使用。(true または false)                                                                         | false             |
| CYGNUS\_POSTGRES            | Cygnus に PostgreSQL シンクを使用。(true または false)                                                                    | false             |
| CYGNUS\_ELASTICSEARCH       | Cygnus に Elasticsearch シンクを使用。(true または false)                                                                 | false             |
| CYGNUS\_EXPOSE\_PORT        | Cygnus のポートを公開。(none, local または all) MongoDB は 5051、MySQL は 5050、PostgreSQL は 5055、Elasticsearch は 5058 | none              |
| CYGNUS\_LOG\_LEVEL          | Cygnus のロギング・レベルを設定。(INFO または DEBUG)                                                                      | info              |
| ELASTICSEARCH               | Elasticsearch のサブドメイン名                                                                                            | (なし)            |
| ELASTICSEARCH\_JAVA\_OPTS   | Elasticsearch の Java オプションを設定                                                                                    | -Xmx256m -Xms256m |
| ELASTICSEARCH\_EXPOSE\_PORT | Elasticsearch のポート 9200 を公開。(none, local または all)                                                              | none              |

<a name="how-to-setup"></a>

## 設定方法

Cygnus を設定するには、config.sh の環境変数を構成します。
最初に、次のように、Cygnus のサブドメイン名を `CYGNUS=` に設定します:

```bash
CYGNUS=cygnus
```

また、次のように、永続データの保存に使用する 1 つ以上のデータベースを `true` に設定します:

```bash
CYGNUS_MONGO=
CYGNUS_MYSQL=
CYGNUS_POSTGRES=
CYGNUS_ELASTICSEARCH=
```

Elasticsearch を使用する場合は、次のように Elasticsearch のサブドメイン名を設定します:

```bash
ELASTICSEARCH=elasticsearch
```

<a name="related-information"></a>

## 関連情報

-   [FIWARE Cygnus documentation](https://fiware-cygnus.readthedocs.io/en/latest/)
-   [FIWARE Cygnus - GitHub](https://github.com/telefonicaid/fiware-cygnus)
-   [Persisting context (Apache Flume) - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/historic-context-flume.html)
