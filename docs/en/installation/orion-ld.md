# Orion-LD

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Related information](#related-information)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name                 | Description                                             | Default value             |
| ----------------------------- | ------------------------------------------------------- | ------------------------- |
| ORION\_LD                     | A sub-domain name of Orion-LD.                          | orion                     |
| ORION\_LD\_EXPOSE\_PORT       | Expose port 1026 for Orion-LD. (none, local or all)     | none                      |
| ORION\_LD\_MULTI\_SERVICE     | Whether to enable multitenancy (FALSE, TRUE)            | TRUE                      |
| ORION\_LD\_DISABLE\_FILE\_LOG | The file log is disabled to improve speed (FALSE, TRUE) | TRUE                      |
| MINTAKA                       | Enable Mintaka (false, true)                            | true                      |
| MINTAKA\_EXPOSE\_PORT         | Expose port 8080 for Mintaka. (none, local or all)      | none                      |
| TIMESCALE\_PASS               | Set a password for Timescale DB.                        | (automatically generated) |
| TIMESCALE\_EXPOSE\_PORT       | Expose port 5432 for Timescale. (none, local or all)    | none                      |

## How to setup

To set up Orion-LD and Mintaka, configure an environment variable in config.sh.
Set a sub-domain name for Orion-LD to `ORION_LD=` as shown:

```bash
ORION_LD=orion-ld
```

## Related information

-   [FIWARE / context.Orion-LD - GitHub](https://github.com/FIWARE/context.Orion-LD)
-   [FIWARE / mintaka](https://github.com/fiware/mintaka)
-   [ETSI GS CIM 009 V1.5.1 (2021-11)](https://www.etsi.org/deliver/etsi_gs/CIM/001_099/009/01.05.01_60/gs_CIM009v010501p.pdf)
-   [ETSI ISG CIM / NGSI-LD API - Swagger](https://forge.etsi.org/swagger/ui/?url=https://forge.etsi.org/rep/NGSI-LD/NGSI-LD/raw/master/spec/updated/generated/full_api.json)
-   [FIWARE Step-By-Step Tutorials for NGSI-LD](https://ngsi-ld-tutorials.readthedocs.io/en/latest/)
-   [NGSI Go tutorial for NGSI-LD](https://ngsi-go.letsfiware.jp/tutorial/ngsi-ld-crud/)
-   [fiware/orion-ld - Docker Hub](https://hub.docker.com/r/fiware/orion-ld)
