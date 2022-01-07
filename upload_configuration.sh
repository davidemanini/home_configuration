#! /bin/bash

rsync -a -v -e ssh home_config/ ant:/shared/public/home_config
