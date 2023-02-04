# WireCloud

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Related information](#related-information)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name | Description                    | Default value |
| ------------- | ------------------------------ | ------------- |
| WIRECLOUD     | A sub-domain name of WireCloud | (empty)       |
| NGSIPROXY     | A sub-domain name of Ngsiproxy | (empty)       |

## How to setup

To set up WireCloud, configure an environment variable in config.sh.
Set a sub-domain name for WireCloud and Ngsiproxy to `WIRECLOUD=` and `NGSIPROXY=` as shown:

```bash
WIRECLOUD=wirecloud
NGSIPROXY=ngsiproxy
```

## Related information

-   [WireCloud - GitHub](https://github.com/Wirecloud/wirecloud)
-   [Docker WireCloud - GitHub](https://github.com/Wirecloud/docker-wirecloud)
-   [WireCloud - Read the docs](https://wirecloud.readthedocs.io/en/stable/)
-   [NGSI.js reference documentation](https://ficodes.github.io/ngsijs/stable/NGSI.html)
-   [Application Mashups - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/application-mashups.html)
-   [fiware/wirecloud - Docker Hub](https://hub.docker.com/r/fiware/wirecloud)
