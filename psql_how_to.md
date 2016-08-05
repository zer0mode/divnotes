## PostgreSQL how to

### psql prompt
##### postgres - default postgresql user
`$ sudo -u postgres psql`

Do not use
>$ sudo su - postgres  
>*postgres*$ psql

it's ancient, obsolete and unsafe

<sup>info@[serverfault] (http://serverfault.com/questions/601140/whats-the-difference-between-sudo-su-postgres-and-sudo-u-postgres#601141 "whats-the-difference-between-sudo-su-postgres-and-sudo-u-postgres")</sup>

#### create db and user
`=# CREATE DATABASE hotdb;`  
`=# CREATE USER hotuser WITH PASSWORD 'hotpass';`

#### grant
`=# GRANT ALL PRIVILEGES ON DATABASE hotgisdb TO hotuser;`

*hotuser* will get the privileges of the granting user granting

#### change database owner
>Status owner has broader rights than a role with privileges over a db

`=# ALTER DATABASE hotdb OWNER TO hotuser;`

#### connect to another db
`=# \c[onnect] hotdb;`

#### exit psql
`=# \q`

>if at postgres prompt *(which shouldn't be the case)* :  
> *postgres*$ exit


### Configuration files
You might want to modify *pg_hba.conf* or *pg_ident.conf* located in /etc/postgresql/$VERSION/main.

*pg_hba.conf*

    # Database administrative login by Unix domain socket
    local   all             postgres                                ident
    local   hotdb           user<*>                                 ident map=userisnowhot

    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    
    # "local" is for Unix domain socket connections only
    #local   all             all                                     peer
    #local   all             all                                     ident
    local   all             all                                     md5

*pg_ident.conf*

    # MAPNAME       SYSTEM-USERNAME         PG-USERNAME
    userisnowhot            user<*>            hotuser

<sup>\<*\> _standard system user name_</sup>
<sup>https://www.postgresql.org/docs/current/static/auth-username-maps.html</sup>

Modifying configuration files requiers service restart.

`$ sudo /etc/init.d/postgresql [reload|restart]`

or  
`$ sudo service postgresql [reload|restart]`

#### login as new user
`$ psql -d hotdb -U hotuser`

or shorter  
`$ psql hotdb hotuser`

##### check database installed extensions
    => SELECT name, default_version,installed_version  
      FROM pg_available_extensions  
      WHERE name LIKE 'postgis%' ;

or shorter  
`=> \dx`

#### list of psql meta-commands
<pre>
help :
  \? [commands]          show help on backslash commands

informational :  
  \l[+]   [PATTERN]      list databases
  \d[S+]                 list tables, views, and sequences
  \da[S]  [PATTERN]      list aggregates
  \deu[+] [PATTERN]      list user mappings
  \dg[+]  [PATTERN]      list roles
  \dp     [PATTERN]      list table, view, and sequence access privileges
  \dt[S+] [PATTERN]      list tables
  \du[+]  [PATTERN]      list roles
  \dx[+]  [PATTERN]      list extensions

formatting :
  \x [on|off|auto]       toggle expanded output (currently off)

query buffer :
  \p                     show the contents of the query buffer
  \r                     reset (clear) the query buffer
  \s [FILE]              display history or save it to file
  \w FILE                write query buffer to file

connection :
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
  \password [USERNAME]   securely change the password for a user
  \conninfo              display information about current connection

operating system :
  \cd [DIR]              change the current working directory

general :
  \q                     quit psql
</pre>

<sup>https://www.postgresql.org/docs/9.3/static/app-psql.html#APP-PSQL-META-COMMANDS</sup>

### Establish django postgresql spatial database
(repeting the excercise from above)
https://docs.djangoproject.com/en/dev/ref/contrib/gis/install/postgis/#managing-the-database

`$ sudo -u postgres psql`  

    =# CREATE USER hotdjango PASSWORD 'unchained';

To operate with a postgresql database Django needs permitions for :
SELECT, INSERT, UPDATE, DELETE

https://docs.djangoproject.com/en/dev/topics/install/#get-your-database-running

Check all the permition in the table at the bottom of [this]: https://www.postgresql.org/docs/9.5/static/sql-grant.html#SQL-GRANT-NOTES paragraph.

https://www.postgresql.org/docs/current/static/ddl-priv.html

This suffices for managing GeoDjango projects. Should the user be a database owner, this is done by :

    =# CREATE DATABASE hotdjangodb OWNER TO hotdjango;

or by ALTERing an existing db


Create extensions or less restricted actions over db pool superuser status is required.

    =# ALTER ROLE hotdjango CREATEDB SUPERUSER NOCREATEROLE;
    =# \q

`$ psql hotdjangodb hotdjango`

    => CREATE EXTENSION postgis ;

\+ other extensions if required :  

    => CREATE EXTENSION postgis_topology ;
    => CREATE EXTENSION fuzzystrmatching ;
    => CREATE EXTENSION tiger... ;
    => \q

### Optimizations
--
Django needs the following parameters for its database connections:

    - client_encoding: 'UTF8'
    - default_transaction_isolation: 'read committed' by default, or the value set in the connection options (see below)
    - timezone: 'UTC' when USE_TZ is True, value of TIME_ZONE otherwise

If these parameters already have the correct values, Django won’t set them for every new connection, which improves performance slightly. You can configure them directly in postgresql.conf or more conveniently per database user with ALTER ROLE.

Django will work just fine without this optimization, but each new connection will do some additional queries to set these parameters.
--
https://docs.djangoproject.com/en/1.9/ref/databases/#optimizing-postgresql-s-configuration

Apply these settings to a role :

    =# ALTER ROLE hotdjango SET client_encoding TO 'utf8';
    =# ALTER ROLE hotdjango SET default_transaction_isolation TO 'read committed';
    =# ALTER ROLE hotdjango SET timezone TO 'UTC';

https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-django-application-on-ubuntu-14-04#create-a-database-and-database-user


#### Setting timezones
http://stackoverflow.com/questions/11779293/how-to-set-timezone-for-postgres-psql/#11779417

First try results :
- settings.py engine setup :
    'ENGINE': 'django.contrib.gis.db.backends.postgis',
    
  psycopg2 thows error

    psycopg2.ProgrammingError: permission denied to create extension "postgis" 
    HINT:  Must be superuser to create this extension.

    django.db.utils.ProgrammingError: permission denied to create extension "postgis"  
    HINT:  Must be superuser to create this extension.

- postgis extension has to be created (by postgres) through psql interface  

    AttributeError: 'DatabaseOperations' object has no attribute 'geo_db_type'

- if the database owner has to be postgres even if the privileges have been granted to "django" database owner


