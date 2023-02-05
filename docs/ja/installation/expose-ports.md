# Expose ports

Docker コンテナで実行されている一部の FIWARE GEs およびその他の OSS は、サービスのポートを
公開できます。ポートの公開は、次のように環境変数によって設定できます:

| 変数名                      | 説明                                                                                                                      | 既定値 |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ------ |
| ORION\_EXPOSE\_PORT         | Orion の ポート 1026 を公開。(none, local または all)                                                                     | none   |
| ORION\_LD\_EXPOSE\_PORT     | Orion-LD のポート 1026 を公開。(none, local または all)                                                                   | none   |
| MINTAKA\_EXPOSE\_PORT       | Mintaka のポート 8080 を公開。(none, local または all)                                                                    | none   |
| TIMESCALE\_EXPOSE\_PORT     | Timescale の ポート 5432 を公開。(none, local または all)                                                                 | none   |
| CYGNUS\_EXPOSE\_PORT        | Cygnus のポートを公開。(none, local または all) MongoDB は 5051。MySQL は 5050。PostgreSQL は 5055。Elasticsearch は 5058 | none   |
| COMET\_EXPOSE\_PORT         | Comet のポート 8666 を公開。(none, local または all)                                                                      | none   |
| QUANTUMLEAP\_EXPOSE\_PORT   | Quantumleap 8668 のポートを公開。(none, local または all)                                                                 | none   |
| DRACO\_EXPOSE\_PORT         | Draco のポート 5050 を公開。(none, local または all)                                                                      | none   |
| ELASTICSEARCH\_EXPOSE\_PORT | Elasticsearch のポート 9200 を公開。(none, local または all)                                                              | none   |
| MONGO\_EXPOSE\_PORT         | MongoDB のポート 27017 を公開。(none, local または all)                                                                   | none   |
| MYSQL\_EXPOSE\_PORT         | MySQL のポート 3306 を公開。(none, local または all)                                                                      | none   |
| POSTGRES\_EXPOSE\_PORT      | PostgreSQL のポート 5432 を公開。(none, local または all)                                                                 | none   |

変数には、 `none`, `local` または `all` を設定できます。

-   `none`: ポートはコンテナ・ネットワークの外部に公開されません。これはデフォルト値です
-   `local`: ポートは `127.0.0.1` にバインドされます
-   `all`: ポートは `0.0.0.0` にバインドされます (すべてのインターフェースを意味します).

この `all` 値は、マルチサーバ・インストールで VM 上のコンテナが別の VM 上の別のコンテナにアクセスするときに使用します。
また、ファイアウォールなどのネットワーク機器を使用して露出したポートを閉じ、インターネットからアクセスできないように
する必要があります。
