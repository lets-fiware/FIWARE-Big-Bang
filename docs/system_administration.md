# System administration

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [Files and directories layout](#files-and-directories-layout)
-   [Make command for system administration](#make-command-for-system-administration)
-   [Log files](#log-files)
-   [Server certificates](#server-certificates)

</details>

## Files and directories layout

The following files and directories will be created.

| File or directory              | Description                                                                                                                                                                                                  |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| .                              | A root directory of FI-BB. It's a directory in which you ran lets-fiware.sh command.                                                                                                                         |
| ./docker-compose.yml           | A config file for docker-compose which has the configuration information of FIWARE GEs.                                                                                                                      |
| ./.env                         | A file which has environment variables for docker-compose.yml file.                                                                                                                                          |
| ./Makefile                     | A file for make command.                                                                                                                                                                                     |
| ./config                       | A directory which has configuration files for running Docker containers.                                                                                                                                     |
| ./config/keyrock/whitelist.txt | A whitelist of email domains for Keyrock. See [Keyrock documentation](https://fiware-idm.readthedocs.io/en/latest/installation_and_administration_guide/configuration/index.html#email-filtering) in detail. |
| ./data                         | A directory which has persistent data for running Docker containers.                                                                                                                                         |
| /etc/letsencrypt               | A directory which has server certificate files.                                                                                                                                                              |
| /var/log/fiware                | A directory which has log files.                                                                                                                                                                             |
| /etc/rsyslog.d/10-fiware.conf  | A config file for rsyslog. In the case of CentOS, the filename is 'fiware.conf'.                                                                                                                             |
| /etc/logrotate.d/fiware        | A config file for logroate.                                                                                                                                                                                  |
| /etc/cron.d/fiware-big-bang    | A config file for cron                                                                                                                                                                                       |

## Make command for system administration

You can manage your FIWARE instance with make command. Run the make command in a directory where you ran
the lets-fiware.sh script.

| Command      | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| admin        | Print a username and a password for Admin user               |
| get-token    | Get an OAuth2 access token                                   |
| multi-server | Print variables for multi-server installation                |
| mqtt         | Print variables for MQTT                                     |
| subdomains   | Print list of subdomains                                     |
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

## Log files

The log files for FIWARE instance is created in the `/var/log/fiware` directory.
And also the log files are rotated on a regular basis. Look at the `/etc/logrotate.d/fiware` file.

## Server certificates

When installing, server certificates automatically are created or reused if already exists.
They are renewed by a cron job. Look at the `/etc/cron.d/fiware-big-bang` file. And also you can
renew or revoke server certificates manually with make command.

## How to create environment for NGSI Go on another machine

### Setup NGSI Go

To setup NGSI Go on another machine, see here [https://github.com/lets-fiware/ngsi-go](https://github.com/lets-fiware/ngsi-go).
And copy and run the `setup_ngsi_go.sh` script on the machine. It asks you an admin email and a password.
