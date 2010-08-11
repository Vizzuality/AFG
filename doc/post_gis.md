# More info

http://github.com/nofxx/postgis_example

http://kosmaczewski.net/2008/04/23/postgresql-leopard/

http://www.gregbenedict.com/2009/08/31/installing-postgresql-on-snow-leopard-10-6/

# Launch pgsql
sudo su
su - postgres -c "/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data"

# Create postgis_template
# from http://github.com/nofxx/postgis_example
sudo su
su postgres
psql template1

create database template_postgis with template = template1;
UPDATE pg_database SET datistemplate = TRUE where datname = 'template_postgis';
\c template_postgis
CREATE LANGUAGE plpgsql;
\i /usr/local/pgsql/share/contrib/postgis-1.5/postgis.sql;
\i /usr/local/pgsql/share/contrib/postgis-1.5/spatial_ref_sys.sql;
GRANT ALL ON geometry_columns TO PUBLIC;
GRANT ALL ON spatial_ref_sys TO PUBLIC;
VACUUM FREEZE;


# Create database

$ createdb -T template_postgis afg_development
