FROM krakend:2.10.2 as builder

ARG ENV=dev


WORKDIR /etc/krakend

COPY krakend-config.tmpl .
COPY config .

RUN echo "CURRENT ENVIRONMENT: ${ENV} and $ENV"

RUN FC_ENABLE=1 \
    FC_OUT=/tmp/krakend.json \
    FC_PARTIALS="/etc/krakend/partials" \
    FC_SETTINGS="/etc/krakend/settings/$ENV" \
    FC_TEMPLATES="/etc/krakend/templates" \
    SERVICE_NAME="Amaze Open Console Gateway" \
    krakend check -d -t -c krakend-config.tmpl

RUN krakend check -c /tmp/krakend.json --lint

FROM krakend:2.10.2
# MOVE file from tmp/ to /etc/krakend
COPY --from=builder --chown=krakend:nogroup /tmp/krakend.json .
