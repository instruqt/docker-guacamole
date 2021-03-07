FROM maven AS build

WORKDIR /workdir
RUN git clone https://github.com/mike-jumper/guacamole-legacy-urls.git

WORKDIR /workdir/guacamole-legacy-urls
RUN mvn package


FROM oznu/guacamole

COPY --from=build /workdir/guacamole-legacy-urls/target/guacamole-legacy-urls-*.jar /app/guacamole/extensions/
