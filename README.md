# Lab 5 - OpenLDAP Server and Client (Docker)

## Set up containers

```sh
ssh-keygen -t rsa -f ./ssh_host_rsa_key
```

```sh
docker buildx create --name insecure-builder --buildkitd-flags "--allow-insecure-entitlement=security.insecure" --use
docker compose build --build-arg username=<username>
docker compose up --detach
```

## SSH into the authentication server

```sh
ssh <username>@127.0.0.1 -p 2020 -i ./ssh_host_rsa_key
```

```sh
sudo ./setup.sh
```

## SSH into the client

```sh
ssh <username>@127.0.0.1 -p 2021 -i ./ssh_host_rsa_key
```

```sh
sudo ./setup.sh
```