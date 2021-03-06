/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

package edu.indiana.d2i.htrc.oauth2.filter;


import org.wso2.carbon.identity.oauth2.dto.xsd.OAuth2TokenValidationRequestDTO;

import javax.servlet.*;
import java.io.IOException;

public class OAuth2Filter implements Filter {

    public void init(FilterConfig filterConfig) throws ServletException {

    }

    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        String accessToken = servletRequest.getParameter("accessToken");
        OAuth2ServiceClient client = new OAuth2ServiceClient();

        if(accessToken == null || accessToken.trim().length() == 0){
            // Throw error
            throw new RuntimeException("Access token not found");
        }

        OAuth2TokenValidationRequestDTO  oauthReq = new OAuth2TokenValidationRequestDTO();
        oauthReq.setAccessToken(accessToken);
        oauthReq.setTokenType("bearer");

        try{
            if(!client.validateAuthenticationRequest(oauthReq)){
              // throw error
            }
        } catch (Exception e) {
            // throw error
        }

        filterChain.doFilter(servletRequest, servletResponse);
    }

    public void destroy() {

    }
}
