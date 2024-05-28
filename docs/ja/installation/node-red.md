# Node-RED

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [構成パラメータ](#configuration-parameters)
-   [設定方法](#how-to-setup)
    -   [シングル・インスタンス](#single-instance)
    -   [マルチ・インスタンス](#multi-instance)
-   [関連情報](#related-information)

</details>

<a name="configuration-parameters"></a>

## 構成パラメータ

`config.sh` ファイルを編集して構成を指定できます。

| 変数名                                 | 説明                                                          | 既定値                                    |
| -------------------------------------- | ------------------------------------------------------------- | ----------------------------------------- |
| NODE\_RED                              | Node-RED のサブドメイン名                                     | (なし)                                    |
| NODE\_RED\_INSTANCE\_NUMBER            | Node-RED のインスタンス数。1 から20 の間の数値を指定可能      | 1                                         |
| NODE\_RED\_INSTANCE\_USERNAME          | Node-RED インスタンスのユーザ名                               | node-red                                  |
| NODE\_RED\_INSTANCE\_HTTP\_ROOT        | Node-RED インスタンスの HTTP ルート。'/' で始まるパスを指定   | / (シングル) または /node-red??? (マルチ) |
| NODE\_RED\_INSTANCE\_HTTP\_ADMIN\_ROOT | Node-RED インスタンスの httpAdminRoot。'/' で始まるパスを指定 | / (シングル) または /node-red??? (マルチ) |
| NODE\_RED\_LOGGING\_LEVEL              | Node-RED インスタンスのロギング・レベル                       | info                                      |
| NODE\_RED\_LOGGING\_METRICS            | Node-RED インスタンスのログ・メトリック                       | (なし)                                    |

<a name="how-to-setup"></a>

## 設定方法

<a name="single-instance"></a>

### シングル・インスタンス

Node-RED を設定するには、config.sh の環境変数を構成します。
次のように、Node-RED のサブドメイン名を `NODE_RED=` に設定します:

```bash
NODE_RED=node-red
```

<a name="multi-instance"></a>

### マルチ・インスタンス

マルチ・インスタンスの Node-RED を設定するには、config.sh の環境変数を構成します。
次のように、Node-RED のサブドメイン名を`NODE_RED=` に、インスタンス数を
`NODE_RED_INSTANCE_NUMBER=` に設定します:

```bash
NODE_RED=node-red
NODE_RED_INSTANCE_NUMBER=5
```

インストール後、`lets-fiware.sh` スクリプトを実行したディレクトリに `node-red_users.txt` ファイルが作成されています。
各 Node-Red インスタンスにアクセスするための URL、ユーザ名、およびパスワードが記載されています。

```text
https://node-red.example.com/node-red001        node-red001@example.com oS7O0tqhLPPFSflF
https://node-red.example.com/node-red002        node-red002@example.com hs7Nrt8PZLTsJlnS
https://node-red.example.com/node-red003        node-red003@example.com W1XEgeJjsXr0q5UI
https://node-red.example.com/node-red004        node-red004@example.com jdZV5SGXEZbtGjTP
https://node-red.example.com/node-red005        node-red005@example.com XgnFHj63gqxfqyE1
```

#### マルチ・インスタンス の HTTP ルート値

| NODE\_RED\_INSTANCE\_HTTP\_ROOT | HTTP ルート       | 例                        |
| ------------------------------- | ----------------- | ------------------------- |
| (なし)                          | /node-red???/     | /node-red???/worldmap     |
| /abc                            | /node-red???/abc/ | /node-red???/abc/worldmap |

<a name="related-information"></a>

## 関連情報

-   [FIWARE/node-red-contrib-FIWARE_official - GitHub](https://github.com/FIWARE/node-red-contrib-FIWARE_official)
-   [Node-RED - GitHub](https://github.com/node-red/node-red)
-   [Node-RED portal site](https://nodered.org/)
-   [nodered/node-red - Docker Hub](https://hub.docker.com/r/nodered/node-red)
