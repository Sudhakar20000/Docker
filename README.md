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

## 🧩 Services Containerized

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
cd Docker
```

This project ships with a `docker-compose.yml`, so you don't need to build/run each service manually — Compose handles building every service's image and wiring up the shared network in one shot.

Build and start everything:

```bash
docker compose up -d --build
```

Check status of all running containers:

```bash
docker compose ps
```

Stop and remove everything:

```bash
docker compose down
```

> Compose automatically creates a shared network for all services, so containers can reach each other by service name (e.g. the `user` service connects to `mongodb`, not `localhost`) — no manual `--network` flags needed.

## 🔧 Environment Variables

Each service's datastore connection details are passed in via environment variables defined in `docker-compose.yml` (or an accompanying `.env` file), for example:

```yaml
user:
  build: ./docker_files/user
  environment:
    - MONGO_URL=mongodb://mongodb:27017/users
  ports:
    - "8080:8080"
  depends_on:
    - mongodb
```

Refer to `docker-compose.yml` for the exact variable names and values each service expects.

## 🗺️ Roadmap / Infra

The `docker_infra/` directory contains supporting infrastructure code (networking, security groups,storage rules, etc.) used to deploy these containers to AWS. See that folder's own documentation for details.
