build:
	sudo /usr/local/bin/docker-compose build
up:
	sudo /usr/local/bin/docker-compose up -d
down:
	sudo /usr/local/bin/docker-compose down
ps:
	sudo /usr/local/bin/docker-compose ps
clean:
	./setup/clean.sh
nginx-test:
	sudo /usr/local/bin/docker-compose exec nginx nginx -t
nginx-reload:
	sudo /usr/local/bin/docker-compose exec nginx nginx -s reload

