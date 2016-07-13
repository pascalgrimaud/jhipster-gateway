FROM jhipster/jhipster

ENV JHIPSTER_SLEEP 0
ENV SPRING_PROFILES_ACTIVE=prod
ENV SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/jhgateway?useUnicode=true&characterEncoding=utf8&useSSL=false

# add source
ADD . /home/jhipster/code/

USER root
RUN chown -R jhipster:jhipster /home/jhipster/code/
USER jhipster

# package the application and delete all lib
RUN cd /home/jhipster/code/ && \
    ./mvnw package -Pprod -DskipTests && \
    mv /home/jhipster/code/target/*.war /home/jhipster/app.war && \
    rm -Rf /home/jhipster/code && \
    rm -Rf /home/jhipster/.m2 && \
    rm -Rf /home/jhipster/.gradle && \
    rm -Rf /home/jhipster/.npm/

RUN sh -c 'touch /home/jhipster/app.war'
VOLUME /tmp
EXPOSE 8080 5701/udp
CMD echo "The application will start in ${JHIPSTER_SLEEP}s..." && \
    sleep ${JHIPSTER_SLEEP} && \
    java -Djava.security.egd=file:/dev/./urandom -jar /home/jhipster/app.war
