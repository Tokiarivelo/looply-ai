# Variables
ENV_FILE = ../envs/.env
COMPOSE_FILE = docker-compose.yml
PROJECT_NAME = looply-ai

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

.PHONY: help up down restart logs status clean build ps n8n up-n8n

# Default target
help: ## Show this help message
	@echo "$(GREEN)Looply AI - Docker Management$(NC)"
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

up: ## Start all services in detached mode
	@echo "$(GREEN)Starting Looply AI services...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN)Services started successfully!$(NC)"

up-service: ## Start a specific service (usage: make up-service SERVICE=n8n)
	@if [ -z "$(SERVICE)" ]; then \
		echo "$(RED)Error: Please specify SERVICE=service_name$(NC)"; \
		echo "Available services: n8n, postgis, pgadmin, localstack"; \
		exit 1; \
	fi
	@echo "$(GREEN)Starting $(SERVICE) service...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) up -d $(SERVICE)
	@echo "$(GREEN)$(SERVICE) service started!$(NC)"

down: ## Stop all services
	@echo "$(YELLOW)Stopping Looply AI services...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down
	@echo "$(GREEN)Services stopped!$(NC)"

stop: ## Stop all services
	@echo "$(YELLOW)Stopping Looply AI services...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) stop
	@echo "$(GREEN)Services stopped!$(NC)"

down-service: ## Stop a specific service (usage: make down-service SERVICE=n8n)
	@if [ -z "$(SERVICE)" ]; then \
		echo "$(RED)Error: Please specify SERVICE=service_name$(NC)"; \
		echo "Available services: n8n, postgis, pgadmin, localstack"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Stopping $(SERVICE) service...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down $(SERVICE)
	@echo "$(GREEN)$(SERVICE) service stopped!$(NC)"

down-n8n: ## Stop n8n service only
	@echo "$(YELLOW)Stopping n8n service...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down n8n
	@echo "$(GREEN)n8n service stopped!$(NC)"

down-db: ## Stop database service only
	@echo "$(YELLOW)Stopping postgis service...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down postgis
	@echo "$(GREEN)postgis service stopped!$(NC)"

down-pgadmin: ## Stop pgadmin service only
	@echo "$(YELLOW)Stopping pgladmin service...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down pgladmin
	@echo "$(GREEN)pgladmin service stopped!$(NC)"

down-localstack: ## Stop localstack service only
	@echo "$(YELLOW)Stopping localstack service...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down localstack
	@echo "$(GREEN)localstack service stopped!$(NC)"

restart: ## Restart all services
	@echo "$(YELLOW)Restarting Looply AI services...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) restart
	@echo "$(GREEN)Services restarted!$(NC)"

restart-service: ## Restart a specific service (usage: make restart-service SERVICE=n8n)
	@if [ -z "$(SERVICE)" ]; then \
		echo "$(RED)Error: Please specify SERVICE=service_name$(NC)"; \
		echo "Available services: n8n, postgis, pgladmin, localstack"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Restarting $(SERVICE) service...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) restart $(SERVICE)
	@echo "$(GREEN)$(SERVICE) service restarted!$(NC)"

restart-n8n: ## Restart n8n service only
	@echo "$(YELLOW)Restarting n8n service...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) restart n8n
	@echo "$(GREEN)n8n service restarted!$(NC)"

restart-db: ## Restart database service only
	@echo "$(YELLOW)Restarting postgis service...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) restart postgis
	@echo "$(GREEN)postgis service restarted!$(NC)"

build: ## Build/rebuild all services
	@echo "$(GREEN)Building Looply AI services...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) build
	@echo "$(GREEN)Build completed!$(NC)"

logs: ## Show logs for all services
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) logs -f

logs-n8n: ## Show logs for n8n service only
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) logs -f n8n

logs-db: ## Show logs for database service only
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) logs -f postgis

logs-localstack: ## Show logs for localstack service only
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) logs -f localstack

logs-pgladmin: ## Show logs for pgladmin service only
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) logs -f pgladmin

ps: ## Show running containers
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) ps

status: ## Show status of all services
	@echo "$(GREEN)Looply AI Services Status:$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) ps

clean: ## Stop and remove all containers, networks, and volumes
	@echo "$(RED)Warning: This will remove all containers, networks, and volumes!$(NC)"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ]
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down -v --remove-orphans
	@echo "$(GREEN)Cleanup completed!$(NC)"

clean-images: ## Remove all related Docker images
	@echo "$(RED)Removing Docker images...$(NC)"
	docker images | grep -E "(n8nio|postgis|dpage|gresau)" | awk '{print $$3}' | xargs -r docker rmi -f

exec-n8n: ## Execute sh in n8n container
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) exec n8n sh

exec-db: ## Execute psql in database container
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) exec postgis psql -U lai_usr -d lai_db

health: ## Check health of all services
	@echo "$(GREEN)Health Status:$(NC)"
	@docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

dev: ## Start in development mode (with build)
	@echo "$(GREEN)Starting in development mode...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) up -d --build

prod: ## Start in production mode
	@echo "$(GREEN)Starting in production mode...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) -f docker-compose.prod.yml up -d

backup-db: ## Backup database
	@echo "$(GREEN)Creating database backup...$(NC)"
	mkdir -p ../backups
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) exec -T postgis pg_dump -U lai_usr lai_db > ../backups/backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)Backup created in ../backups/$(NC)"

restore-db: ## Restore database (usage: make restore-db BACKUP_FILE=backup_file.sql)
	@if [ -z "$(BACKUP_FILE)" ]; then \
		echo "$(RED)Error: Please specify BACKUP_FILE=your_backup.sql$(NC)"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Restoring database from $(BACKUP_FILE)...$(NC)"
	cat ../backups/$(BACKUP_FILE) | docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) exec -T postgis psql -U lai_usr lai_db
	@echo "$(GREEN)Database restored!$(NC)"

update: ## Pull latest images and restart
	@echo "$(GREEN)Updating services...$(NC)"
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) pull
	docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) up -d --force-recreate
	@echo "$(GREEN)Services updated!$(NC)"