UPDATE core_config_data C SET C.value = 'http://${YOUR_PROJECT_NAME}-local.com/' WHERE C.path IN ('web/secure/base_url' , 'web/unsecure/base_url');
