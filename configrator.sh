#!/bin/bash

chown frappe:frappe /home/frappe/frappe-bench/*;

if [ ! -f /home/frappe/frappe-bench/sites/common_site_config.json ]; then
    touch /home/frappe/frappe-bench/sites/common_site_config.json && chmod 664 /home/frappe/frappe-bench/sites/common_site_config.json;
    echo "{}" > /home/frappe/frappe-bench/sites/common_site_config.json
fi;
ls -1 apps > sites/apps.txt;
bench set-config -g db_host $$DB_HOST;
bench set-config -gp db_port $$DB_PORT;
bench set-config -g redis_cache "redis://$$REDIS_CACHE";
bench set-config -g redis_queue "redis://$$REDIS_QUEUE";
bench set-config -g redis_socketio "redis://$$REDIS_QUEUE";
bench set-config -gp socketio_port $$SOCKETIO_PORT;
bench set-config -g developer_mode 1;
bench set-config -g gunicorn_workers 9;
bench set-config -g webserver_port ${WEBSERVER_PORT};
bench set-config -g rebase_on_pull false;
bench new-site --mariadb-user-host-login-scope='%' --admin-password=${ADMIN_PASSWORD} --db-root-username=${MYSQL_ROOT_USER} --db-root-password=${MYSQL_ROOT_PASSWORD} --set-default ${FRAPPE_SITE} --force;
bench use ${FRAPPE_SITE};       

cat /home/frappe/frappe-bench/sites/common_site_config.json;