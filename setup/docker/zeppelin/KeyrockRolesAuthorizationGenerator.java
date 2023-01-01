/*
 * MIT License
 *
 * Copyright (c) 2021-2023 Kazuhito Suda
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

package org.pac4j.oidc.authorization.generator;

import net.minidev.json.JSONObject;
import net.minidev.json.JSONArray;
import org.pac4j.core.authorization.generator.AuthorizationGenerator;
import org.pac4j.core.context.WebContext;
import org.pac4j.core.profile.UserProfile;
import org.pac4j.oidc.profile.keyrock.KeyrockOidcProfile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;

/**
 * Specific {@link AuthorizationGenerator} to Keyrock.
 *
 * @author Kazuhito Suda
 * @since 4.0.1
 */
public class KeyrockRolesAuthorizationGenerator implements AuthorizationGenerator {

    private static final Logger LOGGER = LoggerFactory.getLogger(KeyrockRolesAuthorizationGenerator.class);

    public KeyrockRolesAuthorizationGenerator() {}

    @Override
    public Optional<UserProfile> generate(final WebContext context, final UserProfile profile) {
        LOGGER.debug("KeyrockRolesAuthorizationGenerator");

        if (profile instanceof KeyrockOidcProfile) {
            try {
                LOGGER.debug("Keyrock profile: {}", profile);

                JSONArray rolesJsonArray = (JSONArray) profile.getAttribute("roles");
                
                LOGGER.debug("Keyrock roles: {}", rolesJsonArray);

                rolesJsonArray.forEach(item -> {
                    String role = (String) ((JSONObject) item).get("name");
                    LOGGER.info("Keyrock role: {}", role);
                    profile.addRole(role);
                });
            } catch (final Exception e) {
                LOGGER.warn("Cannot parse Keyrock roles", e);
            }
        }

        return Optional.of(profile);
    }
}
