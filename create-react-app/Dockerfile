FROM node:14.5-alpine

# Maintainer
LABEL maintainer="gusdev77@gmail.com"

# Labels
LABEL org.label-schema.name "gusdev/create-react-app"
LABEL org.label-schema.schema-version "3.4.1"
LABEL org.label-schema.docker.cmd "docker container run -d -p 3000:3000 -v $(pwd)/react-app:/react-app -e HUID="$(id -u)" -e HGID="$(id -g)" -e HUNAME="$(id -nu)" gusdev/create-react-app"

RUN apk add rsync git --no-cache && \
    mkdir /react-app /tmp/react-app

ENV HUID 1000

ENV HGID 1000

ENV HUNAME node

RUN npx create-react-app /tmp/react-app && \
    npm cache clean --force && \
    rm -rf /tmp/react-app/node_modules /tmp/react-app/package-lock.json

COPY start-react-app.sh /usr/local/bin/

WORKDIR /react-app

EXPOSE 3000

CMD [ "start-react-app.sh" ]
