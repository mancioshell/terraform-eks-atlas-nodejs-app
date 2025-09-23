import jwt from "jsonwebtoken";
import axios from "axios";
import jwkToPem from "jwk-to-pem";

const COGNITO_REGION = process.env.COGNITO_REGION || "us-east-1"; // Change to your region
const USER_POOL_ID = process.env.COGNITO_USER_POOL_ID || ""; // Change to your Cognito User Pool ID
const COGNITO_ISSUER = `https://cognito-idp.${COGNITO_REGION}.amazonaws.com/${USER_POOL_ID}`;

let cachedKeys: any;

async function getPublicKeys() {
  if (!cachedKeys) {
    const response = await axios.get(`${COGNITO_ISSUER}/.well-known/jwks.json`);
    cachedKeys = response.data.keys.reduce((agg: any, key: any) => {
      let id = key.kid;
      agg[id] = key;
      return agg;
    }, {});
  }
  return cachedKeys;
}

export async function verifyToken(token: string) {
  try {
    const keys = await getPublicKeys();
    const decodedHeader = jwt.decode(token, { complete: true });
    let kid = decodedHeader?.header.kid as string;

    if (!decodedHeader || !keys[kid]) {
      throw new Error("Invalid token");
    }

    const key = keys[kid];
    const publicKey = jwkToPem(key);

    return jwt.verify(token, publicKey, {
      issuer: COGNITO_ISSUER,
      algorithms: ["RS256"],
    });
  } catch (error) {
    console.error("Token verification failed:", error.message);
    throw new Error("Unauthorized");
  }
}
