#!/bin/bash

APP_SRC=$1

# e-mail do user admin do Wordpress
if [ -z "$APP_SRC" ]; then
  echo "••• `date` - APP_SRC : $APP_SRC "
else
  echo "••• `date` - APP_SRC : $APP_SRC "
  echo "••• `date` - Current Directory: `pwd` "
  GITHUB_URL="https://github.com/$APP_SRC.git"
  echo "••• `date` - GITHUB_URL : $GITHUB_URL"
  echo "••• `date` - Local Destination path : `pwd`/$2"
  git clone $GITHUB_URL $2
fi

echo "••• `date` - Iniciando aplicação PHP sob o Apache no Ubuntu 14.04 •••"

exec supervisord -n
