SHELL=/bin/bash
MAKEFLAGS+=-s
LOCAL_DIR=$(PWD)/_local
DATA_DIR=$(LOCAL_DIR)/data

reset-volumes:
	docker compose down || true; \
	SAMBA_DIR=$(DATA_DIR)/samba && sudo rm -rdf $$SAMBA_DIR && mkdir -p -m 777 $$SAMBA_DIR && sudo chown -R 1001:1001 $$SAMBA_DIR

run-min:
	docker compose ./docker-compose.min.yml down || true; docker compose -f ./docker-compose.min.yml up --build -V --force-recreate

run:
	docker compose down || true; docker compose up --build -V --force-recreate

run-detach:
	docker compose down || true; docker compose up --build -V --force-recreate -d

build-multi:
	docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t adrianmusante/samba:0.0.0 samba

build-local:
	docker buildx build --load -t adrianmusante/samba:0.0.0 samba

logs:
	docker compose logs -f

samba-repository-version: # https://pkgs.alpinelinux.org/packages?name=samba&branch=v3.22&repo=main&arch=
	docker run --rm alpine:3 sh -c "apk --no-cache --no-progress update >/dev/null && apk upgrade >/dev/null && apk search -v -e samba | tr ' ' '\n' | grep 'samba-' | cut -d'-' -f2-"