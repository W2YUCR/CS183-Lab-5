# Lab 5 - OpenLDAP Server and Client (Docker)

## Set up containers

```sh
ssh-keygen -t rsa -f ./ssh_host_rsa_key
```

```sh
docker buildx create --name insecure-builder --buildkitd-flags "--allow-insecure-entitlement=security.insecure" --use
docker compose up --detach
```

## Exec into the authentication server

```sh
docker compose exec auth_server /bin/bash 
```

```sh
./setup.sh
```

## Exec into the client

```sh
docker compose exec client /bin/bash 
```

```sh
./setup.sh
```