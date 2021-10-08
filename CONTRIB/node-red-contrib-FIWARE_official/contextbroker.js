/**
 *
 *   NGSI Context Broker config Node
 *
 *   Copyright (c) 2019 FIWARE Foundation e.V.
 *
 *   @author José M. Cantera
 *
 *   Porting of https://github.com/FIWARE/node-red-contrib-FIWARE_official
 *
 */

const http = require('../../../http.js');
const common = require('../../../common.js');

module.exports = function(RED) {
  function ContextBrokerNode(config) {
    RED.nodes.createNode(this, config);
    const node = this;

    node.endpoint = common.getParam('endpoint', config);
    node.service = common.getParam('service', config);
    node.servicepath = common.getParam('servicepath', config);

    node.idmEndpoint = common.getParam('idmEndpoint', config);
    node.username = common.getParam('username', node.credentials);
    node.password = common.getParam('password', node.credentials);

    node.client_id = common.getParam('client_id', node.credentials);
    node.client_secret = common.getParam('client_secret', node.credentials);

    node.securityEnabled = false;

    if (
      node.idmEndpoint &&
      node.username &&
      node.password
    ) {
      node.securityEnabled = true;
    }

    // Current token being used to issue API requests
    this.currentToken = null;
    // Expiration date for the token
    this.tokenExpires = null;

    this.getToken = async function() {
      const idm = this.idmEndpoint.replace(/\/$/, '');

      if (
        this.currentToken &&
        this.tokenExpires &&
        this.tokenExpires.getTime() > Date.now()
      ) {
        return this.currentToken;
      }

      this.currentToken = null;

      const headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
      };

      let idmApiEndpoint = "";
      let payload = "";

      const username = encodeURIComponent(this.username);
      const password = encodeURIComponent(this.password);

      if (
        node.client_id &&
        node.client_secret
      ) {
        idmApiEndpoint = `${idm}/oauth2/token`;
        payload = `username=${username}&password=${password}&grant_type=password`;
        const authBearer = Buffer.from(
          `${this.client_id}:${this.client_secret}`
        ).toString('base64');
  
        headers.Authorization = `Basic ${authBearer}`
      } else {
        idmApiEndpoint = `${idm}/token`;
        payload = `username=${username}&password=${password}`;
      }

      let response = null;
      try {
        response = await http.post(idmApiEndpoint, payload, headers);

        const statusCode = response.response.statusCode;

        if (statusCode === 200) {
          this.currentToken = response.body.access_token;

          this.tokenExpires = new Date(Date.now() + response.body.expires_in);
        } else {
          this.error(`Error while obtaining token. Status Code: ${statusCode}`);
        }
      } catch (e) {
        this.error(`Exception while obtaining token: ${e}`);
        this.currentToken = null;
      }

      return this.currentToken;
    };
  }

  RED.nodes.registerType('Context-Broker', ContextBrokerNode, {
    credentials: {
      username: { type: 'text' },
      password: { type: 'password' },
      client_id: { type: 'text' },
      client_secret: { type: 'password' }
    }
  });
};
