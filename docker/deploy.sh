#!/bin/bash
set -e
project_name='${YOUR_PROJECT_NAME}';

# Checking for the necessary tools.
if ! [ -x "$(command -v docker)" ] || ! [ -x "$(command -v docker-compose)" ] ; then
    echo 'Error: docker or docker-compose is not installed.' >&2;
    exit 1;
fi

# Creating the environment file for the Magento 2.
if ! [ -f app/etc/env.php ]; then
    cp docker/containers/app/env.php app/etc;
fi

# Creating the environment files for the docker containers.
if ! [ -f docker/containers/app/.env ] || ! [ -f docker/containers/db/.env ]; then
    # Creating the environment file for the APP container.
    cp docker/containers/app/.env.example docker/containers/app/.env;
    mysql_password=`date +%s | sha256sum | base64 | head -c 40; echo`;
    sed -i "s/YourStrongSecretPassword/$mysql_password/g" docker/containers/app/.env;

    # Creating the environment file for the DB container.
    cp docker/containers/db/.env.example docker/containers/db/.env;
    sed -i 's/original/new/g' docker/containers/db/.env;
    sleep 1; # Fixing password generation issue.
    mysql_root_password=`date +%s | sha256sum | base64 | head -c 40; echo`;
    sed -i "s/YourStrongSecretPassword/$mysql_password/g" docker/containers/db/.env;
    sed -i "s/YourStrongSecretRootPassword/$mysql_root_password/g" docker/containers/db/.env;
fi

# Pulling and building the project at first time.
if [[ -z $(docker ps -a | grep $project_name) ]]; then
    # Pulling docker images.
    docker-compose pull;
    # Building docker containers.
    docker-compose build;

    if [[ -z $(docker network ls | grep $project_name-dbnet) ]]; then
        # Creation project network.
        docker network create $project_name-dbnet
    fi
fi

# Launching containers.
if [[ -z $(docker ps | grep $project_name) ]]; then
    docker-compose up -d;
fi

docker exec -u user $project_name-app sh -c 'rm -r pub/static/*; rm -r var/*; rm -r generated/; rm -r vendor/'
docker exec -u user $project_name-app sh -c 'composer install'
docker exec -u root $project_name-mysql sh -c 'mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /root/dumps/db-dump.sql'
docker exec -u root $project_name-mysql sh -c "mysql -uroot -p\$MYSQL_ROOT_PASSWORD \$MYSQL_DATABASE -e \"UPDATE core_config_data C SET C.value = 'http://${YOUR_PROJECT_NAME}-local.com/' WHERE C.path IN ('web/secure/base_url' , 'web/unsecure/base_url');\""
docker exec -u root $project_name-mysql sh -c "mysql -uroot -p\$MYSQL_ROOT_PASSWORD \$MYSQL_DATABASE -e \"UPDATE core_config_data C SET C.value = 31536000 WHERE path IN ('admin/security/session_lifetime', 'customer/online_customers/section_data_lifetime');\""
docker exec -u user $project_name-app sh -c 'php bin/magento setup:upgrade'
docker exec -u user $project_name-app sh -c 'php bin/magento deploy:mode:set developer'
docker exec -u user $project_name-app sh -c 'php bin/magento cache:disable'
docker exec -u user $project_name-app sh -c 'php bin/magento indexer:reindex'
curl http://${YOUR_PROJECT_NAME}-local.com > /dev/null;
