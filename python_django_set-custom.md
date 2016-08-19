# python-django installation, parameters, customisations

### idle / idle3
recall commands :
- last / previous	= ALT+p
- next		= ALT+n

<sup>check @ [stackoverflow][stack 1]</sup>

#### idle themes
To add custom themes edit ~/.idlerc/config-highlight.cfg  
Insert theme names and color configuration. A few dark versions here below :

	[Obsidian]
	# https://gist.github.com/dsosby/1122904	
	[desert]
	# http://ubuntuforums.org/showthread.php?t=657799
	[Matrix]
	# http://snipplr.com/view/53202/matrix-theme-for-idle/
	[Custom Dark]
	[Custom Light]
	# http://stackoverflow.com/questions/33064424/idle-background-color-in-python

Edit ~/.idlerc/config-main.cfg

	[Theme]
	default = 0
	name = //your default theme name//


## django installation

Installation of django dependencies involves building and installing packages from source. A brief *how-to* guide is provided below as version upgrading or removing a package will follow sooner or later.

#### uninstall guides
Not all the libraries provide the 'make uninstall' rule. As such, using checkinstall is recommended : https://help.ubuntu.com/community/CheckInstall

More about uninstalling a package without uninstall rule : http://askubuntu.com/questions/435621/manually-uninstall-gdal

Locating libraries in a custom location is also an alternative : https://www.quora.com/How-can-I-track-and-remove-packages-compiled-and-installed-by-%E2%80%98make-install%E2%80%99

List of packages with and without uninstall rule :

| | | | | | | | | |
--- | --- | --- | --- | --- | --- | --- | --- | ---
uninstall rule available | SQLite | GEOS | PROJ.4 | JSON-C | libxml2 | FreeXL | SpatiaLite | PostGIS
manual uninstallation required | GDAL |

### installation guides
<sup>instructions on [djangoproject][1]</sup>  
<sup>https://docs.djangoproject.com/en/dev/topics/install/#install-the-django-code</sup>  
<sup>https://docs.djangoproject.com/en/dev/intro/contributing/</sup>

#### check version
if django is already installed

`$ python -c "import django; print(django.get_version())"`

or enter into python prompt

`$ python3`

```python
	>>> import django
	>>> print(django.get_version())
	>>> (Ctrl+D)
```

#### uninstall previous version
If previously installed with pip, version upgrading and uninstalling is managed with pip

Otherwise find django folder and remove it manually

`$ python3 -c "import django; print(django.__path__)"`

