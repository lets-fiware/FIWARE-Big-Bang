/**
* MIT License
*
* Copyright (c) 2021 Kazuhito Suda
*
* This file is part of FIWARE Big Bang
*
* https://github.com/lets-fiware/FIWARE-Big-Bang
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
 **/

module.exports = {
    uiPort: process.env.NODE_RED_PORT || 1880,

    mqttReconnectTime: 15000,

    serialReconnectTime: 15000,

    debugMaxLength: 1000,

    adminAuth: {
        type:"strategy",
        strategy: {
            name: "fiware",
            label: "Sign in with Keyrock",
            strategy: require("passport-fiware-oauth").OAuth2Strategy,
            options: {
                serverURL: process.env.IDM_HOST,
                clientID: process.env.NODE_RED_CLIENT_ID,
                clientSecret: process.env.NODE_RED_CLIENT_SECRET,
                callbackURL: process.env.NODE_RED_CALLBACK_URL,
                isLegacy: false,
                verify: function(accessToken, refreshToken, profile, done) {
                  done(null, profile._json);
                },
                state: true
            }
        },
        users: function(username) {
            var userinfo = {username: username};
            if (this.authenticate != null && this.authenticate.arguments != null ) {
                L1: {
                    for (var role of this.authenticate.arguments[0].roles) {
                        switch (role.name) {
                            case "/node-red/full":
                                userinfo = {username: username, permissions: ["*"]};
                                break L1;
                            case "/node-red/read":
                                userinfo = {username: username, permissions: ["read"]};
                                break L1;
                        }
                    }
                    userinfo = null
                }
            }
            return Promise.resolve(userinfo);
        },
        tokens: function(token) {
            return new Promise(function(resolve, reject) {
                var request = require("request");
                var url = process.env.IDM_HOST.replace(/\/$/, "") + "/user";
                var query = { access_token: token, app_id: process.env.NODE_RED_CLIENT_ID };
                request.get({url: url, qs: query}, function (error, response, body) {
                    if (response.statusCode == 200) {
                        var userinfo = JSON.parse(body);
                        for (var role of userinfo.roles) {
                            if (role.name == "/node-red/api") {
                                resolve({ username: userinfo.username, permissions: "*" });
                            }
                        }
                    }
                    resolve(null);
                });
            });
        },
    },

    functionGlobalContext: {
    },

    functionExternalModules: false,

    exportGlobalContextKeys: false,

    logging: {
        console: {
            level: "info",
            metrics: false,
            audit: false
        }
    },

    externalModules: {
    },

    editorTheme: {
        projects: {
            enabled: false,
            workflow: {
                mode: "manual"
            }
        }
    }
}
