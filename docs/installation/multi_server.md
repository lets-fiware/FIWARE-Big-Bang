# Multi-server installation

-   [Configuration parameters](#configuration-parameters)
-   [How to setup](#how-to-setup)

## What is multi-server installation

The multi-server installation is how to configure a FIWARE instance with multiple VMs.
You can configure a FIWARE instance with a VM installed Keyrock and VMs installed other
FIWARE GEs. The VM installed Keyrock is called a main VM. The VM installed other FIWARE
GEs is called an additional VM.

## Configuration parameters

You can specify configurations by editing the `config.sh` file.

| Variable name                       | Description                                                                                 | Default value |
| ----------------------------------- | ------------------------------------------------------------------------------------------- | ------------- |
| MULTI\_SERVER\_KEYROCK              | Keyrock URL. E.g. https://keyrock.exmaple.com                                               | (empty)       |
| MULTI\_SERVER\_ADMIN\_EMAIL         | An email address of an admin user for Keyrock. E.g. admin@example.com                       | (empty)       |
| MULTI\_SERVER\_ADMIN\_PASS          | A password of an admin user for Keyrock.                                                    | (empty)       |
| MULTI\_SERVER\_PEP\_PROXY\_USERNAME | A username for Wilma PEP Proxy.                                                             | (empty)       |
| MULTI\_SERVER\_PEP\_PASSWORD        | A password for Wilma PEP Proxy.                                                             | (empty)       |
| MULTI\_SERVER\_CLIENT\_ID           | A client id.                                                                                | (empty)       |
| MULTI\_SERVER\_CLIENT\_SECRET       | A client secret.                                                                            | (empty)       |
| MULTI\_SERVER\_ORION\_HOST          | Orion host when installing WireCloud. (Required) E.g. orion.exmaple.com                     | (empty)       |
| MULTI\_SERVER\_QUANTUMLEAP\_HOST    | Quantumleap host when installing WireCloud. (Optional) E.g. quantumleap.exmaple.com         | (empty)       |
| MULTI\_SERVER\_ORION\_INTERNAL\_IP  | Orion internal IP address when installing Perseo. (Required) E.g. 192.168.0.1               | (empty)       |

## How to setup

To get the basic variables for Multi-server installation, run the following command at a VM
where Keyrock is installed. You can paste them in `config.sh` on another VM.

#### Request:

```bash
make multi-server
```

#### Response:

```bash
MULTI_SERVER_KEYROCK=https://keyrock.example.com
MULTI_SERVER_ADMIN_EMAIL=admin@example.com
MULTI_SERVER_ADMIN_PASS=JSyJiEVon6MIliBL

MULTI_SERVER_PEP_PROXY_USERNAME=pep_proxy_a3aff992-c3a2-4b39-8728-22eed803ccda
MULTI_SERVER_PEP_PASSWORD=pep_proxy_a00226e8-5c6e-47de-9137-40a9a932bda0

MULTI_SERVER_CLIENT_ID=1db4e864-851e-4b39-a952-ac70ca8f6bfc
MULTI_SERVER_CLIENT_SECRET=8cb45711-b992-4ef4-9eb4-cb6391d48b9a
```

## Exmaple 1

Keyrock and Orion are installed sepertally VMs.

| VMs           | FIWARE GEs |
| ------------- | ---------- |
| Main VM       | Keyrock    |
| Additonal VM  | Orion      |

### Configuration for a main VM

```bash
KEYROCK=keyrock
ORION=
```

### Configuration for an additional VM

```bash
KEYROCK=
ORION=orion

MULTI_SERVER_KEYROCK=https://keyrock.example.com
MULTI_SERVER_ADMIN_EMAIL=admin@example.com
MULTI_SERVER_ADMIN_PASS=JSyJiEVon6MIliBL

MULTI_SERVER_PEP_PROXY_USERNAME=pep_proxy_a3aff992-c3a2-4b39-8728-22eed803ccda
MULTI_SERVER_PEP_PASSWORD=pep_proxy_a00226e8-5c6e-47de-9137-40a9a932bda0

MULTI_SERVER_CLIENT_ID=1db4e864-851e-4b39-a952-ac70ca8f6bfc
MULTI_SERVER_CLIENT_SECRET=8cb45711-b992-4ef4-9eb4-cb6391d48b9a
```

## Exmaple 2

Keyrock and Orion are installed in a main VM.
WireCloud is installed in an additional VM.

| VMs           | FIWARE GEs     |
| ------------- | -------------- |
| Main VM       | Keyrock, Orion |
| Additonal VM  | WireCloud      |

### Configuration for a main VM

```bash
KEYROCK=keyrock
ORION=orion
```

### Configuration for an additional VM

```bash
KEYROCK=
ORION=
WIRECLOUD=wirecloud
NGSIPROXY=ngsiproxy

MULTI_SERVER_KEYROCK=https://keyrock.example.com
MULTI_SERVER_ADMIN_EMAIL=admin@example.com
MULTI_SERVER_ADMIN_PASS=JSyJiEVon6MIliBL

MULTI_SERVER_PEP_PROXY_USERNAME=pep_proxy_a3aff992-c3a2-4b39-8728-22eed803ccda
MULTI_SERVER_PEP_PASSWORD=pep_proxy_a00226e8-5c6e-47de-9137-40a9a932bda0

MULTI_SERVER_CLIENT_ID=1db4e864-851e-4b39-a952-ac70ca8f6bfc
MULTI_SERVER_CLIENT_SECRET=8cb45711-b992-4ef4-9eb4-cb6391d48b9a

MULTI_SERVER_ORION_HOST=orion.exmaple.com
```
