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
  "version" : "4.0.0",
  "uptime" : "0 d, 0 h, 0 m, 1 s",
  "git_hash" : "4f9f34df07395c54387a53074f98bef00b1130a3",
  "compile_time" : "Thu Jun 6 07:35:47 UTC 2024",
  "compiled_by" : "root",
  "compiled_in" : "buildkitsandbox",
  "release_date" : "Thu Jun 6 07:35:47 UTC 2024",
  "machine" : "x86_64",
  "doc" : "https://fiware-orion.rtfd.io/en/4.0.0/"
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
