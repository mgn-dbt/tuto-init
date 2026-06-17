# The Jaffle Shop 🥪

Seeds to initialize the source tables for the Jaffle Shop tutorials

There are 2 batches of tables used in DBT tutorials.  
3 tables tuto : raw_customers, raw_orders and raw_payments  
6 tables tuto : customers, items, orders, products, stores and supplies

This project is for loading Jaffle data quickly into BigQuery, PostgreSQL or DuckDB.

Cf [Environment](./docs/Environment.md)

Cf [Databases](./docs/Databases.md)

Cf [VScode](./docs/VScode.md)

## DBT

Beware :  
Upgrade the dbt vscode extension first.  
Don't upgrade dbt fusion first.  
Let VScode propose the right dbt fusion version.

You can choose the version of the dbt vscode extension.  
Under the dbt vscode extension page : `Uninstall / Install Specific Version`

Compatibility between the dbt fusion and the dbt vscode extension is important.  
Don't install a dbt fusion version ahead of the dbt vscode extension.

![dbt vscode extension](./docs/dbt_vscode_extension.png)

```powershell
iwr -uri https://public.cdn.getdbt.com/fs/install/install.ps1 -OutFile install.ps1
& install.ps1 -Version "2.0.0-preview.177"
Remove-Item install.ps1
```

or if fusion is already installed

```powershell
& install.ps1 -Update -Version "2.0.0-preview.177"
```

Check your PATH environment variable after using install.ps1.

NB : Fusion installation process updates the powershell profile files :  
Cf $env:USERPROFILE\Documents\Powershell\Microsoft.PowerShell_profile.ps1  
or $env:USERPROFILE\Documents\WindowsPowershell\Microsoft.PowerShell_profile.ps1  
It ensure dbtf alias is created.

Beware package-lock.yml yaml file, dbt fusion upgrade it with a bad format for dbt cloud.  
After executing "dbt deps" under source control "Discard changes" for package-lock.json.  
Keep dbt cloud version of package-lock.json for compatibility.  
Bug or new format ???

### Profiles.yml

Set environment variables.  
Cf [Environment variables](./docs/Environment.md#environment-variables)  
Cf [env_var](https://docs.getdbt.com/reference/dbt-jinja-functions/env_var)

Content of `$env:USERPROFILE\.dbt\profiles.yml`

```yaml
default:
  target: dev
  outputs:
    dev:
      type: bigquery
      threads: 4
      project: "{{ env_var('DBT_BIGQUERY_PROJECT') }}"
      dataset: dbt_tuto
      method: service-account
      keyfile: "{{ env_var('DBT_BIGQUERY_KEYFILE') }}"
      location: US
    prod:
      type: bigquery
      threads: 4
      project: "{{ env_var('DBT_BIGQUERY_PROJECT') }}"
      dataset: dbt_prod
      method: service-account
      keyfile: "{{ env_var('DBT_BIGQUERY_KEYFILE') }}"
      location: US
pg:
  target: dev
  outputs:
    dev:
      dbname: jaffle_shop
      host: localhost
      password: jaffle
      port: 5432
      schema: dbt_tuto
      search_path: dbt_tuto,public
      threads: 1
      type: postgres
      user: jaffle
      sslmode: verify-ca
      sslrootcert: "{{ env_var('DBT_PG_ROOT_CERT') }}"
    prod:
      dbname: jaffle_shop
      host: localhost
      password: jaffle
      port: 5432
      schema: dbt_prod
      search_path: dbt_prod,public
      threads: 2
      type: postgres
      user: jaffle
      sslmode: verify-ca
      sslrootcert: "{{ env_var('DBT_PG_ROOT_CERT') }}"
duckdb:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: "{{ env_var('DBT_DUCKDB_DATABASE') }}"
      schema: dbt_tuto
      threads: 4
      # threads: 1  (for log_query_path to work)
      #settings:
      #  log_query_path: '.\offline\duck_tuto_query.log'   You can use a relative path (relative to your profiles.yml file)
    prod:
      type: duckdb
      path: "{{ env_var('DBT_DUCKDB_DATABASE') }}"
      schema: dbt_prod
      threads: 4 
      # threads: 1  (for log_query_path to work)
      #settings:
      #  log_query_path: '.\offline\duck_tuto_query.log'   You can use a relative path (relative to your profiles.yml file)
```

Dbt Cloud BigQuery connection

![Dbt Cloud BigQuery connection](./docs/dbt_dev_connection.png)

BigQuery profile must be named "default" for Dbt Cloud.  
Cf Dbt Cloud BigQuery connection above.

Duckdb log_query_path is optional. Use it only to debug queries.  
Beware threads must be set to 1 if log_query_path is used.

NB : duckdb database path must be absolute to share the database between dbt projects

## Exec

```Powershell
# for BigQuery with dbt fusion
dbt build --profile default
# for Duckdb with dbt fusion
dbt build --profile duckdb
```

```Powershell
# enter sqlfluff venv
& (join-path $env:USERPROFILE SCOOP persist python venvs sqlfluff Scripts activate.ps1)

# for PostgreSql with dbt-core
dbt build --profile pg
# for BigQuery with dbt-core
dbt build --profile default
# for Duckdb with dbt-core
dbt build --profile duckdb

deactivate
```
