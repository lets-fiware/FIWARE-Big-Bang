FROM nodered/node-red:2.2.2

#
# Add node modules for Node-RED
#   https://nodered.org/docs/getting-started/docker
#

RUN \
    npm i passport-fiware-oauth@0.3.0

COPY ./settings.js /usr/src/node-red/node_modules/node-red/settings.js
COPY ./contextbroker.js /usr/src/node-red/node_modules/node-red-contrib-fiware_official/src/nodes/NGSI/contextbroker/contextbroker.js
