# Backup and restore databases

A set of scripts to backup and restore MySQL and PostgreSQL databases.

## Usage

These scripts are intended to run as a kubernetes job. Example jobs can be found in the [install/kubernetes directory](https://github.com/sjdaws/backup-restore-db/tree/main/install/kubernetes).

### Environment variables

The jobs use environment variables to connect to the database.

#### MySQL backup

| Name | Description | Default |
|------|-------------|---------|
| `ARGS` | Additional args to pass to `mysqldump` | |
| `DB_NAMES` | A comma separated list of databases to backup, if not specified all databases will be backed up* | |
| `EXCLUDE_DBS` | A comma separated list of databases to exclude from backup, ignored if `DB_NAMES` is set | |
| `HISTORY` | The number of backups to keep, older backups will be removed after a successful backup | |
| `HOST` | Hostname or IP for the MySQL host | localhost |
| `PASSWORD` | Password used to connect to the host | |
| `PORT` | Port the host is listening on | 3306 |
| `USERNAME` | Username used to connect to the host | |

<sup>* Backing up all databases will automatically exclude `information_schema`, `mysql`, `performance_schema`, and any database starting with an underscore.</sup>

#### MySQL restore

| Name | Description | Default |
|------|-------------|---------|
| `ARGS` | Additional args to pass to `mysql` | |
| `BACKUP_FILE` | Filename relative to the mounted `/backup` directory to restore | |
| `DB_NAME` | The name of the database to restore | |
| `DROP_FIRST` | Whether to drop the database before restoring | false |
| `HOST` | Hostname or IP for the MySQL host | localhost |
| `PASSWORD` | Password used to connect to the host | |
| `PORT` | Port the host is listening on | 3306 |
| `USERNAME` | Username used to connect to the host | |

#### PostgreSQL backup

| Name | Description | Default |
|------|-------------|---------|
| `ARGS` | Additional args to pass to `pg_dump` | |
| `DB_NAMES` | A comma separated list of databases to backup, if not specified all databases will be backed up* | |
| `EXCLUDE_DBS` | A comma separated list of databases to exclude from backup, ignored if `DB_NAMES` is set | |
| `HISTORY` | The number of backups to keep, older backups will be removed after a successful backup | |
| `HOST` | Hostname or IP for the PostgreSQL host | localhost |
| `PASSWORD` | Password used to connect to the host | |
| `PORT` | Port the host is listening on | 5432 |
| `USERNAME` | Username used to connect to the host | |
| `VERSION` | The major PostgreSQL version the host is running | 15 |

<sup>* Backing up all databases will automatically exclude `postgres`, `template0`, `template1`, and any database starting with an underscore.</sup>

#### PostgreSQL restore

| Name | Description | Default |
|------|-------------|---------|
| `ARGS` | Additional args to pass to `psql` | |
| `BACKUP_FILE` | Filename relative to the mounted `/backup` directory to restore | |
| `DB_NAME` | The name of the database to restore | |
| `DROP_FIRST` | Whether to drop the database before restoring | false |
| `HOST` | Hostname or IP for the PostgreSQL host | localhost |
| `PASSWORD` | Password used to connect to the host | |
| `PORT` | Port the host is listening on | 5432 |
| `USERNAME` | Username used to connect to the host | |
| `VERSION` | The major PostgreSQL version the host is running | 15 |