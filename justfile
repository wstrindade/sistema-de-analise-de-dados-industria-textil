default:
    @just --list

configurar-pyenv:
    python3 -m venv venv
    ./venv/bin/pip install -r requirements.txt

iniciar-docker-mysql:
    docker run -d \
        --name mysql-textil \
        -e MYSQL_ROOT_PASSWORD=root123 \
        -e MYSQL_DATABASE=textil_industria \
        -p 3306:3306 \
        mysql:8.0 \
        --character-set-server=utf8mb4 \
        --collation-server=utf8mb4_unicode_ci
    sleep 30

configurar-mysql:
    docker exec -i mysql-textil mysql -u root -proot123 textil_industria < textil_dump.sql

iniciar-aplicacao:
    ./pyenv 
