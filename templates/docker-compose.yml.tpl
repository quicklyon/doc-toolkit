version: '2'

services:
  mysql:
    image: mysql:5.7
    container_name: mysql
    ports:
      - '3307:3306'
    volumes:
      - 'db:/var/lib/mysql'
    environment:
      - MYSQL_ROOT_PASSWORD=pass4Quick0n
      - MYSQL_DATABASE={{app_name}}
    networks:
      - net

  {{app_name}}:
    image: hub.qucheng.com/app/{{app_name}}:${TAG:-latest}
    container_name: {{app_name}}
    ports:
      - '8080:80'
    volumes:
      - 'data:/data'
    depends_on:
      - mysql
    environment:
      - MYSQL_HOST=mysql
      - MYSQL_PORT=3306
      - MYSQL_USER=root
      - MYSQL_PASSWORD=pass4Quick0n
      - MYSQL_DB={{app_name}}
      - DEBUG=1
      - IS_CONTAINER=true
    networks:
      - net

networks:
  net:
    driver: bridge

# persistence
volumes:
  db:
    driver: local
  data:
    driver: local
