# QuantumLeap

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

| 変数名                    | 説明                                                       | 既定値 |
| ------------------------- | ---------------------------------------------------------- | ------ |
| QUANTUMLEAP               | QuantumLeap のサブドメイン名                               | (なし) |
| QUANTUMLEAP\_EXPOSE\_PORT | Quantumleap のポートを公開。(none, local または all)       | none   |
| QUANTUMLEAP\_LOGLEVEL     | Quantumleap のロギング・レベルを設定。(INFO, または DEBUG) | INFO   |

<a name="how-to-setup"></a>

## 設定方法

QuantumLeap を設定するには、config.sh の環境変数を構成します。
次のように、QuantumLeap のサブドメイン名を `QUANTUMLEAP=` に設定します:

```bash
QUANTUMLEAP=quantumleap
```

<a name="related-information"></a>

## 関連情報

-   [NGSI Timeseries API - GitHub](https://github.com/orchestracities/ngsi-timeseries-api)
-   [QuantumLeap - Read the docs](https://quantumleap.readthedocs.io/en/latest/)
-   [QuantumLeap API - SwaggerHub](https://app.swaggerhub.com/apis/smartsdk/ngsi-tsdb/)
-   [Time-Series Data - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/time-series-data.html)
-   [NGSI Go tutorial for QuantumLeap](https://ngsi-go.letsfiware.jp/tutorial/quantumleap/)
-   [orchestracities/quantumleap - Docker Hub](https://hub.docker.com/r/orchestracities/quantumleap)
