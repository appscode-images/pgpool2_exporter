FROM alpine:3

LABEL maintainer="AppsCode <support@appscode.com>"

ARG TARGETOS
ARG TARGETARCH

ENV POSTGRES_USERNAME postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_DATABASE postgres
ENV PGPOOL_SERVICE localhost
ENV PGPOOL_SERVICE_PORT 9999
ENV SSLMODE disable

# Create postgres user used to start Pgpool-II
RUN set -ex; \
    addgroup -g 70 -S postgres; \
    adduser -u 70 -S -D -G postgres -H -h /var/lib/pgsql -s /bin/sh postgres; \
    mkdir -p /var/lib/pgsql; \
    chown -R postgres:postgres /var/lib/pgsql

COPY .build/${TARGETOS}-${TARGETARCH}/pgpool2_exporter /bin/pgpool2_exporter

CMD ["/bin/sh", "-c", "export DATA_SOURCE_USER=\"${POSTGRES_USERNAME}\" ; export DATA_SOURCE_PASS=\"${POSTGRES_PASSWORD}\" ; export DATA_SOURCE_URI=\"${PGPOOL_SERVICE}:${PGPOOL_SERVICE_PORT}/${POSTGRES_DATABASE}?sslmode=${SSLMODE}\" ; /bin/pgpool2_exporter"]

USER 70

EXPOSE     9719
