<%@ page import="edu.indiana.d2i.htrc.oauth2.Constants" %>
<%@ page import="org.apache.amber.oauth2.client.response.OAuthAuthzResponse" %>
<%@ page import="org.apache.amber.oauth2.client.request.OAuthClientRequest" %>
<%@ page import="org.apache.amber.oauth2.common.message.types.GrantType" %>
<%@ page import="org.apache.amber.oauth2.client.OAuthClient" %>
<%@ page import="org.apache.amber.oauth2.client.URLConnectionClient" %>
<%@ page import="org.apache.amber.oauth2.client.response.OAuthClientResponse" %>
<%
    String code = (String) session.getAttribute(Constants.CODE);
    OAuthAuthzResponse authzResponse = null;
    String callback = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/oauth2-client-webapp";

    if (code == null) {
        authzResponse = OAuthAuthzResponse.oauthCodeAuthzResponse(request);
        code = authzResponse.getCode();
        if (code != null) {
            session.setAttribute(Constants.CODE, code);
        }
    }
%>
<html>
<body>
<%
    if (session.isNew() || session.getAttribute(Constants.CODE) == null) {
        OAuthClientRequest authzRequest = OAuthClientRequest
                .authorizationLocation(Constants.AUTHZ_ENDPOINT)
                .setClientId(Constants.CLIENT_ID)
                .setRedirectURI(callback)
                .setResponseType(Constants.OAUTH2_GRANT_TYPE_CODE)
                .buildQueryMessage();
%>
<a href="<%=authzRequest.getLocationUri()%>">Log In</a>
<%
} else {
    if (session.getAttribute(Constants.ACCESS_TOKEN) == null) {
        OAuthClientRequest accessRequest = OAuthClientRequest.tokenLocation(Constants.TOKEN_ENDPOINT)
                .setGrantType(GrantType.AUTHORIZATION_CODE)
                .setClientId(Constants.CLIENT_ID)
                .setClientSecret(Constants.CLIENT_SECRET)
                .setCode(code)
                .buildBodyMessage();

        //create OAuth client that uses custom http client under the hood
        OAuthClient oAuthClient = new OAuthClient(new URLConnectionClient());

        OAuthClientResponse oAuthResponse = oAuthClient.accessToken(accessRequest);
        String accessToken = oAuthResponse.getParam(Constants.ACCESS_TOKEN);
        session.setAttribute(Constants.ACCESS_TOKEN, accessToken);
    }
%>
<div>
    <h1>Collections</h1>
    <!-- Getting collections from resource service goes here. -->
</div>
<%
    }
%>
</body>
</html>
