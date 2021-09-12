# Build environment
FROM node:14-alpine as frontend-build
WORKDIR /app
COPY . ./
RUN yarn
RUN yarn build

# Server environment
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/configfile.template

COPY --from=frontend-build /app/public /usr/share/nginx/html

ENV PORT 8080
ENV HOST 0.0.0.0
EXPOSE 8080
CMD sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
