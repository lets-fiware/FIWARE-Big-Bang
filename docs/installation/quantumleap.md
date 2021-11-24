# QuantumLeap

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Related information](#related-information)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name             | Description                                      | Default value |
| ------------------------- | ------------------------------------------------ | ------------- |
| QUANTUMLEAP               | A sub-domain name of QuantumLeap                 | (empty)       |
| QUANTUMLEAP\_EXPOSE\_PORT | Expose port for Quantumleap. (none, local, all)  | none          |
| QUANTUMLEAP\_LOGLEVEL     | Set logging level for Quantumleap. (INFO, DEBUG) | INFO          |

## How to setup

To set up QuantumLeap, configure an environment variable in config.sh.
Set a sub-domain name for QuantumLeap to `QUANTUMLEAP=` as shown:

```bash
QUANTUMLEAP=quantumleap
```

## Related information

-   [NGSI Timeseries API - GitHub](https://github.com/orchestracities/ngsi-timeseries-api)
-   [QuantumLeap - Read the docs](https://quantumleap.readthedocs.io/en/latest/)
-   [QuantumLeap API - SwaggerHub](https://app.swaggerhub.com/apis/smartsdk/ngsi-tsdb/)
-   [Time-Series Data - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/time-series-data.html)
-   [NGSI Go tutorial for QuantumLeap](https://ngsi-go.letsfiware.jp/tutorial/quantumleap/)
