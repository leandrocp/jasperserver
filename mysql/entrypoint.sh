#!/bin/bash -e

DB_TYPE=${DB_TYPE:-mysql}
DB_USER=${DB_USER:-root}
DB_PASSWORD=${DB_PASSWORD:-mysql}


function wait_mysql() {
  host="database"
  port=$(env | grep DATABASE_PORT | grep TCP_PORT | cut -d = -f 2)

  echo -n "-----> waiting for MySQL on $host:$port ..."
  while ! nc -w 1 $host $port 2>/dev/null
  do
    echo -n .
    sleep 1
  done

  echo '[OK]'
}

if [ "$1" = 'jasperserver' ]; then
  if [ ! -d "$CATALINA_HOME/webapps/jasperserver" ]; then

    cp ${JASPERSERVER_BUILD}/sample_conf/${DB_TYPE}_master.properties /jasperconfig/default_master.properties

    sed -i -e "s|^appServerDir.*$|appServerDir = $CATALINA_HOME|g; s|^dbHost.*$|dbHost=database|g; s|^dbUsername.*$|dbUsername=$DB_USER|g; s|^dbPassword.*$|dbPassword=$DB_PASSWORD|g" \
      /jasperconfig/default_master.properties

    ln -s /jasperconfig/default_master.properties ${JASPERSERVER_BUILD}/default_master.properties

    pushd ${JASPERSERVER_BUILD}

    wait_mysql

    ./js-ant create-js-db init-js-db-ce import-minimal-ce deploy-webapp-ce

    popd
  fi

  wait_mysql

  rm -f ${JASPERSERVER_BUILD}/default_master.properties && \
    ln -s /jasperconfig/default_master.properties ${JASPERSERVER_BUILD}/default_master.properties

  catalina.sh run
else
  exec "$@"
fi