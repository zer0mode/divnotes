## PostgreSQL how to

### psql prompt
##### postgres - default postgresql user
`$ sudo -u postgres psql`

Do not use
>$ sudo su - postgres  
>*postgres*$ psql

it's ancient, obsolete and unsafe

<sup>info@[serverfault][serverfault]</sup>

#### create db and user
`=# CREATE DATABASE hotdb;`  
`=# CREATE USER hotuser WITH PASSWORD 'hotpass';`

#### grant
`=# GRANT ALL PRIVILEGES ON DATABASE hotgisdb TO hotuser;`

_**hotuser**_ will get all available privileges on database **`hotgisdb`**.

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

_**pg_hba.conf**_

    # Database administrative login by Unix domain socket
    local   all             postgres                                ident
    local   hotdb           hotuser                                 ident map=userisnowhot

    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    
    # "local" is for Unix domain socket connections only
    #local   all             all                                     peer
    #local   all             all                                     ident
    local   all             all                                     md5

_**pg_ident.conf**_

    # MAPNAME       SYSTEM-USERNAME         PG-USERNAME
    userisnowhot            user<*>            hotuser

<sup>\<*\> _standard system user name_</sup>
<sup>https://www.postgresql.org/docs/current/static/auth-username-maps.html</sup>

Some applications connect using the 127.0.0.1 address. In this case postgresql will refuse user connections via *local host*. A typical reported error would be *FATAL: no pg_hba.conf entry for host "127.0.0.1" *. The connection information should then be set like this :

    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    # IPv4 local connections:
    host    hotdb           hotuser         localhost               md5
    # or in IPv4 connection form
    host    hotdb           hotuser         127.0.0.1/32            md5
<sup>See more [examples][postgresql] for pg_hba.conf for further details.</sup>

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

[serverfault]: http://serverfault.com/questions/601140/whats-the-difference-between-sudo-su-postgres-and-sudo-u-postgres#601141 "whats-the-difference-between-sudo-su-postgres-and-sudo-u-postgres"
[postgresql]: https://www.postgresql.org/docs/9.4/static/auth-pg-hba-conf.html#EXAMPLE-PG-HBA.CONF "EXAMPLE-PG-HBA.CONF"