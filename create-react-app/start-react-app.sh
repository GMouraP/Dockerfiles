#!/bin/sh

export CHOKIDAR_USEPOLLING=1

function getUser () {
    getent passwd "$1" | cut -d: -f1 ;
}

if [ $(id -u node) != ${HUID} ]; then
    adduser -D -u ${HUID} -s /bin/sh -g "" -h /home/developer developer
fi

# If the "/react-app" folder does not exist in the host computer before running the container,
# Docker will create one owned by root, so we change it to ${HUID} if that happens!
if [ $(stat -c "%u" /react-app) == 0 ]; then
    chown ${HUID}:${HGID} /react-app
fi

if [ -z "$(ls .)" ]; then
    rsync --chown=${HUID}:${HGID} -a -v --ignore-existing /tmp/react-app/* .
fi

if [ ! -d "./node_modules" ]; then
    su -c 'npm install' "$(getUser ${HUID})"
    su -c 'npm cache clean --force' "$(getUser ${HUID})"
fi

echo -n "Fixing broken ownerships... "
find /usr/local/lib/node_modules \! -user ${HUID} -exec chown ${HUID}:${HGID} {} \;
find /react-app \! -user ${HUID} -exec chown ${HUID}:${HGID} {} \;
find /tmp/react-app \! -user ${HUID} -exec chown ${HUID}:${HGID} {} \;
echo -e "Done."

su -c 'npm start' "$(getUser ${HUID})"

exit 0
