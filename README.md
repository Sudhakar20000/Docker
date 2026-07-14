# Docker –  Microservices Containerization

This repository contains production-style Dockerfiles and supporting infra for containerizing , a sample microservices e-commerce application, along with its backing data stores (MongoDB, MySQL, Redis, RabbitMQ) and reverse-proxy/ALB layer.

## 📁 Repository Structure

```
Docker/
├── docker_files/     # Dockerfiles for each microservice / component
├── docker_infra/      # Supporting infra (networking, compose, IaC, etc.)
└── .gitignore
```

> Update the tree above if your folder layout differs — see "Structure" note below.

##  Services Containerized

| Service     | Description                          | Port |
|-------------|---------------------------------------|------|
| frontend    | Web UI (reverse proxy to backend)     | 80   |
| catalogue   | Product catalogue API                 | 8080 |
| user        | User registration/auth API            | 8080 |
| cart        | Shopping cart API                     | 8080 |
| shipping    | Shipping cost calculation API         | 8080 |
| payment     | Payment processing API                | 8080 |
| mongodb     | Document store (catalogue, user data) | 27017|
| redis       | Cart session cache                    | 6379 |
| mysql       | Shipping data store                   | 3306 |
| rabbitmq    | Message queue (payment events)        | 5672 |

## 🐳 Docker Best Practices Followed

This project's Dockerfiles are built around a few core principles:

- **Minimal base images** — Alpine-based official images wherever possible, pinned to specific versions (not `latest`).
- **Multi-stage builds** — build/compile dependencies are isolated in a builder stage; only the final artifact ships in the runtime image.
- **Non-root containers** — every service runs as a dedicated, unprivileged user rather than `root`.
- **Layer-cache-aware ordering** — rarely-changing instructions (base image, dependency manifests) are placed above frequently-changing ones (source code) to maximize cache hits and speed up rebuilds.
- **Consolidated `RUN` instructions** — related shell commands are chained with `&&` to minimize layer count and avoid leaving stray cache artifacts behind.


## 🚀 Getting Started

Clone the repo:

```bash
git clone https://github.com/Sudhakar20000/Docker.git
cd Docker/docker_files
```

Build an individual service image:

```bash
cd user
docker build -t roboshop-user:v1 .
```

Build all service images in one go:

```bash
for service in mongodb mysql redis rabbitmq catalogue user cart shipping payment frontend; do
  cd docker_files/$service
  docker build -t roboshop-$service:v1 .
  cd -
done
```

Run a container:

```bash
docker run -d --name user -p 8080:8080 --network roboshop-net roboshop-user:v1
```

> Make sure dependent services (e.g. `mongodb` for `user`, `redis` for `cart`) are running on the same Docker network before starting a dependent service, and that connection details are passed via environment variables — not hardcoded.

## 🔧 Environment Variables

Each service expects its datastore connection info via environment variables at runtime, for example:

```bash
docker run -d --name user \
  -e MONGO_URL=mongodb://mongodb:27017/users \
  -p 8080:8080 \
  --network roboshop-net \
  roboshop-user:v1
```

Refer to each service's Dockerfile / source for the exact variable names it expects.

## 🗺️ Roadmap / Infra

The `docker_infra/` directory contains supporting infrastructure code (networking, security groups, ALB rules, etc.) used to deploy these containers to AWS. See that folder's own documentation for details.

