# Orion-LD

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

| 変数名                        | 説明                                                         | 既定値     |
| ----------------------------- | ------------------------------------------------------------ | ---------- |
| ORION\_LD                     | Orion-LD のサブドメイン名                                    | orion      |
| ORION\_LD\_EXPOSE\_PORT       | Orion-LD のポート 1026 を公開。 (none, local または all)     | none       |
| ORION\_LD\_MULTI\_SERVICE     | マルチテナンシーを有効にするかどうか (FALSE, TRUE)           | TRUE       |
| ORION\_LD\_DISABLE\_FILE\_LOG | 速度向上のためファイルログを無効にするかどうか (FALSE, TRUE) | TRUE       |
| MINTAKA                       | Mintaka を有効化。(false, true)                              | true       |
| MINTAKA\_EXPOSE\_PORT         | Mintaka のポート 8080 を公開。 (none, local または all)      | none       |
| TIMESCALE\_PASS               | Timescale DB のパスワード                                    | (自動生成) |
| TIMESCALE\_EXPOSE\_PORT       | Timescale DB のポート 5432 を公開。 (none, local または all) | none       |

<a name="how-to-setup"></a>

## 設定方法

Orion-LD と Mintaka を設定するには、config.sh の環境変数を構成します。
次のように、Orion-LD のサブドメイン名を `ORION_LD=` に設定します:

```bash
ORION_LD=orion-ld
```

<a name="related-information"></a>

## 関連情報

-   [FIWARE / context.Orion-LD - GitHub](https://github.com/FIWARE/context.Orion-LD)
-   [FIWARE / mintaka](https://github.com/fiware/mintaka)
-   [ETSI GS CIM 009 V1.5.1 (2021-11)](https://www.etsi.org/deliver/etsi_gs/CIM/001_099/009/01.05.01_60/gs_CIM009v010501p.pdf)
-   [ETSI ISG CIM / NGSI-LD API - Swagger](https://forge.etsi.org/swagger/ui/?url=https://forge.etsi.org/rep/NGSI-LD/NGSI-LD/raw/master/spec/updated/generated/full_api.json)
-   [FIWARE Step-By-Step Tutorials for NGSI-LD](https://ngsi-ld-tutorials.readthedocs.io/en/latest/)
-   [NGSI Go tutorial for NGSI-LD](https://ngsi-go.letsfiware.jp/tutorial/ngsi-ld-crud/)
-   [fiware/orion-ld - Docker Hub](https://hub.docker.com/r/fiware/orion-ld)