#### installation : virtualenv pip
`$ mkdir ~/.virtualenvs`  
`$ sudo apt-get install python3-venv`
>in case of "E: Unable to locate package python3-venv"  
>verify the [package version](http://packages.ubuntu.com/python3-venv) and try the corresponding

>`$ sudo apt-get install python3.$VERSION-venv`

`$ python3 -m venv ~/.virtualenvs/djangodev`

If the above fails follow the steps below :

>#### install pip3
>`$ sudo apt-get install python3-pip`  
>`$ sudo pip3 install virtualenv`  
>`$ virtualenv --python='which python3' ~/.virtualenvs/djangodev`

#### activate virtualenv when launching a new terminal
`$ source ~/.virtualenvs/djangodev/bin/activate`

To simplify it add this line in file *`.bashrc`* ot *`.bash_aliases`* as alias

	alias djactivate='source ~/.virtualenvs/djangodev/bin/activate'

and resfresh bash or restart terminal
`$ . ~/.bashrc`

>-> if virtualenv isn't activated, django installs systemwide

#### Install latest version
`(django10) $ pip install Django==1.10`

#### or from from source
`$ git clone https://github.com/django/django.git`  
`(djangodev) $ sudo pip3 install -e /path/to/your/local/clone/django/`

recheck the version

	(djangodev) $ django-admin.py --version
	1.11.dev20160612013256


#### check paragraph "Where should this code live"
<sup>https://docs.djangoproject.com/en/dev/intro/tutorial01/#creating-a-project</sup>

Finaly I place projects in ~/dev folder. Below is the proposed djangoproject.com solution.

`$ sudo mkdir /home/firstimedjango/`  
`$ cd /home/firstimedjango/`

>folder *`./firstimedjango`* needs a user ownership if located out of ~  
>otherwise the command django-admin fails

>`$ sudo chown -R user /home/firstimedjango`


### start a new project
`(djangodev) $ django-admin startproject djprojone`

**remember** : to avoid possible malfunctioning and timeloss on error searching

- previously started projects out of virtualenv might become unresposive while later activated in virtualenv
- don't forget to set the ownership of the location where code resides (runserver command will not start the server properly)


### Django + spatial data => GeoDjango

Installation of two spatial database components are covered in this guide, SpatiaLite and PostGIS. Check the compatibility table for further info about functionalities and which to chose https://docs.djangoproject.com/en/dev/ref/contrib/gis/db-api/#spatial-lookup-compatibility

Use the installation [script](djlibsinst.sh) if the manual steps appear too scary.

### Spatial libraries

For managing spatial data with SQLite, SpatiaLite component is required.

GEOS, PROJ.4 and GDAL should be installed prior to building SpatiaLite or PostGIS, spatial component.

Geospatial libraries are recommended / required to run GeoDjango with corresponding spatial dbms.  
PostgreSQL ~ PostGIS  
SQLite ~ SpatiaLite

<sup>[requirements table](https://docs.djangoproject.com/en/1.9/ref/contrib/gis/install/geolibs/#installing-geospatial-libraries)  
Optional libraries : http://postgis.net/docs/manual-2.1/postgis_installation.html#install_requirements</sup> 


#### GEOS
<sup>refer to https://docs.djangoproject.com/en/dev/ref/contrib/gis/install/geolibs/#geos</sup>
><sub>geos-$VERSION.tar.bz2=3.5.0</sub>

`$ wget http://download.osgeo.org/geos/geos-$VERSION.tar.bz2`  
`$ tar xjf geos-$VERSION.tar.bz2`  
`$ cd geos-$VERSION`  
`>BUILD`

#### PROJ.4
Geospatial data converter for different coordinate reference systems
https://docs.djangoproject.com/en/dev/ref/contrib/gis/install/geolibs/#proj4
><sub>proj-$VERSION.tar.gz=4.9.2	proj-datumgrid-$VERSION.tar.gz=1.5</sub>

`$ wget http://download.osgeo.org/proj/proj-$VERSION.tar.gz`  
`$ wget http://download.osgeo.org/proj/proj-datumgrid-$VERSION.tar.gz`  
`$ tar xzf proj-$VERSION.tar.gz`

**important!** decompress contents of proj-datumgrid into *`proj-$VERSION/nad`* directory

`$ cd proj-$VERSION/nad`
`$ tar xzf ../../proj-datumgrid-$VERSION.tar.gz`
`$ cd ..`
`>BUILD`

#### GDAL
Opensource geospatial library gor vector (OGR) and raster data formats
>"Geospatial Object Oriented Data Abstraction Library" (GOODAL)

**GEOS and PROJ should be installed prior to building GDAL**

GDAL commands http://download.osgeo.org/gdal/presentations/OpenSource_Weds_Andre_CUGOS.pdf
><sub>gdal-$VERSION.tar.gz=2.1.1</sub>

`$ wget http://download.osgeo.org/gdal/CURRENT/gdal-$VERSION.tar.gz`  
`$ tar xzf gdal-$VERSION.tar.gz`  
`$ cd gdal-$VERSION`  
`>BUILD`

### Setting libraries system path

The location of external shared libraries (GEOS, GDAL) has to be specified. Tipical library directory for software built from source is /usr/local/lib. By including this path in the environment variable *LD_LIBRARY_PATH* the configuration is set on a per-user basis.

`$ export LD_LIBRARY_PATH=/usr/local/lib`

To configure it system-wide set the path in file *`/etc/ld.so.conf`*

`$ sudo echo /usr/local/lib >> /etc/ld.so.conf`
`$ sudo ldconfig`

Libraries located in a particular location should be set in Django settings file :

	GEOS_LIBRARY_PATH = '/home/user/local/lib/libgeos_c.so'
	GDAL_LIBRARY_PATH = '/home/user/local/lib/libgdal.so'

Other libraries might be needed :
#### JSON-C
For importing GeoJSON (via the function ST_GeomFromGeoJson)
><sub>json-c-$VERSION.tar.gz=0.12.1-20160607</sub>

<sup>latest release@ https://github.com/json-c/json-c/releases</sup>

`$ wget https://github.com/json-c/json-c/archive/json-c-$VERSION.tar.gz`  
`$ tar xf json-c-$VERSION.tar.gz`  
`$ cd json-c-$VERSION`  
`>BUILD`

#### libxml2
><sub>libxml2-$VERSION.tar.gz=2.9.4</sub>

`$ wget ftp://xmlsoft.org/libxml2/libxml2-$VERSION.tar.gz`  
`$ tar xf libxml2-$VERSION.tar.gz`  
`$ cd libxml2-$VERSION`  
`>BUILD`

### SpatiaLite library (libspatialite)
Current version
https://www.gaia-gis.it/fossil/libspatialite/index
><sub>libspatialite-$VERSION.tar.gz=4.4.0-RC0</sub>

`$ wget http://www.gaia-gis.it/gaia-sins/libspatialite-$VERSION.tar.gz`  
`$ tar xf libspatialite-$VERSION.tar.gz`  
`$ cd libspatialite-$VERSION`

Check README for required dependencies. SQLite 3 should be properly installed, as well as PROJ.4 and GEOS libraries.

Getting *'configure: error: cannot find freexl.h, bailing out'* error means that FreeXL dependency is missing. You can disable it by using a parameter when executing configuration script.

>`$ ./configure --enable-freexl=no`

Altohugh it might come handy to extract data out of xls files, it's what FreeXL is for. If so, install the dependancy found at https://www.gaia-gis.it/fossil/freexl/index by following the usual `>BUILD` procedure and then build SpatiaLite with full dependency support.

**Spatialite variable has to be set in settings.py for versions 4.2+**

	SPATIALITE_LIBRARY_PATH = 'mod_spatialite'

<sup>https://github.com/leplatrem/django-leaflet-geojson/issues/7#issuecomment-210979469</sup>  
<sup>https://docs.djangoproject.com/en/1.9/ref/contrib/gis/install/spatialite/#spatialite-source</sup>


A friendly *meta-variable* `>BUILD` which contains commands for making and installing is used in this guide to make it shorter and more comprehensible. Whenever you see it, its means the following block :

	$ ./configure
	$ make
	$ sudo make install # *1 *2
	$ sudo ldconfig
	$ cd ..	

><sup>\*1</sup>sudo make install-strip <sup>\*2</sup>sudo-checkinstall  
>check [uninstall guides](#uninstall-guides) about installing from source

<sup>https://pypi.python.org/packages/cc/a4/023ee9dba54b3cf0c5a4d0fb2f1ad80332ef23549dd4b551a9f2cbe88786/pysqlite-2.8.2.tar.gz#md5=b8488f6a353bd6a3cd85d327d326376a</sup>


### SQLite
Django works with in the box db engine solution SQLite, usualy already on a Linux system.

Check if SQLite is installed

`$ sqlite3`

While in sqlite prompt type

`sqlite> CREATE VIRTUAL TABLE testrtree USING rtree(id,minX,maxX,minY,maxY);`

#### SQLite installation
If error appears or if sqlite isn't on system, build it from source :

><sub>sqlite-amalgamation-$VERSION=313000</sub>

`$ wget https://www.sqlite.org/2016/sqlite-autoconf-$VERSION.tar.gz`  
`$ tar xf sqlite-autoconf-$VERSION.tar.gz`  
`$ cd sqlite-autoconf-$VERSION`

`$ CFLAGS="-DSQLITE_ENABLE_RTREE=1" ./configure` _#R\*Tree module - index structure for spatial searching_  
`$ make`  
`$ sudo make install`  
`$ sudo ldconfig`  
`$ cd ..`

## PostgreSQL and PostGIS
[comparison matrix](https://trac.osgeo.org/postgis/wiki/UsersWikiPostgreSQLPostGIS)</sup>

Deploying projects for production purposes and beyond testing environments involves more built-proof dbms.

Below is a complete installation procedure on how and why to install pgadmin, pgrouting, contrib and other subpackages & libraries

### PostgreSQL

This guide is inspired essentialy from [djangoproject](https://docs.djangoproject.com/en/1.9/ref/contrib/gis/install/). References are included for particular installation steps & details.

#### PostgreSQL database installation
<sup>https://www.postgresql.org/download/linux/ubuntu/</sup>
###### installing a default version for your ubuntu release
><sub>postgresql-$VERSION=9.5</sub>

	$ apt-get install postgresql-$VERSION

###### installing another/latest version via PostgreSQL Apt Repository

create *`pgdg.list`*

`$ sudo touch /etc/apt/sources.list.d/pgdg.list`

add the repository for your current ubuntu release

`$ sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'`

import the repository key

`$ sudo apt-get install wget ca-certificates`  
`$ wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -`

update repository

`$ sudo apt-get update`  
`$ sudo apt-get upgrade`  
`$ sudo apt-get install postgresql-$VERSION`


Install includes subpackages :
- *contrib* - provides additional supplied modules like 'fuzzystrmatch', 'pgrouting'

	If not installed at this point it can be done later

	`$ sudo apt-get install postgresql-contrib-$VERSION postgresql-$VERSION-pgrouting`

- *UGI* for db administration if needed :

	`$ sudo apt-get install pgadmin3`

<sup>info extracted from : http://postgis.net/install/
https://www.postgresql.org/download/linux/ubuntu/
http://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS22UbuntuPGSQL95Apt
https://wiki.postgresql.org/wiki/Apt</sup>


- *binutils* - GNU assembler, linker and binary utilities #Python needs `find_library` routine ( may be already on system )
- *libproj-dev* - Cartographic projection library (development files)  
- *gdal-bin* - Geospatial Data Abstraction Library - Utility programs #for GDAL command line programs like `ogr2ogr` ( may be already on system )

	`$ sudo apt-get install binutils libproj-dev gdal-bin`

- *libgeoip1* - non-DNS IP-to-country resolver library #for GeoIP support ! Deprecated since Django 1.9

- *python-gdal* - Python bindings to the Geospatial Data Abstraction Library #for GDAL’s own Python bindings - includes interfaces for raster manipulation

Running GeoDjango with PostGIS requires the PostgreSQL adapter psycopg2. Prior to its installation the packages below are needed (may be already on system if PostreSQL is present) :

`$ sudo apt-get install python3-dev` #for compiling psycopg2 in virtualenv  
`$ sudo apt-get install libpq-dev`

and then the adapter for Python (activate virtualenv)

`(djangodev) $ pip install psycopg2`

### PostGIS - spatial component for PostgreSQL
<sup>https://docs.djangoproject.com/en/dev/ref/contrib/gis/install/postgis/#spatialdb-template91</sup>

**GEOS, PROJ.4 and GDAL should be installed prior to building PostGIS**
><sub>postgis-$VERSION.tar.gz=2.2.2</sub>

`$ wget http://download.osgeo.org/postgis/source/postgis-$VERSION.tar.gz`  
`$ tar xf postgis-$VERSION.tar.gz`  
`$ cd postgis-$VERSION`  
`$ ./configure`  

>If an error occurs it's probably missing PostgreSQL server development packages. In that case re-run ./configure after installing server-dev

>`$ sudo apt-get install postgresql-server-dev-$VERSION`

`$ make`  
`$ make check`  
`$ sudo make install`  
`$ sudo ldconfig`  
`$ cd ..`

If creating extensions produces an error below, rebuilding from source might help :

	ERROR:  could not load library "/usr/lib/postgresql/9.5/lib/postgis-2.2.so": /usr/lib/postgresql/9.5/lib/postgis-2.2.so: undefined symbol: lwgeom_sfcgal_version

<sub>http://gis.stackexchange.com/questions/192650/postgis-broken-after-ubuntu-16-04-upgrade/#202729</sub>

Check [psql-how-to](psql_how_to.md) for setting up a postgresql spatial database or the post-install instructions https://docs.djangoproject.com/en/1.10/ref/contrib/gis/install/postgis/#post-installation

[stack 1]: http://stackoverflow.com/questions/3132265/how-do-i-access-the-command-history-from-idle
[1]: https://docs.djangoproject.com/en/dev/intro/tutorial01/#writing-your-first-django-app-part-1 "writing your first django app"