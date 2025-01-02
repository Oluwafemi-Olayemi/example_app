# Define variables
APP_CONTAINER=example_app
DB_CONTAINER=example_mysql
WEB_CONTAINER=example_webserver

# Start services
start:
	docker-compose up -d

# Stop services
stop:
	docker-compose down

# Build/rebuild services
build:
	docker-compose build

# Enter the PHP container
shell:
	docker exec -it $(APP_CONTAINER) bash

# Run migrations
migrate:
	docker exec -it $(APP_CONTAINER) php artisan migrate

# Seed database
seed:
	docker exec -it $(APP_CONTAINER) php artisan db:seed

# Run tests
test:docker
	docker exec -it $(APP_CONTAINER) php artisan test

# Clear caches
clear-cache:
	docker exec -it $(APP_CONTAINER) php artisan cache:clear

# Install dependencies
composer-install:
	docker exec -it $(APP_CONTAINER) composer install

# Bring up services and install Laravel dependencies
setup:
	make start
	make composer-install
	make migrate
	make seed

# Logs
logs:
	docker-compose logs -f

# Restart services
restart:
	make stop
	make start
