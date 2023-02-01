# Perseo

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [Perseo の健全性チェック](#sanity-check-for-perseo)
-   [関連情報](#related-information)

</details>

<a name="sanity-check-for-perseo"></a>

## Perseo の健全性チェック

Perseo が起動したら、次のコマンドでステータスを確認できます:

#### リクエスト:

```bash
ngsi version --host perseo.example.com --pretty
```

#### レスポンス:

```json
{
  "error": null,
  "data": {
    "name": "perseo",
    "description": "IOT CEP front End",
    "version": "1.20.0"
  }
}
```

<a name="related-information"></a>

## 関連情報

-   [Perseo Context-Aware CEP - GitHub](https://github.com/telefonicaid/perseo-fe)
-   [Perseo-core (EPL server) - GitHub](https://github.com/telefonicaid/perseo-core)
-   [NGSI Go tutorial for Perseo](https://ngsi-go.letsfiware.jp/tutorial/perseo/)
-   [telefonicaiot/perseo-fe - Docker Hub](https://hub.docker.com/r/telefonicaiot/perseo-fe)
-   [telefonicaiot/perseo-core - Docker Hub](https://hub.docker.com/r/telefonicaiot/perseo-core)
