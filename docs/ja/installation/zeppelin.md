# Apache Zeppelin (実験的サポート)

<details>
<summary><strong>詳細</strong></summary>

-   [構成パラメータ](#configuration-parameters)
-   [設定方法](#how-to-setup)
-   [関連情報](#related-information)

</details>

<a name="configuration-parameters"></a>

## 構成パラメータ

`config.sh` ファイルを編集して構成を指定できます。

| 変数名          | 説明                        | 既定値 |
| --------------- | --------------------------- | ------ |
| ZEPPELIN        | Zeppelin のサブドメイン名   | (なし) |
| ZEPPELIN\_DEBUG | Zeppelin のロギング・レベル | false  |

<a name="how-to-setup"></a>

## 設定方法

Zeppelin を設定するには、config.sh の環境変数を構成します。
次のように、Zeppelin のサブドメイン名を `ZEPPELIN=` に設定します:

```bash
ZEPPELIN=zeppelin
```

<a name="related-information"></a>

## 関連情報

-   [Apache Zeppelin](https://zeppelin.apache.org/)
-   [Zeppelin - GitHub](https://github.com/apache/zeppelin)
