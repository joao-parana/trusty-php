# trusty-php

Docker image to run PHP applications on Apache inside Ubuntu 14.04

## Installing your PHP application

To install your application, you need create another Dockerfile and
you can copy your code inside the image in `/app`, for example, using git.

Another aprouch: You can use this image and commit with the app inside.

    docker run -d --name trusty-php-app \
        parana/trusty-php \
        git clone https://github.com/whatever-repo/whatever-php-app.git /app

To create an image from that, execute:

    docker commit trusty-php-app parana/trusty-php

You can now push your changes to the registry, like this example:

    docker push parana/trusty-php

Please use your Docker Hub account.

## Running your PHP application

Pull your image, if it's not yet on your local docker machine:

	docker pull parana/trusty-php

Run the `/run.sh` script to start apache (via supervisor):

	docker run -d --name trusty-php-app -p 80:80 parana/trusty-php /run.sh

Test your deployment:

	curl http://dockerhost.local

I supose you have an entry on /etc/hosts for dockerhost.local point 
to boot2docker, docker-machine or localhost (Linux)
