all: 
	mkdir -p /home/ubuntu/app/data/mariadb
	mkdir -p /home/ubuntu/app/data/wordpress
	docker compose -f ./srcs/docker-compose.yml build
	docker compose -f ./srcs/docker-compose.yml up -d
	
stop:
	docker compose -f ./srcs/docker-compose.yml down

logs:
	docker logs wordpress
	docker logs mariadb
	docker logs nginx
	
rm:
	docker volume rm mariadb
	docker volume rm wordpress

clean:
	docker container stop nginx mariadb wordpress
	docker network rm inception
	@docker system prune -af

fclean: clean
	@sudo rm -rf /home/ubuntu/app/data/mariadb/*
	@sudo rm -rf /home/ubuntu/app/data/wordpress/*

re: fclean all

.Phony: all logs clean fclean
