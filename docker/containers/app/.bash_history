php bin/magento cache:clean
php bin/magento cache:flush
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento indexer:reindex
php bin/magento setup:static-content:deploy
php bin/magento interactivated:shell Iv8
php bin/magento deploy:mode:set developer
php bin/magento module:enable --all
php bin/magento module:disable Interactivated_CustomSocialLogin
php bin/magento module:enable Interactivated_CustomSocialLogin
php bin/magento cron:run
composer install
composer update
sh ~/scripts/makeuser.sh
