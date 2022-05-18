FROM node:gallium AS frontend

COPY . /app

WORKDIR /app

RUN yarn && \
    yarn compile && \
    yarn build

ARG APP_VERSION
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV
ENV APP_VERSION $APP_VERSION
ENV IMAGE_VERSION=4.0.1

FROM bitnami/nginx:latest AS nginx

COPY --from=frontend /app/output /app
COPY cattr_server.conf /opt/bitnami/nginx/conf/server_blocks/

WORKDIR /app

VOLUME /ssl
