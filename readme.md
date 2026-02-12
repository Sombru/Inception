*This project has been created as part of the 42 curriculum by pkostura.*

# Inception

## Description

Inception is a system administration project focused on containerization using Docker.  
The goal is to build a small, secure, production-like web infrastructure composed of multiple services running in isolated containers and communicating through a Docker network.

The infrastructure includes:

- **NGINX** (TLS reverse proxy with SSL)
- **WordPress** (PHP-FPM application)
- **MariaDB** (database server)

Each service runs in its own container, built from a dedicated Dockerfile.  
No prebuilt application images are used (except base distribution image of debian:stable-lim).

### Key Components

- **docker-compose.yml** – Defines services, volumes, networks, and secrets.
- **.env** – Contains non-sensitive configuration variables.
- **requirements/** – Contains Dockerfiles and configuration files for each service.
- **secrets/** – Stores sensitive credentials.

---

## Instructions

### 1. Prerequisites

- Docker
- Docker-composev2 
- Linux environment 
- Makefile
- Inteligence(optional)

### 2. Configure Hosts File

Add your domain to `/etc/hosts` if you have permisions, otherwise default localhost will be used:

### 3. Enviroment

Make make sure to add ./srcs/.env file
## .env
	DOMAIN_NAME=domain.examle.foo #this should be same as domain in your /etc/hosts file

	MYSQL_DATABASE=dabase_name_example
	MYSQL_USER=example_user

	WP_DB_HOST=mariadb #unless you are planning to use difernet DB host leave this as is

## ./secrets/db_password.txt
This file contains user's password to access database and NOTHING ELSE (no extra tabs/spaces/newlines/comments)

    qwerty67

## ./secrets/db_root_password.txt
This file contains root's () password to access WHOLE database and NOTHING ELSE (no extra tabs/spaces/newlines/comments)

    Abbsaop78oa

## ./secrets/credentitals.txt
This file is irrelevant you can ignore it

### 4. Build and Run

From the project root:

    make up - start the app
    make down - to stop the app

Check "**Makefile**"in project root to for more options

# Resources

### Documentation

- Docker Official Documentation  
  https://docs.docker.com/

- Docker Compose Documentation  
  https://docs.docker.com/compose/

- NGINX Documentation  
  https://nginx.org/en/docs/

- MariaDB Documentation  
  https://mariadb.org/documentation/
- Boot.dev SQL and Docker practice  
  www.boot.dev/

- WordPress CLI Documentation  
  https://developer.wordpress.org/cli/

---

## Use of AI

AI (ChatGPT) was used for:

- Clarifying Docker concepts (networks, secrets, volumes)
- Debugging configuration issues
- Improving understanding of best practices
- Assisting in documentation structure
- Confusing author with false information

All architectural decisions, implementation, debugging, and configuration were performed manually and verified independently.

---

# Technical Design Choices

## Why Docker?

Docker allows services to run in isolated containers while sharing the same kernel.  
It ensures reproducibility, portability, and easier service orchestration compared to traditional VM-based setups.

---

## Virtual Machines vs Docker

### Virtual Machines
- Run a full guest OS
- Higher resource consumption
- Slower startup
- Stronger isolation (hardware-level)

### Docker
- Shares host kernel
- Lightweight
- Fast startup
- Efficient resource usage
- Ideal for microservices architecture
- No more "it works on my machine problems" beacase we ship **my** machine

Docker was chosen because it provides sufficient isolation while being significantly more efficient and practical for multi-service deployments.

---

## Secrets vs Environment Variables

### Environment Variables
- Easy to configure
- Visible through `docker inspect`
- Not suitable for sensitive data

### Docker Secrets
- Stored as files inside `/run/secrets`
- Not exposed in container metadata
- Safer for passwords and credentials

Passwords for MariaDB and WordPress are managed using Docker secrets to avoid exposing them in `.env` or `docker-compose.yml`.

---

## Docker Network vs Host Network

### Host Network
- Containers share host network stack
- No isolation
- Potential port conflicts
- Less secure

### Bridge Network (used in this project)
- Isolated internal network
- Services communicate using container names
- Only required ports are exposed externally
- Better security and separation

A custom bridge network was used to isolate services and ensure controlled communication.

---

## Docker Volumes vs Bind Mounts

### Docker Volumes
- Managed by Docker
- Stored in Docker’s internal directory
- Portable and clean
- Less transparent

### Bind Mounts (used in this project)
- Maps host directory directly
- Data location is explicit
- Easier to inspect and backup
- Required by project subject

Bind mounts were used to persist:

- MariaDB database files
- WordPress files

This ensures data remains intact even if containers are rebuilt.

---

# Security Measures

- TLS 1.2/1.3 enforced
- No `latest` tags used
- No passwords stored in `.env`
- One process per container
- No background processes in entrypoints
- Automatic container restart policy

---
