FROM openjdk:10-jdk as jodconverter-builder
RUN apt-get update \
  && apt-get -y install git gradle \
  && git clone --branch v4.2.2 https://github.com/sbraconnier/jodconverter /tmp/jodconverter

WORKDIR /tmp/jodconverter

RUN gradle build  -x integrationTest -x test -x javadoc -p jodconverter-cli

RUN tar xvC /opt -f jodconverter-cli/build/distributions/jodconverter-cli*.tar \
  && mv /opt/jodconverter-cli* /opt/jodconverter-cli \
  && chmod +x /opt/jodconverter-cli/bin/jodconverter-cli

FROM eugenmayer/jodconverter:base
RUN adduser --system --home /home/app --group app
COPY --from=jodconverter-builder /opt/jodconverter-cli /home/app/jodconverter-cli
COPY /src/main/docker /home/app
RUN chmod +x /home/app/jodconverter.sh

# override entrypoint of jodconverter:base
ENTRYPOINT  []

RUN echo "Pulling watchdog binary from Github." \
    && curl -sSL https://github.com/openfaas/faas/releases/download/0.9.14/fwatchdog > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog \
    && cp /usr/bin/fwatchdog /home/app

WORKDIR /home/app

USER app

# Populate example here - i.e. "cat", "sha512sum" or "node index.js"
ENV fprocess="./jodconverter.sh"
# Set to true to see request in function logs
ENV write_debug="false"

EXPOSE 8080

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1
CMD [ "fwatchdog" ]
