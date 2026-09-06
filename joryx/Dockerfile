FROM nginx:alpine

# curl lo usa el health check que Coolify ejecuta dentro del contenedor.
RUN apk add --no-cache curl

COPY . /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -fsS http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
