FROM nginx:latest


RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

ENV BACKEND=backend:8000
ENV SOCKETIO=websocket:9000
ENV UPSTREAM_REAL_IP_ADDRESS=127.0.0.1
ENV UPSTREAM_REAL_IP_HEADER=X-Forwarded-For
ENV UPSTREAM_REAL_IP_RECURSIVE=off
ENV FRAPPE_SITE_NAME_HEADER=frontend
ENV PROXY_READ_TIMEOUT=120
ENV CLIENT_MAX_BODY_SIZE=50m


COPY resources/nginx-template.conf /templates/nginx/frappe.conf.template
COPY resources/nginx-entrypoint.sh /usr/local/bin/nginx-entrypoint.sh

# RUN envsubst  '${BACKEND},${SOCKETIO},${UPSTREAM_REAL_IP_ADDRESS},${UPSTREAM_REAL_IP_HEADER},${UPSTREAM_REAL_IP_RECURSIVE},${FRAPPE_SITE_NAME_HEADER},${PROXY_READ_TIMEOUT},${CLIENT_MAX_BODY_SIZE}'\
#          < resources/nginx-template.conf > /resources/nginx-template.conf


# Expose port 80 for Nginx
EXPOSE ${WEBSERVER_PORT}

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]