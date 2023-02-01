# Orion

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [Orion の健全性チェック](#sanity-check-for-orion)
-   [例](#examples)
-   [関連情報](#related-information)

</details>

<a name="sanity-check-for-orion"></a>

## Orion の健全性チェック

Orion が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host orion.example.com
```

#### レスポンス:

```json
{
"orion" : {
  "version" : "3.7.0",
  "uptime" : "0 d, 0 h, 0 m, 1 s",
  "git_hash" : "8b19705a8ec645ba1452cb97847a5615f0b2d3ca",
  "compile_time" : "Thu May 26 11:45:49 UTC 2022",
  "compiled_by" : "root",
  "compiled_in" : "025d96e1419a",
  "release_date" : "Thu May 26 11:45:49 UTC 2022",
  "machine" : "x86_64",
  "doc" : "https://fiware-orion.rtfd.io/en/3.7.0/",
  "libversions": {
     "boost": "1_74",
     "libcurl": "libcurl/7.74.0 OpenSSL/1.1.1n zlib/1.2.11 brotli/1.0.9 libidn2/2.3.0 libpsl/0.21.0 (+libidn2/2.3.0) libssh2/1.9.0 nghttp2/1.43.0 librtmp/2.3",
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

<a name="examples"></a>

## 例

[こちら](https://github.com/lets-fiware/FIWARE-Big-Bang/tree/main/examples/orion)の例を見てください。

<a name="related-information"></a>

## 関連情報

-   [FIWARE Orion - GitHub](https://github.com/telefonicaid/fiware-orion)
-   [FIWARE Orion - Read the Docs](https://fiware-orion.readthedocs.io/en/master/)
-   [FIWARE-NGSI v2 Specification](http://telefonicaid.github.io/fiware-orion/api/v2/stable/)
-   [FIWARE-NGSI Simple API (v2) Cookbook](http://telefonicaid.github.io/fiware-orion/api/v2/stable/cookbook/)
-   [Introductory presentations](https://www.slideshare.net/fermingalan/orion-context-broker-20211022)
-   [FIWARE Step-By-Step Tutorials for NGSIv2](https://fiware-tutorials.readthedocs.io/en/latest/)
-   [NGSI Go tutorial for NGSIv2](https://ngsi-go.letsfiware.jp/tutorial/ngsi-v2-crud/)
-   [telefonicaiot/fiware-orion - Docker Hub](https://hub.docker.com/r/telefonicaiot/fiware-orion)
