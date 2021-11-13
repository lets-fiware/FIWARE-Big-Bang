# WireCloud

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Sanity check for WireCloud](#~anity-check-for-wirecloud)
-   [Related information](#related-information)

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name | Description                    | Default value |
| ------------- | ------------------------------ | ------------- |
| WIRECLOUD     | A sub-domain name of WireCloud | (empty)       |
| NGSIPROXY     | A sub-domain name of Ngsiproxy | (empty)       |

## How to setup

To set up WireCloud, configure an environment variable in config.sh.
Set a sub-domain name for WireCloud and Ngsiproxy to `WIRECLOUD` as `NGSIPROXY` as shown:

```bash
WIRECLOUD=wirecloud
NGSIPROXY=ngsiproxy
```

## Sanity check for WireCloud 

Once Orion is running, you can access the WireCloud web application.
Open at `https://wirecloud.example.com` to access the WireCloud GUI.

## Related information

-   [WireCloud - GitHub](https://github.com/Wirecloud/wirecloud)
-   [Docker WireCloud - GitHub](https://github.com/Wirecloud/docker-wirecloud)
-   [WireCloud - Read the docs](https://wirecloud.readthedocs.io/en/stable/)
-   [NGSI.js reference documentation](https://ficodes.github.io/ngsijs/stable/NGSI.html)
-   [Application Mashups - FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/application-mashups.html)
