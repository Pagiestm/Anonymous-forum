FROM nginx:alpine

# Install envsubst (gettext) for variable substitution at container start
RUN apk add --no-cache gettext

COPY . /usr/share/nginx/html/

# Remove any default.conf to avoid conflicts (force template usage)
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy the nginx template (will be substituted at runtime) and entrypoint
COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]