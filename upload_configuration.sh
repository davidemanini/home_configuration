#! /bin/bash

rsync -a -v -e ssh --exclude={.git,.gitignore,install.sh,upload_configuration.sh,configure.sh,config_commit} ./ ant:/shared/public/home_config
