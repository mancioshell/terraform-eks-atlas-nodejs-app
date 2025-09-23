import "./App.css";

import React, { useEffect } from "react";
import { useAuth } from "react-oidc-context";
import { AuthUser } from "./AuthUser";

export function App() {
  const auth = useAuth();

  useEffect(() => {
    // Clear the query parameters if the user is authenticated
    if (auth.isAuthenticated) {
      const url = new URL(window.location.href);
      url.search = ""; // Clear the query parameters
      window.history.replaceState({}, document.title, url.toString());
    }
  }, [auth.isAuthenticated]);

  switch (auth.activeNavigator) {
    case "signinSilent":
      return <div>Signing you in...</div>;
    case "signoutRedirect":
      return <div>Signing you out...</div>;
  }

  if (auth.isLoading) {
    return <div>Loading...</div>;
  }

  if (auth.error) {
    return <div>Oops... {auth.error.message}</div>;
  }

  if (auth.isAuthenticated) {
    return (
      <div>
        Hello {auth.user?.profile.sub} <AuthUser />
        <button onClick={() => auth.removeUser()}>Log out</button>
      </div>
    );
  }

  return <button onClick={() => auth.signinRedirect()}>Log in</button>;
}
