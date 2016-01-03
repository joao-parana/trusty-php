# trusty-php

Docker image to run PHP applications on Apache inside Ubuntu 14.04

## Build the image

    ./build-trusty-php

Showing Docker image details

    docker images parana/trusty-php

## Installing your PHP application

To install your application, you can create another Dockerfile and
you can copy your code inside the image in `/app`, for example, using git.

**Another approach** can be more convenient. 
You can use this image and commit it with the app inside. 
See how to do tht bellow:

    docker run -d --name trusty-php-app \
        parana/trusty-php \
        git clone https://github.com/joao-parana/test-phpapp.git /app

    docker  logs trusty-php-app

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

