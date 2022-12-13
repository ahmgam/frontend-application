FROM node:gallium AS frontend

COPY . /app

WORKDIR /app

ARG SENTRY_DSN
ARG APP_VERSION
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV
ENV APP_VERSION $APP_VERSION
ENV SENTRY_DSN $SENTRY_DSN
ENV IMAGE_VERSION=4.0.2

RUN yarn && \
    yarn version $APP_VERSION && \
    yarn compile && \
    yarn build

FROM bitnami/nginx:latest AS nginx

COPY --from=frontend /app/output /app
COPY cattr_server.conf /opt/bitnami/nginx/conf/server_blocks/

WORKDIR /app

VOLUME /ssl
