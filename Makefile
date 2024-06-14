LOCAL_DIR=$(PWD)/_local
DATA_DIR=$(LOCAL_DIR)/data

reset_volumes:
	docker compose down || true; \
	SAMBA_DIR=$(DATA_DIR)/samba && sudo rm -rdf $$SAMBA_DIR && mkdir -p -m 777 $$SAMBA_DIR && sudo chown -R 1001:1001 $$SAMBA_DIR

run:
	docker compose down || true; docker compose up --build -V --force-recreate

run_detach:
	docker compose down || true; docker compose up --build -V --force-recreate -d

build_multi:
	docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t adrianmusante/samba:0.0.0 samba

build_local:
	docker buildx build --load -t adrianmusante/samba:0.0.0 samba

logs:
	docker compose logs -f
