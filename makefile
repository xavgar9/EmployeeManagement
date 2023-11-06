run:
	@echo "Building and running containers with docker-compose..."
	@./init.sh

run-migrations:
	@echo "Running migration..."
	docker exec -i employeemanagement-mysql-1 mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS employeemanagement;"
	docker exec -i employeemanagement-mysql-1 mysql -uroot -proot employeemanagement < ./Backend/scripts/CreateDB.sql
	docker exec -i employeemanagement-mysql-1 mysql -uroot -proot employeemanagement < ./Backend/scripts/FunctionsProcedures.sql
	docker exec -i employeemanagement-mysql-1 mysql -uroot -proot employeemanagement < ./Backend/scripts/ResetDB.sql

.PHONY: build up