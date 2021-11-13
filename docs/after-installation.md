# After installation

## Installation completion message

After installation, you will get a completion message as shown:

```text
*** Setup has been completed ***
IDM: https://keyrock.example.com
User: admin@example.com
Password: 6efQS9g8Hhffj4zo
docs: https://fi-bb.letsfiware.jp/
Please see the .env file for details.
```

It has a URL, a username and a password for Keyrock.

## Sanify check

You can check if the FIWARE instance is healthy by running some commands.

### Get the status of docker containers.

```bash
make ps
```

```text
sudo /usr/local/bin/docker-compose ps
            Name                          Command                   State                                        Ports
-------------------------------------------------------------------------------------------------------------------------------------------------------
fiware-big-bang_keyrock_1      docker-entrypoint.sh npm start   Up (healthy)     3000/tcp
fiware-big-bang_mongo_1        docker-entrypoint.sh --noj ...   Up               27017/tcp
fiware-big-bang_mysql_1        docker-entrypoint.sh mysqld      Up               3306/tcp, 33060/tcp
fiware-big-bang_nginx_1        /docker-entrypoint.sh ngin ...   Up               0.0.0.0:443->443/tcp,:::443->443/tcp, 0.0.0.0:80->80/tcp,:::80->80/tcp
fiware-big-bang_orion_1        sh -c rm /tmp/contextBroke ...   Up               1026/tcp
fiware-big-bang_tokenproxy_1   docker-entrypoint.sh             Up               1029/tcp
fiware-big-bang_wilma_1        docker-entrypoint.sh npm start   Up (unhealthy)   1027/tcp
```

### Get an access token

Run the following command in a directory you ran the lets-fiware.sh script.

#### Request:

```bash
make get-token
```

#### Response:

```text
./config/script/get_token.sh
d56dc45e4285fe25b42fd205da9a2733ca58c697
```

### Get Orion version

You can get the Orion version with NGSI Go.

```bash
ngsi version --host orion.example.com
```

```json
{
"orion" : {
  "version" : "3.3.1",
  "uptime" : "0 d, 0 h, 0 m, 1 s",
  "git_hash" : "a9ff9652c7b93240f48d2b497783407a80861370",
  "compile_time" : "Thu Nov 11 10:08:31 UTC 2021",
  "compiled_by" : "root",
  "compiled_in" : "831b4bc01053",
  "release_date" : "Thu Nov 11 10:08:31 UTC 2021",
  "machine" : "x86_64",
  "doc" : "https://fiware-orion.rtfd.io/en/3.3.1/",
  "libversions": {
     "boost": "1_66",
     "libcurl": "libcurl/7.61.1 OpenSSL/1.1.1g zlib/1.2.11 nghttp2/1.33.0",
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

### Keyrock GUI

To access the Keyrock GUI,  Open at https://keyrock.example.com with Web browser.

## Files and directories layout

The following files and directories will be created.

| File or directory             | Description                                                                             |
| ----------------------------- | --------------------------------------------------------------------------------------- |
| .                             | A root directory of FI-BB. It's a directory in which you ran lets-fiware.sh command.    |
| ./docker-compose.yml          | A config file for docker-compose which has the configuration information of FIWARE GEs. |
| ./.env                        | A file which has environment variables for docker-compose.yml file.                     |
| ./Mailefile                   | A file for make command.                                                                |
| ./config                      | A directory which has configuration files for running Docker containers.                |
| ./data                        | A directory which has persistent data for running Docker containers.                    |
| /etc/letsencrypt              | A directory which has server certificate files.                                         |
| /var/log/fiware               | A directory which has log files.                                                        |
| /etc/rsyslog.d/10-fiware.conf | A config file for rsyslog. In the case of CentOS, the filename is 'fiware.conf'.        |
| /etc/logrotate.d/fiware       | A config file for logroate.                                                             |
| /etc/cron.d/fiware-big-bang   | A config file for cron                                                                  |

## System management

### Make command for system management

You can manage your FIWARE instance with make command.  Run the make command in a directory you ran
the lets-fiware.sh script.

| Command      | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| admin        | Print a username and a password for Admin user               |
| get-token    | Get an OAuth2 access token                                   |
| collect      | Collect system information                                   |
| log          | Print log for FIWARE Big Bang (/var/log/fiware/fi-bb.log)    |
| log-dir      | List files in the log directory (/var/log/fiware)            |
| logrotation  | Rotate log files                                             |
| ps           | List docker containers for FIWARE instance                   |
| build        | Build docker containers for FIWARE instance                  |
| up           | Create and start docker containers for FIWARE instance       |
| down         | Stop and remove docker containers for FIWARE instance        |
| clean        | !CAUTION! Clean up FIWARE instance                           |
| nginx-test   | Test configuration for nginx                                 |
| nginx-reload | Reload configuration for nginx                               |
| cert-renew   | Renew all server certificates                                |
| cert-revoke  | !CAUTION! Revoke all server certificates for FIWARE instance |
| cert-list    | List server certificate files for FIWARE instance            |

### Log files

The log files for FIWARE instance is created in the `/var/log/fiware` directory.
And also the log files are rotated on a regular basis. Look at the `/etc/logrotate.d/fiware` file.

### Server certificates

When installing, server certificates automatically are created or reused if already exists.
They are renewed by a cron job. Look at the `/etc/cron.d/fiware-big-bang` file. And also you can
renew or revoke server certificates manually with make command.
