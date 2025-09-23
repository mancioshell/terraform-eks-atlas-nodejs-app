import { createRoot } from "react-dom/client";
import { StrictMode } from "react";
import { BrowserRouter } from "react-router";
import { AuthProvider } from "react-oidc-context";

import { config } from "./config";
import { App } from "./App";

const cognitoAuthConfig = {
  authority:
    `https://cognito-idp.${config.cognitoRegion}.amazonaws.com/${config.userPoolId}` ||
    "",
  client_id: config.cognitoClientId,
  redirect_uri: config.baseURL,
  response_type: "code",
  scope: "email openid phone",
};

let container = document.getElementById("app")!;

let root = createRoot(container);

root.render(
  <StrictMode>
    <BrowserRouter>
      <AuthProvider {...cognitoAuthConfig}>
        <App />
      </AuthProvider>
    </BrowserRouter>
  </StrictMode>
);
