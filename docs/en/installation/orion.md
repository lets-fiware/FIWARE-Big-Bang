# Orion

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Related information](#related-information)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name                          | Description                                       | Default value                                                                                       |
| -------------------------------------- | ------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| ORION                                  | A sub-domain name of Orion.                       | orion                                                                                               |
| ORION\_EXPOSE\_PORT                    | Expose port 1026. (none, local, all)              | none                                                                                                |
| ORION\_CORS                            | Enable cross-origin resource sharing (CORS)       | false                                                                                               |
| ORION\_ACCESS\_CONTROL\_ALLOW\_ORIGIN  | Set Access-Control-Allow-Origin header for CORS   | '\*'                                                                                                |
| ORION\_ACCESS\_CONTROL\_ALLOW\_METHODS | Set Access-Control-Allow-Methods header for CORS  | 'GET, POST, OPTIONS, DELETE, PUT, PATCH'                                                            |
| ORION\_ACCESS\_CONTROL\_ALLOW\_HEADERS | Set Access-Control-Allow-Headers header for CORS  | 'Origin, Content-Type, Accept, Authorization, X-Requested-With, fiware-service, fiware-servicepath' |
| ORION\_CONTROL\_EXPOSE\_HEADERS        | Set Access-Control-Expose-Headers header for CORS | 'location, fiware-correlator'                                                                       |
| ORION\_ACCESS\_CONTROL\_MAX\_AGE       | Set Access-Control-Max-Age header for CORS        | 7200                                                                                                |

## How to setup

To set up Orion, configure an environment variable in config.sh.
Set a sub-domain name for Orion to `ORION=` as shown:

```bash
ORION=orion
```

## Related information

-   [FIWARE Orion - GitHub](https://github.com/telefonicaid/fiware-orion)
-   [FIWARE Orion - Read the Docs](https://fiware-orion.readthedocs.io/en/master/)
-   [FIWARE-NGSI v2 Specification](http://telefonicaid.github.io/fiware-orion/api/v2/stable/)
-   [FIWARE-NGSI Simple API (v2) Cookbook](http://telefonicaid.github.io/fiware-orion/api/v2/stable/cookbook/)
-   [Introductory presentations](https://www.slideshare.net/fermingalan/orion-context-broker-20211022)
-   [FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/)
-   [NGSI Go tutorial for NGSIv2](https://ngsi-go.letsfiware.jp/tutorial/ngsi-v2-crud/)
-   [telefonicaiot/fiware-orion - Docker Hub](https://hub.docker.com/r/telefonicaiot/fiware-orion)
