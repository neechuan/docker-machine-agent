FROM centos:7

# Install AppDynamics Machine Agent
ENV MACHINE_AGENT_HOME /opt/machine-agent

WORKDIR ${MACHINE_AGENT_HOME}

#RUN curl -jksSL -o /tmp/machine-agent.zip http://lab-garydockerlab-gzvlnw1g.srv.ravcloud.com/machine-agent.zip
ADD machine-agent.zip /tmp/

RUN mkdir -p ${MACHINE_AGENT_HOME} && \
    yum install -y unzip && \
    yum install -y iproute && \
    unzip -oq /tmp/machine-agent.zip -d ${MACHINE_AGENT_HOME} && \
    rm /tmp/machine-agent.zip && \
    chgrp -R 0 ${MACHINE_AGENT_HOME} && \
    chmod -R g+rwX ${MACHINE_AGENT_HOME}

COPY log4j.xml conf/logging/log4j.xml

ENV PARAMS='-Dappdynamics.controller.ssl.enabled=false -Dappdynamics.sim.enabled=true'
#ENV APPDYNAMICS_CONTROLLER_HOST_NAME=lab-garydockerlab-gzvlnw1g.srv.ravcloud.com
#ENV APPDYNAMICS_CONTROLLER_PORT=8090
#ENV APPDYNAMICS_AGENT_ACCOUNT_NAME=customer1
#ENV APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=1269b04b-d6d9-4632-bee0-dc08417b17e4

EXPOSE 9090

# Configure and Run AppDynamics Machine Agent
CMD ${MACHINE_AGENT_HOME}/jre/bin/java ${PARAMS} -jar ${MACHINE_AGENT_HOME}/machineagent.jar
