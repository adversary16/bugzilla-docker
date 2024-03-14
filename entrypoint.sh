#!/bin/bash
set -e

TEMPORARY_CONFIG_FILE=$(mktemp)

write_config_entry(){
    __FIELD_NAME=$1
    __FIELD_VALUE=$2
    echo '$answer{'"'$__FIELD_NAME'"'} = '$__FIELD_VALUE';' >> $TEMPORARY_CONFIG_FILE
}

make_config(){
    write_config_entry 'ADMIN_EMAIL' "'admin@admin.local'"
    write_config_entry 'ADMIN_PASSWORD' "'admindefault'"
    write_config_entry 'ADMIN_REALNAME' "'Admin Admin'"
    write_config_entry 'db_driver' "'${DB_TYPE}'"
    write_config_entry 'db_pass' "'${DB_PASSWORD}'"
    write_config_entry 'db_name' "'${DB_BASE}'"
    write_config_entry 'db_host' "'${DB_HOST}'"
    write_config_entry 'db_port' "'${DB_PORT}'"
    write_config_entry 'webservergroup' "'www-data'"
    write_config_entry 'NO_PAUSE' 1
}


substitute(){
    sed -i 's/$db_driver.*/$db_driver = '"'"${DB_TYPE}"'"';/gmi' localconfig
    sed -i 's/$db_pass.*/$db_pass = '"'"${DB_PASSWORD}"'"';/gmi' localconfig
    sed -i 's/$db_user.*/$db_user = '"'"${DB_USER}"'"';/gmi' localconfig
    sed -i 's/$db_name.*/$db_name = '"'"${DB_BASE}"'"';/gmi' localconfig
    sed -i 's/$db_host.*/$db_host = '"'"${DB_HOST}"'"';/gmi' localconfig
    sed -i 's/$db_port.*/$db_port = '${DB_PORT}';/gmi' localconfig
    sed -i 's/$webservergroup.*/$webservergroup = 'www-data';/gmi' localconfig
}

prepare() {
        substitute
        make_config
        ./checksetup.pl $TEMPORARY_CONFIG_FILE
}

run() {
    prepare
    spawn-fcgi -s /var/run/fcgiwrap.sock -M 766 /usr/sbin/fcgiwrap
    nginx -g 'daemon off;'
}

run