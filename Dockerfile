# Ref:
# https://registry.hub.docker.com/u/derekha2010/jasperserver/
# http://www.alexecollins.com/docker-linking-containers/
# https://github.com/docker/compose/issues/374
# https://github.com/aanand/docker-wait/blob/master/wait
# https://github.com/dominionenterprises/tol-api-php/blob/master/tests/provisioning/set-env.sh
# http://community.jaspersoft.com/sites/default/files/questions/default_master.properties

FROM tomcat:7
MAINTAINER Leandro Cesquini Pereira leandro.cesquini@gmail.com

ENV JASPERSERVER_HOME /jasperserver
ENV JASPERSERVER_BUILD /jasperserver/buildomatic
ENV PATH $JASPERSERVER_HOME/buildomatic:$PATH
ENV CATALINA_OPTS="-Xmx512m -XX:MaxPermSize=256m -XX:+UseBiasedLocking -XX:BiasedLockingStartupDelay=0 -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:+CMSParallelRemarkEnabled -XX:+UseCompressedOops -XX:+UseCMSInitiatingOccupancyOnly"

#RUN apt-get update && apt-get install -y unzip vim && rm -rf /var/lib/apt/lists/*

# RUN curl -SL http://sourceforge.net/projects/jasperserver/files/JasperServer/JasperReports%20Server%20Community%20Edition%206.0.1/jasperreports-server-cp-6.0.1-bin.zip -o /tmp/jasperserver.zip
COPY jasperreports-server-cp-6.0.1-bin.zip /tmp/jasperserver.zip

RUN unzip /tmp/jasperserver.zip -d /jasperserver && \
    mv -v /jasperserver/jasperreports-server-cp-6.0.1-bin/* /jasperserver && \
    rmdir -v /jasperserver/jasperreports-server-cp-6.0.1-bin && \
    rm -rf /tmp/*

VOLUME /jasperserver

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["jasperserver"]
