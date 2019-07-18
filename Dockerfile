FROM alpine:latest as build
MAINTAINER d.ermizin <kernel218@gmail.com>
RUN apk update -q && apk add -q git \
    maven \
    openjdk8 \
    && rm -rf /var/cache/apk/*
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git /maven_build
WORKDIR /maven_build
RUN mvn -q package

FROM alpine:latest
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

RUN apk update -q \
    && apk add -q openjdk8-jre \
    && rm -rf /var/cache/apk/*
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.42
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN wget -q "$TOMCAT_TGZ_URL" -O tomcat.tar.gz \
    && tar -xf tomcat.tar.gz --strip-components=1 \
    && rm bin/*.bat \
    && rm tomcat.tar.gz* \
    && rm -fr $CATALINA_HOME/webapps/* \
    && rm -fr $CATALINA_HOME/bin/*.tar.gz \
    && find $CATALINA_HOME -type f -maxdepth 1 -delete
COPY --from=build /maven_build/target/hello-*.war $CATALINA_HOME/webapps/ROOT.war

CMD ["catalina.sh", "run"]
