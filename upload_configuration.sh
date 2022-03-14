#! /bin/bash

rsync -a -v -e ssh --exclude={.git,.gitignore,install.sh,upload_configuration.sh,configure.sh} ./ ant:/shared/public/home_config
