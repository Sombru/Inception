NAME = inception

COMPOSE = docker compose
COMPOSE_FILE = srcs/docker-compose.yml

DATA_PATH = /home/pkostura/data
DB_PATH = $(DATA_PATH)/mariadb
WP_PATH = $(DATA_PATH)/wordpress

LAST_WARNINIG = @echo "You have 10 seconds to change your mind with CTRL+C" ; sleep 10

all: up

# Build and start all services in detached mode
up:
	@mkdir -p $(DB_PATH)
	@mkdir -p $(WP_PATH)
	$(COMPOSE) -f $(COMPOSE_FILE) up --build -d

# Stop and remove containers defined in docker-compose
down:
	@echo "[WARNING] Stopping and removing project containers..."
	$(LAST_WARNINIG)
	@sudo $(COMPOSE) -f $(COMPOSE_FILE) down

# Stop ALL running containers on the system
stop:
	@echo "[WARNING] Stopping ALL containers on the system..."
	$(LAST_WARNINIG)
	@sudo docker stop $$(docker ps -qa) 2>/dev/null || true

# Remove ALL containers on the system
remove:
	@echo "[WARNING] Removing ALL containers on the system..."
	$(LAST_WARNINIG)
	@sudo docker rm $$(docker ps -qa) 2>/dev/null || true

# Force remove ALL Docker images on the system
iremove:
	@echo "[WARNING] Removing ALL Docker images on the system..."
	$(LAST_WARNINIG)
	@sudo docker rmi -f $$(docker images -qa) 2>/dev/null || true

# Remove ALL Docker volumes on the system
vremove:
	@echo "[WARNING] Removing ALL Docker volumes on the system..."
	$(LAST_WARNINIG)
	@sudo docker volume rm $$(docker volume ls -q) 2>/dev/null || true

# Remove ALL Docker networks except default ones
nremove:
	@echo "[WARNING] Removing ALL Docker networks (except default)..."
	$(LAST_WARNINIG)
	@sudo docker network rm $$(docker network ls -q | grep -v "bridge\|host\|none") 2>/dev/null || true

# Stop containers and remove volumes defined in docker-compose
clean:
	@echo "[WARNING] Removing project containers and volumes..."
	$(LAST_WARNINIG)
	@sudo $(COMPOSE) -f $(COMPOSE_FILE) down -v

# Full cleanup: containers + volumes + images + data directory
fclean: stop clean
	@echo "[WARNING] This will PERMANENTLY delete:"
	@echo " - All containers"
	@echo " - All images"
	@echo " - All volumes"
	@echo " - $(DATA_PATH)"
	@sudo docker system prune -af --volumes
	@sudo rm -rf $(DATA_PATH)

# Rebuild project
re: clean all

# Full rebuild from scratch
fre: fclean all

.PHONY: all up down stop remove iremove vremove nremove clean fclean re fre
