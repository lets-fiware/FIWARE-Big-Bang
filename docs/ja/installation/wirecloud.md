# WireCloud

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

| 変数名        | 説明                                            | 既定値 |
| ------------- | ----------------------------------------------- | ------ |
| WIRECLOUD     | A sub-domain name of WireCloud のサブドメイン名 | (なし) |
| NGSIPROXY     | A sub-domain name of Ngsiproxy のサブドメイン名 | (なし) |
 
<a name="how-to-setup"></a>

## 設定方法

WireCloud を設定するには、config.sh の環境変数を構成します。
次のように、WireCloud と Ngsiproxy のサブドメイン名を `WIRECLOUD=` と `NGSIPROXY=`
に設定します:

```bash
WIRECLOUD=wirecloud
NGSIPROXY=ngsiproxy
```

<a name="related-information"></a>

## 関連情報

-   [WireCloud - GitHub](https://github.com/Wirecloud/wirecloud)
-   [Docker WireCloud - GitHub](https://github.com/Wirecloud/docker-wirecloud)
-   [WireCloud - Read the docs](https://wirecloud.readthedocs.io/en/stable/)
-   [NGSI.js reference documentation](https://ficodes.github.io/ngsijs/stable/NGSI.html)
-   [Application Mashups - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/application-mashups.html)
-   [fiware/wirecloud - Docker Hub](https://hub.docker.com/r/fiware/wirecloud)
