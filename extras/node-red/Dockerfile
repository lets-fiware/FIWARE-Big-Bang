FROM nodered/node-red:2.2.0

#
# Add node modules for Node-RED
#   https://nodered.org/docs/getting-started/docker
#

# hadolint ignore=SC1083
RUN \
    npm i git+https://github.com/FIWARE/node-red-contrib-FIWARE_official.git#master && \
    curl https://raw.githubusercontent.com/lets-fiware/FIWARE-Big-Bang/v0.10.0/CONTRIB/node-red-contrib-FIWARE_official/{contextbroker.js} --output "/usr/src/node-red/node_modules/node-red-contrib-fiware_official/src/nodes/NGSI/contextbroker/#1"
