# Expose ports

Some FIWARE GEs and other OSS running in a Docker container can expose a port for their service.
Port Exposing is driven by environment variables as shown:

| Variable name               | Description                                                                                                              | Default value |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------------- |
| ORION\_EXPOSE\_PORT         | Expose port 1026 for Orion. (none, local or all)                                                                         | none          |
| ORION\_LD\_EXPOSE\_PORT     | Expose port 1026 for Orion-LD. (none, local or all)                                                                      | none          |
| MINTAKA\_EXPOSE\_PORT       | Expose port 8080 for Mintaka. (none, local or all)                                                                       | none          |
| TIMESCALE\_EXPOSE\_PORT     | Expose port 5432 for Timescale. (none, local or all)                                                                     | none          |
| CYGNUS\_EXPOSE\_PORT        | Expose port for Cygnus. (none, local or all) 5051 for Mongo, 5050 for MySQL, 5055 for PostgreSQL, 5058 for Elasticsearch | none          |
| COMET\_EXPOSE\_PORT         | Expose port 8666 for Comet. (none, local or all)                                                                         | none          |
| QUANTUMLEAP\_EXPOSE\_PORT   | Expose port 8668 for Quantumleap. (none, local or all)                                                                   | none          |
| DRACO\_EXPOSE\_PORT         | Expose port 5050 for Draco. (none, local, all)                                                                           | none          |
| ELASTICSEARCH\_EXPOSE\_PORT | Expose port 9200 for Elasticsearch. (none, local or all)                                                                 | none          |
| MONGO\_EXPOSE\_PORT         | Expose port 27017 for MongoDB. (none, local or all)                                                                      | none          |
| MYSQL\_EXPOSE\_PORT         | Expose port 3306 for MySQL. (none, local or all)                                                                         | none          |
| POSTGRES\_EXPOSE\_PORT      | Expose port 5432 for Postgres. (none, local or all)                                                                      | none          |

The variable can be set to `none`, `local`, or `all`.

-   `none`: A port is not exposed outside a container network. It's a default value.
-   `local`: A port is bind to `127.0.0.1`.
-   `all`: A port is bind to `0.0.0.0` (meaning all interfaces).

The `all` value is used when a container on a VM accesses another container on another VM at multi-server installation.
And you should close the exposed port using a network equipment such as firewall so that it is not accessible from the internet.
