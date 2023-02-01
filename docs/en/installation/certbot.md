# Certbot

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Configuration parameters](#configuration-parameters)

</details>

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name        | Description                                           | Default value                                   |
| -------------------- | ----------------------------------------------------- | ----------------------------------------------- |
| CERT\_EMAIL          | An email address for certbot                          | (An email address of an admin user for Keyrock) |
| CERT\_REVOKE         | Revoke and reacquire the certificate. (true or false) | false                                           |
| CERT\_TEST           | Use --test-cert option. (true or false)               | false                                           |
| CERT\_FORCE\_RENEWAL | Use --force-renewal option. (true or false)           | false                                           |
