#!/bin/bash

echo 'Excluir maquinas ... fase 1'
sudo docker ps -a | awk '{ print $14 }' | xargs sudo docker rm $0

echo 'Excluir maquinas ... fase 2'
sudo docker ps -a | awk '{ print $15 }' | xargs sudo docker rm $0

echo 'Excluir maquinas ... fase 3'
sudo docker ps -a | awk '{ print $16 }' | xargs sudo docker rm $0

echo 'Monta os containers...'
sudo docker-compose up -d --build

echo 'Atualiza a maquina virtual'
#sudo docker-compose exec php-apache apt update
#sudo docker-compose exec php-apache apt -y upgrade

echo 'Habilita os sites...'
sudo docker-compose exec php-apache sh -c "a2ensite meu.site.com.br"

echo 'Permissoes em pastas...'

echo 'Meu projeto - temp'
#sudo docker-compose exec docker.php sh -c "chmod 777 /var/www/html/temp -R"

echo 'Meu Projeto - vendor'
sudo docker-compose exec docker.php sh -c "chmod 777 /var/www/html/meuprojeto/vendor -R"

echo 'Reinicia o apache2'
#sudo docker-compose exec docker.php service apache2 restart

#echo 'Reinicia o memcached'
#sudo docker-compose exec memcached service memcached restart

echo 'Modulos habilitados...'
sudo docker-compose exec docker.php php -m | grep -E 'memcache|oci8|uploadprogress'

#echo 'Aguardando o acesso...'
#sudo docker-compose exec php-apache tail -f /var/log/apache2/meu.site.com.br-error.log
#sudo docker-compose exec php-apache tail -f /var/log/apache2/meu.site.com.br-access.log

echo 'Acesso a maquina virtual'
sudo docker-compose exec docker.php bash

# Roda o composer
#sudo docker run --rm --interactive --tty --volume $PWD/php-apache/html/savv:/app composer install --ignore-platform-reqs --no-scripts
#sudo docker run --rm --interactive --tty --volume $PWD/php-apache/html/savv:/app composer update --ignore-platform-reqs --no-scripts

# Rancher
#sudo docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://localhost:8080/v1/scripts/34092ECD3BAF4C84885F:1546214400000:ThODyGBThYK8Y0ywH1nINHiQ

#Portainer
#sudo docker volume create portainer_data
#sudo docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
