FROM eclipse-temurin:17-jdk

WORKDIR /opt/yamcs

# Prebuilt Yamcs 5.12.6 distribution (copied from host build context)
COPY yamcs-5.12.6.tar.gz /tmp/yamcs.tar.gz
RUN tar xzf /tmp/yamcs.tar.gz -C /opt/yamcs --strip-components=1 \
    && rm /tmp/yamcs.tar.gz \
    && chmod +x /opt/yamcs/bin/yamcsd /opt/yamcs/bin/yamcsadmin

# Overlay the simulator example config + MDB (script algorithms present)
COPY yamcs-config/ /opt/yamcs/

# jython-standalone for the Jython algorithm engine (CVE-2026-46621 repro)
COPY yamcs-jython.jar /opt/yamcs/lib/jython-standalone.jar

# simulator module jar (org.yamcs.simulator.SimulatorCommander) to drive telemetry
COPY yamcs-simulator.jar /opt/yamcs/lib/yamcs-simulator.jar

EXPOSE 8090

ENV JAVA_OPTS="-Xmx768m -XX:+UseG1GC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/"

CMD ["bin/yamcsd"]
