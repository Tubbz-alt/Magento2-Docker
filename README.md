# Magento 2 And Docker

## Images

| Components  | 2.2 |
|:------------|-----|
| **PHP Version** | `7.1` |
| **PHP Modules** | `bcmath`, `Core`, `ctype`, `curl`, `date`, `dom`,<br>`fileinfo`, `filter`, `ftp`, `gd`, `hash`, `iconv`,<br>`intl`, `json`, `libxml`, `mbstring`, `mcrypt`,<br>`mysqli`, `mysqlnd`, `openssl`, `pcre`, `PDO`,<br> `pdo_mysql`, `pdo_sqlite`, `Phar`, `posix`,<br>`readline`, `Reflection`, `session`, `SimpleXML`,<br>`soap`, `SPL`, `sqlite3`, `standard`, `tokenizer`,<br>`xdebug`, `xml`, `xmlreader`, `xmlwriter`, `xsl`,<br>`zip`, `zlib` |
| **Zend Modules** | `-` |
| **Composer** | `1.6+` |
| **Fish** | `-` |
| **User** | `user` |

## How to use
- Replace the string `${YOUR_PROJECT_NAME}` throught the project with the required name.

  E.g.:
    - Atom:
        - `Ctrl + Shift + F`
        - _"Find in project"_ `->` `${YOUR_PROJECT_NAME}`
        - _"Replace in project"_ `->` `test`
    - Bash
      ```shell
      find . -type f -exec sed -i "s/${YOUR_PROJECT_NAME}/test/g" {} \;
      ```
- Add the content of this project to your project.

### 0. The first initialization of the project

- Create environment files for docker containers:

  ```shell
  cp docker/containers/app/.env.example docker/containers/app/.env
  cp docker/containers/db/.env.example docker/containers/db/.env
  ```

- Generate new password using the command and put it to env files (See above):

  ```shell
  sleep 1; find docker -type f -name ".env" -exec sed -i "s/YourStrongSecretPassword/$(date +%s | sha256sum | base64 | head -c 40)/g" {} \;
  sleep 1; find docker -type f -name ".env" -exec sed -i "s/YourStrongSecretRootPassword/$(date +%s | sha256sum | base64 | head -c 40)/g" {} \;
  ```

- Pull images for services defined in the Compose file:

  **Development:**

  ```shell
  docker-compose -f docker-compose-dev.yml pull
  ```

  **Production:**

  ```shell
  docker-compose pull
  ```

- Create db net:

  ```shell
  docker network create ${YOUR_PROJECT_NAME}-dbnet
  ```

- Create project environment file:

  ```shell
  cp docker/containers/app/env.php app/etc/
  ```

### 1. Launch of the project

**Development:**

```shell
docker-compose -f docker-compose-dev.yml up -d
```

**Production:**

```shell
docker-compose up -d
```

## MySQL Client

MySQL access provided in the file **docker/containers/db/.env**;

### PhpMyAdmin

- To install PhpMyAdmin execute the following command:

  ```shell
  docker-compose -f docker/phpmyadmin.yml up -d
  ```

- After that go to browser:

  ```
  http://0.0.0.0:8000
  ```

### MySQL Workbench

- Get the IP address of the DB container:

  ```shell
  docker inspect ${YOUR_PROJECT_NAME}-mysql | grep IPAddress
  ```

- Get access (login/password) from the file:

  ```shell
  cat docker/containers/db/.env | grep MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD
  ```
### MySQL CLI

- Connect to docker container:

  ```shell
  docker exec -u root -it ${YOUR_PROJECT_NAME}-mysql bash
  ```

- Connect to MySQL:

  ```shell
  mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE
  ```

- To import DB dump, execute the following:

  ```sql
  source /root/dumps/db-dump.sql;
  UPDATE core_config_data C SET C.value = 'http://${YOUR_PROJECT_NAME}-local.com/' WHERE C.path IN ('web/secure/base_url' , 'web/unsecure/base_url');
  ```

## Sonarqube

- To install Sonarqube execute the following command:

  ```shell
  docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
  ```

    Or use docker-compose:

  ```shell
  docker-compose -f docker/sonarqube.yml up -d
  ```

- Launch the sonarqube container:

  ```shell
  docker start sonarqube
  ```

- Get the IP address of the sonarqube container:

  ```shell
  docker inspect sonarqube | grep IPAddress
  ```

- Set the IP address to the file _sonar-project.properties_.

- Install [SonarQube Scanner](https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner).

    * Download the archive.
    * Unzip to _/opt/sonar-scanner_.
    * Add the command to global access:

      ```shell
      ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/
      ```

    * Add execute permissions:

    ```shell
    chmod +x /opt/sonar-scanner/bin/sonar-scanner
    ```

- Execute scanner in the project folder:

  ```shell
  sonar-scanner
  ```

- Open http://0.0.0.0:9000 link in a browser. Login: _admin_, password: _admin_.

## **How to**

- **To execute Magento 2 commands**, need to access to **app** container:

  ```shell
  docker exec -u user -it ${YOUR_PROJECT_NAME}-app bash
  ```

    Or:

  ```shell
  docker exec -u user -it ${YOUR_PROJECT_NAME}-app fish
  ```

## Authors

- Vadym Demchuk <vaddemgen@gmail.com>
