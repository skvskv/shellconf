#!/bin/sh

EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet --install-dir=.
RESULT=$?
rm composer-setup.php
sudo install -D -T -o bin -g bin -m 0555 ./composer.phar /usr/local/bin/composer
sudo ln -s ./composer /usr/local/bin/cposer 
rm composer.phar
exit $RESULT

