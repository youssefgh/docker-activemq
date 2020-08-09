FROM docker.pkg.github.com/youssefgh/docker-openjdk/openjdk:11.0.4_p4-r1

LABEL maintainer="Youssef GHOUBACH <ghoubach.youssef@gmail.com>"

RUN apk add --update \
    curl

ENV VERSION 5.16.0

ENV PACKAGE_NAME apache-activemq-$VERSION-bin

ENV PACKAGE_TAR $PACKAGE_NAME.tar.gz&action=download

ENV PACKAGE http://www.apache.org/dyn/closer.cgi?filename=/activemq/$VERSION/$PACKAGE_TAR

RUN cd /opt \
    && curl -L -O $PACKAGE

RUN cd /opt \
    && ls \
    && tar -xvzf $PACKAGE_TAR \
    && rm $PACKAGE_TAR

ENV ACTIVEMQ_HOME=/opt/apache-activemq-$VERSION

RUN sed -i 's|property name="host" value="127.0.0.1"|property name="host" value="0.0.0.0" |g' $ACTIVEMQ_HOME/conf/jetty.xml

EXPOSE 61616 8161

WORKDIR $ACTIVEMQ_HOME

ENTRYPOINT $ACTIVEMQ_HOME/bin/activemq console
