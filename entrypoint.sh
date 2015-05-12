#!/bin/bash
set -e

DB_TYPE=${DB_TYPE:-mysql}
DB_USER=${DB_USER:-root}
DB_PASSWORD=${DB_PASSWORD:-mysql}

if [ "$1" = 'jasperserver' ]; then
  if [ ! -d "$CATALINA_HOME/webapps/jasperserver" ]; then

    cp ${JASPERSERVER_BUILD}/sample_conf/${DB_TYPE}_master.properties /data/default_master.properties

    sed -i -e "s|^appServerDir.*$|appServerDir = $CATALINA_HOME|g; s|^dbHost.*$|dbHost=$MYSQL_PORT_3306_TCP_ADDR|g; s|^dbUsername.*$|dbUsername=$DB_USER|g; s|^dbPassword.*$|dbPassword=$DB_PASSWORD|g" \
      /data/default_master.properties

    ln -s /data/default_master.properties ${JASPERSERVER_BUILD}/default_master.properties

    pushd ${JASPERSERVER_BUILD}

    sleep 10

    ./js-ant create-js-db init-js-db-ce import-minimal-ce deploy-webapp-ce

    popd
  fi
  sleep 10

  rm -f ${JASPERSERVER_BUILD}/default_master.properties && \
  ln -s /data/default_master.properties ${JASPERSERVER_BUILD}/default_master.properties

  catalina.sh run
else
  exec "$@"
fi
