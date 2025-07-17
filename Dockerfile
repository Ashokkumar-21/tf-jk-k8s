FROM nginx:alpine
copy static-site/ /usr/share/nginx/html/
