# Orion

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

| 変数名              | 説明                                                 | 既定値 |
| ------------------- | ---------------------------------------------------- | ------ |
| ORION               | Orion のサブドメイン名                               | orion  | 
| ORION\_EXPOSE\_PORT | Orion のポート 1026 を公開。(none, local または all) | none   |
| ORION\_CORS         | Cross-origin resource sharing (CORS) を有効化        | false  |

<a name="how-to-setup"></a>

## 設定方法

Orion を設定するには、config.sh の環境変数を構成します。
次のように、Orion のサブドメイン名を `ORION=` に設定します:

```bash
ORION=orion
```

<a name="related-information"></a>

## 関連情報

-   [FIWARE Orion - GitHub](https://github.com/telefonicaid/fiware-orion)
-   [FIWARE Orion - Read the Docs](https://fiware-orion.readthedocs.io/en/master/)
-   [FIWARE-NGSI v2 Specification](http://telefonicaid.github.io/fiware-orion/api/v2/stable/)
-   [FIWARE-NGSI Simple API (v2) Cookbook](http://telefonicaid.github.io/fiware-orion/api/v2/stable/cookbook/)
-   [Introductory presentations](https://www.slideshare.net/fermingalan/orion-context-broker-20211022)
-   [FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/)
-   [NGSI Go tutorial for NGSIv2](https://ngsi-go.letsfiware.jp/tutorial/ngsi-v2-crud/)
-   [telefonicaiot/fiware-orion - Docker Hub](https://hub.docker.com/r/telefonicaiot/fiware-orion)
