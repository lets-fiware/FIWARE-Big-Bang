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

package jp.letsfiware.pac4j;

import org.pac4j.core.context.WebContext;
import org.pac4j.core.context.session.SessionStore;
import org.pac4j.core.engine.DefaultCallbackLogic;
import org.pac4j.core.exception.http.HttpAction;
import org.pac4j.core.exception.http.RedirectionActionHelper;
import org.pac4j.core.util.Pac4jConstants;
import org.pac4j.core.exception.http.FoundAction;
import org.pac4j.core.util.CommonHelper;

import static org.pac4j.core.util.CommonHelper.*;

public class CustomCallbackLogic<R, C extends WebContext> extends DefaultCallbackLogic<R, C> {

    @Override
    public HttpAction redirectToOriginallyRequestedUrl(final C context, final String defaultUrl) {
        if (CommonHelper.isNotBlank(defaultUrl)) {
            return RedirectionActionHelper.buildRedirectUrlAction(context, (new FoundAction(defaultUrl)).getLocation());
        } else {
            return super.redirectToOriginallyRequestedUrl(context, "");
        }
    }
}
