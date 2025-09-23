interface IConfig {
  baseURL: string;
  serverURL: string;
  cognitoRegion: string;
  userPoolId: string;
  cognitoClientId: string;
}

export const config: IConfig = {
  baseURL: process.env.REACT_APP_BASE_URL || "",
  serverURL: process.env.REACT_APP_SERVER_URL || "",
  cognitoRegion: process.env.REACT_APP_COGNITO_REGION || "",
  userPoolId: process.env.REACT_APP_USER_POOL_ID || "",
  cognitoClientId: process.env.REACT_APP_COGNITO_CLIENT_ID || "",
};
