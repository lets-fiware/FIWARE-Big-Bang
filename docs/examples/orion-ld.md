# Orion

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Sanity check for Orion-LD](#sanity-check-for-orion-ld)
-   [Examples](#examples)
-   [Related information](#related-information)

</details>

## Sanity check for Orion-LD

Once Orion-LD is running, you can check the status by the following command:

#### Request:

```bash
ngsi version --host orion-ld.example.com
```

#### Response:

```json
{
  "Orion-LD version": "1.0.1-PRE-468",
  "based on orion": "1.15.0-next",
  "kbase version": "0.8",
  "kalloc version": "0.8",
  "khash version": "0.8",
  "kjson version": "0.8",
  "microhttpd version": "0.9.72-0",
  "rapidjson version": "1.0.2",
  "libcurl version": "7.61.1",
  "libuuid version": "UNKNOWN",
  "mongocpp version": "1.1.3",
  "mongoc version": "1.17.5",
  "mongodb server version": "4.4.11",
  "boost version": "1_66",
  "openssl version": "OpenSSL 1.1.1k  FIPS 25 Mar 2021",
  "branch": "",
  "cached subscriptions": 0,
  "Next File Descriptor": 20
}
```

## Sanity check for Mitaka

When enabling Mintaka you can check the status by the following command:

#### Request:

```
curl -s https://orion-ld.example.com/ngsi-ld/ex/mintaka/info \
  --header "Authorization: Bearer ${ACCESS_TOKEN}"
```

#### Response:

```
{
  "git": {
    "revision": "ff00861774957067d89b1262f9a0dde7bc9c0c79"
  },
  "build": {
    "time": "24 January 2022, 12:51:28 +0000"
  },
  "project": {
    "artifact-id": "mintaka",
    "group-id": "org.fiware",
    "version": "0.4.1"
  }
}
```

## Examples

Look at examples [here](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/orion-ld).

## Related information

-   [FIWARE / context.Orion-LD - GitHub](https://github.com/FIWARE/context.Orion-LD)
-   [FIWARE / mintaka](https://github.com/fiware/mintaka)
-   [ETSI GS CIM 009 V1.5.1 (2021-11)](https://www.etsi.org/deliver/etsi_gs/CIM/001_099/009/01.05.01_60/gs_CIM009v010501p.pdf)
-   [ETSI ISG CIM / NGSI-LD API - Swagger](https://forge.etsi.org/swagger/ui/?url=https://forge.etsi.org/rep/NGSI-LD/NGSI-LD/raw/master/spec/updated/generated/full_api.json)
-   [FIWARE Step-By-Step Tutorials for NGSI-LD](https://ngsi-ld-tutorials.readthedocs.io/en/latest/)
-   [NGSI Go tutorial for NGSI-LD](https://ngsi-go.letsfiware.jp/tutorial/ngsi-ld-crud/)
-   [fiware/orion-ld - Docker Hub](https://hub.docker.com/r/fiware/orion-ld)
