yum -y install docker
docker pull httpd

docker run --name web1 -d httpd
docker run --name web2 -d httpd

docker exec  -it web1 /bin/bash -c 'echo "haproxy test docker1" > /usr/local/apache2/htdocs/index.html'
docker exec -it web2 /bin/bash -c 'echo "haproxy test docker2" > /usr/local/apache2/htdocs/index.html'

