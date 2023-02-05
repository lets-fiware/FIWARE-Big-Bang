# Apache Zeppelin (実験的サポート)

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [Zeppelin の健全性チェック](#sanity-check-for-zeppelin)
-   [履歴データを Zeppelin ノートに表示](#print-historical-data-on-zeppelin-notebook)
-   [関連情報](#related-information)

</details>

<a name="sanity-check-for-zeppelin"></a>

## Zeppelin の健全性チェック

Zeppelin が起動したら、Zeppelin Web アプリケーションにアクセスできます。
Web ブラウザで、`https://zeppelin.example.com` を開いて Zeppelin GUI にアクセスします。
Keyrock のログイン ページにリダイレクトされます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-01.jpg)

ログインすると、Zeppelin GUI にリダイレクトされます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-02.jpg)


### Zeppelin のバージョンを取得

Zeppelin のバージョンは、次のコマンドで取得できます:

#### リクエスト:

```bash
curl -s https://zeppelin.example.com/api/version
```

#### レスポンス:

```json
{
  "status": "OK",
  "message": "Zeppelin version",
  "body": {
    "git-commit-id": "",
    "git-timestamp": "",
    "version": "0.9.0"
  }
}
```

<a name="print-historical-data-on-zeppelin-notebook"></a>

## 履歴データを Zeppelin ノートに表示

### インスタンスのセットアップ

まず、以下のように Orion, Cygnus, Zeppelin をセットアップします:

```
ORION=orion
CYGNUS=cygnus
CYGNUS_MONGO=true
ZEPPELIN=zeppelin
```

### コンテキストの変更をサブスクライブ

Cygnus にコンテキストの変更を通知するサブスクリプションを作成し、それを MongoDB に保存します:

```bash
ngsi create \
  --host orion.example.com \
  --service openiot \
  --path / \
  subscription \
  --description "Notify Cygnus of all context changes and store it into MongoDB" \
  --idPattern ".*" \
  --uri "http://cygnus:5051/notify"
```

### コンテキスト・データを作成

次のスクリプトを実行して、コンテキスト・データを生成します:

```bash
#!/bin/bash
set -eu
for i in {0..9}
do
  echo $i
  ngsi upsert \
    --host orion.example.com \
    --service openiot \
    --path / \
    entity \
    --keyValues \
    --data "{\"id\":\"device001\", \"type\":\"device\", \"temperature\":${RANDOM}}"
  sleep 1
done
```

### ノートブック上で MongoDB から履歴データを読み取り

ノートブック・メニューから `FIWARE Big Bang Example` ノートブックを開きます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-03.jpg)

次のスクリプトで MongoDB から履歴データを読み取ることができます。

```
%mongodb
db["sth_/_device001_device"].find({},{attrValue:1,recvTime:1}).table()
```

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-04.jpg)

ノートブックで段落 (paragraph) を実行します。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-05.jpg)

ノートブックに履歴データが表示されます。

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-06.jpg)

#### 棒グラフ

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-07.jpg)

#### 円グラフ

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-08.jpg)

#### 面グラフ

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-09.jpg)

#### 折れ線グラフ

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-10.jpg)

#### 散布図

![](https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/gh-pages/images/zeppelin/zeppelin-11.jpg)

<a name="related-information"></a>

## 関連情報

-   [Apache Zeppelin](https://zeppelin.apache.org/)
-   [Zeppelin - GitHub](https://github.com/apache/zeppelin)
