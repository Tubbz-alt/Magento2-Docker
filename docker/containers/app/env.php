<?php

return [
    'backend' => [
        'frontName' => 'interactivated_admin',
    ],
    'crypt' => [
        'key' => '9018adbb219dfd54e84626fec5eddc3f',
    ],
    'session' => [
        'save' => 'files',
    ],
    'db' => [
        'table_prefix' => '',
        'connection'   => [
            'default' => [
                'host'           => getenv('DB_HOST'),
                'dbname'         => getenv('DB_DATABASE'),
                'username'       => getenv('DB_USERNAME'),
                'password'       => getenv('DB_PASSWORD'),
                'model'          => 'mysql4',
                'engine'         => 'innodb',
                'initStatements' => 'SET NAMES utf8;',
                'active'         => '1',
            ],
        ],
    ],
    'resource' => [
        'default_setup' => [
            'connection' => 'default',
        ],
    ],
    'x-frame-options' => 'SAMEORIGIN',
    'MAGE_MODE'       => 'developer',
    'cache_types'     => [
        'config'                 => 1,
        'layout'                 => 1,
        'block_html'             => 1,
        'collections'            => 1,
        'reflection'             => 1,
        'db_ddl'                 => 1,
        'eav'                    => 1,
        'customer_notification'  => 1,
        'full_page'              => 1,
        'config_integration'     => 1,
        'config_integration_api' => 1,
        'translate'              => 1,
        'config_webservice'      => 1,
        'compiled_config'        => 1,
    ],
    'install' => [
        'date' => 'Sat, 02 Sep 2017 06:59:32 +0000',
    ],
];
