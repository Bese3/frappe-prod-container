#!/bin/bash

ls -1 apps > sites/apps.txt;
runuser -u frappe -- bench set-config -g db_host ${DB_HOST};
runuser -u frappe -- bench set-config -gp db_port ${DB_PORT};
runuser -u frappe -- bench set-config -g redis_cache "redis://${REDIS_CACHE}";
runuser -u frappe -- bench set-config -g redis_queue "redis://${REDIS_QUEUE}";
runuser -u frappe -- bench set-config -g redis_socketio "redis://${REDIS_QUEUE}";
runuser -u frappe -- bench set-config -gp socketio_port ${SOCKETIO_PORT};
runuser -u frappe -- bench set-config -g developer_mode 1;   

cat /home/frappe/frappe-bench/sites/common_site_config.json;