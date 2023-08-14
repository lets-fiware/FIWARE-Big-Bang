# システム管理

## コンテンツ

<details>
<summary><strong>詳細</strong></summary>

-   [ファイルとディレクトリのレイアウト](#files-and-directories-layout)
-   [システム管理用 make コマンド](#make-command-for-system-administration)
-   [ログ・ファイル](#log-files)
-   [サーバ証明書](#server-certificates)
-   [別のマシンに NGSI Go の環境を作成する方法](#how-to-create-environment-for-ngsi-go-on-another-machine)
    -   [NGSI Go のセットアップ](#setup-ngsi-go)

</details>

<a name="files-and-directories-layout"></a>

## ファイルとディレクトリのレイアウト

以下のファイルとディレクトリが作成されます。

| ファイル、または、ディレクトリ   | 説明                                                                                                                                                                                                                                      |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| .                                | FIWARE Big Bang のルートディレクトリ。これは、lets-fiware.sh コマンドを実行したディレクトリです。                                                                                                                                         |
| ./docker-compose.yml             | FIWARE GE の構成情報を持つ docker compose 用の構成ファイル。                                                                                                                                                                              |
| ./.env                           | docker-compose.yml ファイルの環境変数を含むファイル。                                                                                                                                                                                     |
| ./Makefile                       | make コマンド用のファイル。                                                                                                                                                                                                               |
| ./config                         | Docker コンテナを実行するための構成ファイルを含むディレクトリ。                                                                                                                                                                           |
| ./config/keyrock/whitelist.txt   | Keyrock の電子メール・ドメインのホワイトリスト。詳細については、[Keyrock のドキュメント](https://fiware-idm.readthedocs.io/en/latest/installation_and_administration_guide/configuration/index.html#email-filtering) を参照してください。 |
| ./data                           | Docker コンテナを実行するための永続データを含むディレクトリ。                                                                                                                                                                             |
| /etc/letsencrypt                 | サーバ証明書ファイルがあるディレクトリ。                                                                                                                                                                                                  |
| /var/log/fiware                  | ログファイルがあるディレクトリ。                                                                                                                                                                                                          |
| /etc/rsyslog.d/10-fiware.conf    | rsyslog の構成ファイル。CentOS Stream, Rocky Linux または AlmaLinux の場合、ファイル名は 'fiware.conf' です。                                                                                                                             |
| /etc/logrotate.d/fiware          | logroate の構成ファイル。                                                                                                                                                                                                                 |
| /etc/cron.daily/fi-bb-cert-renew | cron の設定ファイル                                                                                                                                                                                                                       |

<a name="make-command-for-system-administration"></a>

## システム管理用 make コマンド

You can manage your FIWARE instance with make command. Run the make command in a directory where you ran
the lets-fiware.sh script.

| Command      | Description                                                     |
| ------------ | --------------------------------------------------------------- |
| admin        | 管理者ユーザのユーザ名とパスワードを表示                        |
| get-token    | OAuth2 アクセス トークンを取得                                  |
| multi-server | マルチサーバ・インストール用の変数を表示                        |
| mqtt         | MQTT 関連の変数を表示                                           |
| subdomains   | サブドメインのリストを表示                                      |
| collect      | システム情報の収集                                              |
| log          | FIWARE Big Bang のログを出力 (/var/log/fiware/fi-bb.log)        |
| log-dir      | ログ・ディレクトリ (/var/log/fiware) 内のファイルを一覧表示     |
| logrotation  | ログ・ファイルをローテーション                                  |
| ps           | FIWARE インスタンスの Docker コンテナを一覧表示                 |
| build        | FIWARE インスタンス用の Docker コンテナをビルド                 |
| up           | FIWARE インスタンスの Docker コンテナを作成して起動             |
| down         | FIWARE インスタンスの Docker コンテナを停止して削除             |
| clean        | !注意! すべてのデータを含む FIWARE インスタンスをクリーンアップ |
| nginx-test   | nginx の設定をリテスト                                          |
| nginx-reload | nginx の設定をリロード                                          |
| cert-renew   | すべてのサーバ証明書を更新                                      |
| cert-revoke  | !注意! FIWARE インスタンスのすべてのサーバ証明書を取り消す      |
| cert-list    | FIWARE インスタンスのサーバ証明書ファイルを一覧表示             |

<a name="log-files"></a>

## ログ・ファイル

`/var/log/fiware` ディレクトリに FIWARE インスタンスのログ・ファイルが作成されます。また、
ログ・ファイルは定期的にローテーションされます。`/etc/logrotate.d/fiware` ファイルを確認ください。

<a name="server-certificates"></a>

## サーバ証明書

インストール時に、サーバ証明書が自動的に作成されるか、既に存在する場合は再利用されます。それらは
cron ジョブによって更新されます。`/etc/cron.d/fiware-big-bang` ファイルを確認してください。また、
make コマンドを使用して、サーバ証明書を手動で更新または取り消すこともできます。

<a name="how-to-create-environment-for-ngsi-go-on-another-machine"></a>

## 別のマシンに NGSI Go の環境を作成する方法

<a name="setup-ngsi-go"></a>

### NGSI Go のセットアップ

別のマシンで NGSI Go をセットアップするには、[https://github.com/lets-fiware/ngsi-go](https://github.com/lets-fiware/ngsi-go)
を参照してください。そして、マシン上で `setup_ngsi_go.sh` スクリプトをコピーして実行します。
管理者の電子メールとパスワードの入力が必要となります。
