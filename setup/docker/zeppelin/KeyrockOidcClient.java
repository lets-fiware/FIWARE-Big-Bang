/*
 * MIT License
 *
 * Copyright (c) 2021-2024 Kazuhito Suda
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
 */

package org.pac4j.oidc.client;

import org.pac4j.core.util.CommonHelper;
import org.pac4j.oidc.authorization.generator.KeyrockRolesAuthorizationGenerator;
import org.pac4j.oidc.config.OidcConfiguration;
import org.pac4j.oidc.profile.OidcProfileDefinition;
import org.pac4j.oidc.profile.creator.OidcProfileCreator;
import org.pac4j.oidc.profile.keyrock.KeyrockOidcProfile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * <p>This class is the OpenID Connect client to authenticate users in Keyrock.</p>
 *
 * @author Kazuhito Suda
 * @since 4.0.1
 */
public class KeyrockOidcClient extends OidcClient<OidcConfiguration> {

    private static final Logger LOGGER = LoggerFactory.getLogger(KeyrockOidcClient.class);

    public KeyrockOidcClient() {
    }

    public KeyrockOidcClient(final OidcConfiguration configuration) {
        super(configuration);
    }

    @Override
    protected void clientInit() {
        CommonHelper.assertNotNull("configuration", getConfiguration());
        final OidcProfileCreator profileCreator = new OidcProfileCreator(getConfiguration(), this);
        profileCreator.setProfileDefinition(new OidcProfileDefinition<>(x -> new KeyrockOidcProfile()));
        defaultProfileCreator(profileCreator);

        addAuthorizationGenerator(new KeyrockRolesAuthorizationGenerator());
        LOGGER.info("KeyrockOidcClient: clientInit()");

        super.clientInit();
    }
}
