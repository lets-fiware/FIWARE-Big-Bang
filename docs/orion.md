# Orion

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)
-   [Get version](#get-version)
-   [Sanity check for Orion](#sanity-check-for-orion)
-   [Related information](#related-information)

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name | Description                           | Default value |
| ------------- | ------------------------------------- | ------------- |
| ORION         | A sub-domain name of Orion (Required) | orion         | 

## How to setup

To set up Orion, configure an environment variable in config.sh.
Set a sub-domain name for Orion to `ORION` as shown:

```bash
ORION=orion
```

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
  "version" : "3.3.1",
  "uptime" : "0 d, 0 h, 0 m, 1 s",
  "git_hash" : "a9ff9652c7b93240f48d2b497783407a80861370",
  "compile_time" : "Thu Nov 11 10:08:31 UTC 2021",
  "compiled_by" : "root",
  "compiled_in" : "831b4bc01053",
  "release_date" : "Thu Nov 11 10:08:31 UTC 2021",
  "machine" : "x86_64",
  "doc" : "https://fiware-orion.rtfd.io/en/3.3.1/",
  "libversions": {
     "boost": "1_66",
     "libcurl": "libcurl/7.61.1 OpenSSL/1.1.1g zlib/1.2.11 nghttp2/1.33.0",
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

## Related information

-   [FIWARE Orion - GitHub](https://github.com/telefonicaid/fiware-orion)
-   [FIWARE Orion - Read the Docs](https://fiware-orion.readthedocs.io/en/master/)
-   [FIWARE-NGSI v2 Specification](http://telefonicaid.github.io/fiware-orion/api/v2/stable/)
-   [FIWARE-NGSI Simple API (v2) Cookbook](http://telefonicaid.github.io/fiware-orion/api/v2/stable/cookbook/)
-   [Introductory presentations](https://www.slideshare.net/fermingalan/orion-context-broker-20211022)
-   [FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/)
-   [NGSI Go tutorial for NGSIv2](https://ngsi-go.letsfiware.jp/tutorial/ngsi-v2-crud/)
