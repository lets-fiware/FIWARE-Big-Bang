# Comet

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [構成パラメータ](#configuration-parameters)
-   [設定方法](#how-to-setup)
    -   [最小モード (STH-Comet ONLY)](#minimal-mode-sth-comet-only)
    -   [フォーマル・モード (Cygnus + STH-Comet)](#formal-mode-cygnus--sth-comet)
-   [関連情報](#related-information)

</details>

<a name="configuration-parameters"></a>

## 構成パラメータ

`config.sh` ファイルを編集して構成を指定できます。

| 変数名               | 説明                                                                    | 既定値 |
| -------------------- | ----------------------------------------------------------------------- | ------ |
| COMET                | Comet のサブドメイン名                                                  | (なし) |
| CYGNUS               | Cygnus のサブドメイン名                                                 | (なし) |
| COMET\_EXPOSE\_PORT  | Comet のポート 8666 を公開。(none, local または all)                    | none   |
| COMET\_LOGOPS\_LEVEL | Comet のロギング・レベルを設定。(DEBUG, INFO, WARN, ERROR または FATAL) | INFO   |

<a name="how-to-setup"></a>

## 設定方法

<a name="minimal-mode-sth-comet-only"></a>

### 最小モード (STH-Comet のみ)

最小モードでは、時系列コンテキスト・データが Comet を介して MongoDB に保持されます。最小モード (STH-Comet のみ)
で Comet を設定するには、config.sh で環境変数を設定します。次のように、Comet のサブドメイン名を `COMET=`
に設定します:

```bash
COMET=comet
```

<a name="formal-mode-cygnus--sth-comet"></a>

### フォーマル・モード (Cygnus と STH-Comet)

フォーマル・モードでは、時系列コンテキスト・データを Cygnus を介して MongoDB に永続化します。フォーマル・モード
(Cygnus と STH-Comet) で Comet を設定するには、config.sh で環境変数を設定します。次のように、Comet と Cygnus
のサブドメイン名を `COMET=` と `CYGNUS=` に設定します:

```bash
COMET=comet
CYGNUS=cygnus
```

<a name="related-information"></a>

## 関連情報

-   [STH-Comet - GitHub](https://github.com/telefonicaid/fiware-sth-comet)
-   [STH-Comet - Read the docs](https://fiware-sth-comet.readthedocs.io/en/latest/)
-   [Short Term History - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/short-term-history.html)
-   [NGSI Go tutorial for STH-Comet](https://ngsi-go.letsfiware.jp/tutorial/comet/)
-   [telefonicaiot/fiware-sth-comet - Docker Hub](https://hub.docker.com/r/telefonicaiot/fiware-sth-comet)
