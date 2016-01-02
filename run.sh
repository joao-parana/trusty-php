#!/bin/bash

echo "••• `date` - Iniciando aplicação PHP sob o Apache no Ubuntu 14.04 •••"

exec supervisord -n
