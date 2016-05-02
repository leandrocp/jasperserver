#!/bin/bash -e

DB_TYPE=${DB_TYPE:-postgresql}
DB_USER=${DB_USER:-postgres}
DB_PASSWORD=${DB_PASSWORD:-postgres}


function connect_postgres() {
  host="database"
  port=$(env | grep DATABASE_PORT | grep TCP_PORT | cut -d = -f 2)

  echo -n "-----> waiting for postgreSQL on $host:$port ..."
  while ! nc -w 1 $host $port 2>/dev/null
  do
    echo -n .
    sleep 1
  done

  echo '[OK database login success]'
}

if [ "$1" = 'jasperserver' ]; then
  if [ ! -d "$CATALINA_HOME/webapps/jasperserver" ]; then

    cp ${JASPERSERVER_BUILD}/sample_conf/${DB_TYPE}_master.properties /jasperconfig/default_master.properties
    sed -i -e "s|^appServerDir.*$|appServerDir = $CATALINA_HOME|g; s|^dbHost.*$|dbHost=database|g; s|^dbUsername.*$|dbUsername=$DB_USER|g; s|^dbPassword.*$|dbPassword=$DB_PASSWORD|g" \
      /jasperconfig/default_master.properties
    ln -s /jasperconfig/default_master.properties ${JASPERSERVER_BUILD}/default_master.properties

    pushd ${JASPERSERVER_BUILD}

    if [ ! -f "/var/lib/postgresql/db_created.sh" ]; then

      connect_postgres
      ./js-ant create-js-db init-js-db-ce import-minimal-ce deploy-webapp-ce

      echo 'PostgrSQL database created'
      touch /var/lib/postgresql/db_created.sh
    else
      echo 'PostgrSQL database already exists'
    fi
    popd
  fi

  connect_postgres

  rm -f ${JASPERSERVER_BUILD}/default_master.properties && \
    ln -s /jasperconfig/default_master.properties ${JASPERSERVER_BUILD}/default_master.properties

  catalina.sh run
else
  exec "$@"
fi