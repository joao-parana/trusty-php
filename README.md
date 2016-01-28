# trusty-php

**Docker image to run PHP applications with Apache Web Server on a Ubuntu 14.04 box**

## Dependencies Diagram

![Dependencies Diagram](https://raw.githubusercontent.com/joao-parana/trusty-php/master/docs/diagram-02-2x.png)

## Build the image

    cd ~/Desktop/Dev
    git clone git@github.com:joao-parana/trusty-php.git 
    ./build-trusty-php

Showing Docker image details

    docker images parana/trusty-php
    docker history  parana/trusty-php

You can see something like this:

    IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
    4afafc2a1b69        3 minutes ago       /bin/sh -c #(nop) CMD ["/run.sh"]               0 B                 
    d76ceda5eb04        3 minutes ago       /bin/sh -c #(nop) WORKDIR /app                  0 B                 
    11ff8e42b114        3 minutes ago       /bin/sh -c #(nop) EXPOSE 80/tcp                 0 B                 
    f31419122bd5        3 minutes ago       /bin/sh -c mkdir -p /app && rm -fr /var/www/h   4 B                 
    43a88285ac9d        3 minutes ago       /bin/sh -c #(nop) ADD file:1cdca4074d5c89d1fa   79 B                
    0a55b160a7e1        3 minutes ago       /bin/sh -c chmod 755 /*.sh                      194 B               
    42e7a6bd9e46        3 minutes ago       /bin/sh -c #(nop) ADD file:c029b0fc110388bdc5   125 B               
    f0f13cb42fd8        3 minutes ago       /bin/sh -c #(nop) ADD file:5bf808f83a6ffeb51b   69 B                
    1e25263e63ef        3 minutes ago       /bin/sh -c a2enmod rewrite                      30 B                
    e1ded839fa80        3 minutes ago       /bin/sh -c #(nop) ADD file:2adea1c29131373858   403 B               
    c19ea99d9b0a        3 minutes ago       /bin/sh -c apt-get update &&  DEBIAN_FRONTEND   133.9 MB            
    ab74e0d9dae7        3 days ago          /bin/sh -c #(nop) MAINTAINER João Antonio Fe    0 B                 
    6cc0fc2a5ee3        8 days ago          /bin/sh -c #(nop) CMD ["/bin/bash"]             0 B                 
    f80999a1f330        8 days ago          /bin/sh -c sed -i 's/^#\s*\(deb.*universe\)$/   1.895 kB            
    2ef91804894a        8 days ago          /bin/sh -c echo '#!/bin/sh' > /usr/sbin/polic   194.5 kB            
    92ec6d044cb3        8 days ago          /bin/sh -c #(nop) ADD file:7ce20ce3daa6af21db   187.7 MB 

You can see the original Dockerfile for Ubuntu Trusty is something like this:

    FROM scratch
    ADD ubuntu-trusty-core-cloudimg-amd64-root.tar.gz ...
    RUN echo '#!/bin/sh' > /usr/sbin/policy-rc.d ...
    RUN sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
    CMD ["/bin/bash"]

This appear at the bottom of docker history output (latest 4 lines).

Now I can delete the Ubuntu Image and Dangling images

    docker rmi ubuntu:14.04
    echo "Removing dangling images ..."
    docker rmi $(docker images -f dangling=true -q)


## Installing your PHP application

To install your application, you can create another Dockerfile and
you can copy your code inside the image in `/app`, for example, using git.

**Another approach** can be more convenient. 
You can use this image and commit it with the app inside. 
See how to do tht bellow:

    docker run -d --name trusty-php-app parana/trusty-php bash

    # Inside the Container you can run this commands bellow
    git clone https://github.com/joao-parana/test-phpapp.git /app
    supervisord -n
    # to verify use another Terminal Window / Tab
    docker logs trusty-php-app

To create an image from that, execute:

    docker commit -p -m "Adding test-phpapp" \
           -a "João Antonio Ferreira <joao.parana@gmail.com>" \
           trusty-php-app parana/trusty-php:v1

You can view both images, with and without `test-phpapp`

    docker images parana/trusty-php

And verify its layers 

    docker history parana/trusty-php:v1 | head

You have commited the image with app inside, so you can remove the temporary container

    docker rm trusty-php-app

And you can inspect the new image, running `ls -lat /app` inside it using a bash shell

    docker run -i -t --rm --name trusty-php-app \
               -p 80:80 parana/trusty-php:v1 ls -lat /app 

And you can play around using a bash shell too.

    docker run -i -t --rm --name trusty-php-app \
               -p 80:80 parana/trusty-php:v1 bash    

You can now push your changes to the registry, like in this example:

    docker push parana/trusty-php:v1

Please use your Docker Hub account instead.

## Running your PHP application

Pull your image, if it's not yet on your local docker machine:

	docker pull parana/trusty-php:v1

You can run the Test Application, exit and remove the container, to see 
if the image is OK.

    docker run -i -t --name trusty-php-app --rm \
               --link some-mysql-server:mysql \
               -e DB_USER="root" \
               -e DB_PASSWORD="xpto" \
               -e DB_NAME="test" \
               parana/trusty-php:v1 \
               php /app/testecli.php

Oh, you need to start `some-mysql-server` if it's not yet started.

Run the `/run.sh` script to start apache (via supervisor) on 
Container in Daemon mode:

    docker run -d --name trusty-php-app -p 80:80 parana/trusty-php:v1 /run.sh

To test your deployment you can execute:

  	curl http://dockerhost.local

I supose you have an entry on /etc/hosts for dockerhost.local point 
to boot2docker, docker-machine or localhost (Linux)

To view phpinfo you can execute:

    open http://dockerhost.local/phpinfo.php

