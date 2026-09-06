FROM nginx:alpine

COPY egopixel /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
