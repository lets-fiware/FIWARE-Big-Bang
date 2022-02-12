# Orion

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Sanity check for Orion](#sanity-check-for-orion)
-   [Examples](#examples)
-   [Related information](#related-information)

</details>

## Sanity check for Orion

Once Orion is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host orion.example.com
```

#### Response:

```json
{
"orion" : {
  "version" : "3.5.1",
  "uptime" : "0 d, 0 h, 0 m, 1 s",
  "git_hash" : "56593100c692ae943fdfbc14be5f27d0e6908adb",
  "compile_time" : "Sun Feb 6 21:02:25 UTC 2022",
  "compiled_by" : "root",
  "compiled_in" : "bf3518e8dd0b",
  "release_date" : "Sun Feb 6 21:02:25 UTC 2022",
  "machine" : "x86_64",
  "doc" : "https://fiware-orion.rtfd.io/en/3.5.1/",
  "libversions": {
     "boost": "1_66",
     "libcurl": "libcurl/7.61.1 OpenSSL/1.1.1k zlib/1.2.11 nghttp2/1.33.0",
     "libmosquitto": "2.0.12",
     "libmicrohttpd": "0.9.70",
     "openssl": "1.1",
     "rapidjson": "1.1.0",
     "mongoc": "1.17.4",
     "bson": "1.17.4"
  }
}
}
```

## Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/orion).

## Related information

-   [FIWARE Orion - GitHub](https://github.com/telefonicaid/fiware-orion)
-   [FIWARE Orion - Read the Docs](https://fiware-orion.readthedocs.io/en/master/)
-   [FIWARE-NGSI v2 Specification](http://telefonicaid.github.io/fiware-orion/api/v2/stable/)
-   [FIWARE-NGSI Simple API (v2) Cookbook](http://telefonicaid.github.io/fiware-orion/api/v2/stable/cookbook/)
-   [Introductory presentations](https://www.slideshare.net/fermingalan/orion-context-broker-20211022)
-   [FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/)
-   [NGSI Go tutorial for NGSIv2](https://ngsi-go.letsfiware.jp/tutorial/ngsi-v2-crud/)
-   [telefonicaiot/fiware-orion - Docker Hub](https://hub.docker.com/r/telefonicaiot/fiware-orion)
