#!/bin/sh

export CHOKIDAR_USEPOLLING=1

if [ ! "$(cat /etc/passwd | grep -i ${HUNAME})" ]; then
    adduser -D -u ${HUID} -s /bin/sh -g "" -h /home/${HUNAME} ${HUNAME}
    chown -R ${HUID}:${HGID} /usr/local/lib/node_modules
    chown -R ${HUID}:${HGID} /react-app
    chown -R ${HUID}:${HGID} /tmp/react-app
fi

if [ -z "$(ls .)" ]; then
    rsync --chown=${HUID}:${HGID} -a -v --ignore-existing /tmp/react-app/* . 
fi

if [ ! -d "./node_modules" ]; then
    su -c 'npm install' ${HUNAME}
    su -c 'npm cache clean --force' ${HUNAME}
fi

su -c 'npm start' ${HUNAME}

exit 0
