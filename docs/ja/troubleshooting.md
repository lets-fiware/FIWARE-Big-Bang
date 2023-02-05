# トラブルシューティング

## CrateDB を使用した QuantumLeap

QuantumLeap には、履歴コンテキスト・データを保持するためのバックエンド・データベースである CrateDB を持っています。
CrateDB が `max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]`
エラーですぐに終了する場合は、ホスト・マシンで `sudo sysctl -w vm.max_map_count=262144` コマンドを実行することで
修正できます。詳細については、CrateDB の[ドキュメント](https://crate.io/docs/crate/howtos/en/latest/admin/bootstrap-checks.html#bootstrap-checks)
、および、Docker の[トラブルシューティング・ガイド](https://crate.io/docs/crate/howtos/en/latest/deployment/containers/docker.html#troubleshooting)
を参照してください。

```
sudo sysctl -w vm.max_map_count=262144
```

## "ngsi users create" で新しいユーザーを作成できない

NGSI Go から "Invalid email" というエラー・メッセージが表示された場合は、`config/keyrock/whitelist.txt`
にメール・アドレスのドメインが含まれているかどうかを確認してください。

```
ngsi users create --host keyrock --username user001 --email user001@example.com --password 1234
usersCreate003 error 400 Bad Request {"error":{"message":"Invalid email","code":400,"title":"Bad Request"}}
```

ドメインが存在しない場合は、`config/keyrock/whitelist.txt` に追加して、Keyrock インスタンスを再起動します。
FIWARE Big Bang は、メーリング・リスト・タイプとして `whitelist` で、Keyrock インスタンスをセットアップします。
詳細については、[Keyrock のドキュメント](https://fiware-idm.readthedocs.io/en/latest/installation_and_administration_guide/configuration/index.html#email-filtering)
を参照してください 。
