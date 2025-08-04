.PHONY: build-and-up start stop restart logs compile-config

ENV := ${env}

ifeq ($(ENV),)
ENV := dev #Set default enviroment.
endif

build-and-up: compile-config start

start:
	docker-compose up

stop:
	docker-compose down --volumes

restart:
	docker-compose restart

logs:
	docker-compose logs -f

compile-config:
	docker run \
        -v $(PWD):/etc/krakend \
        -e FC_ENABLE=1 \
        -e FC_SETTINGS=/etc/krakend/config/settings/${ENV} \
        -e FC_PARTIALS=/etc/krakend/config/partials \
        -e FC_TEMPLATES=/etc/krakend/config/templates \
        -e FC_OUT=/etc/krakend/krakend.json \
        devopsfaith/krakend \
        check -c krakend-config.tmpl
