interface IConfig {
  baseURL: string;
  serverURL: string;
  cognitoRegion: string;
  userPoolId: string;
  cognitoClientId: string;
}

export const config: IConfig = {
  baseURL: process.env.BASE_URL || "",
  serverURL: process.env.SERVER_URL || "",
  cognitoRegion: process.env.COGNITO_REGION || "",
  userPoolId: process.env.USER_POOL_ID || "",
  cognitoClientId: process.env.COGNITO_CLIENT_ID || "",
};
