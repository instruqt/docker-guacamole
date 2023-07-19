FROM maven AS build

WORKDIR /workdir
RUN git clone https://github.com/mike-jumper/guacamole-legacy-urls.git

WORKDIR /workdir/guacamole-legacy-urls
RUN mvn package

FROM jwetzell/guacamole

RUN apt-get update && apt-get install -y netcat vim

COPY --from=build /workdir/guacamole-legacy-urls/target/guacamole-legacy-urls-*.jar /app/guacamole/extensions/
