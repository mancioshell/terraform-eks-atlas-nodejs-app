import { PolicyDocument, APIGatewayTokenAuthorizerEvent } from "aws-lambda";
import { verifyToken } from "./verify";

interface AuthResponse {
  principalId: string;
  policyDocument: PolicyDocument;
  context: {
    message: string;
  };
}

const generatePolicy = async (
  effect: string,
  resource: string,
  message: string
) => {
  return {
    principalId: "user",
    policyDocument: {
      Version: "2012-10-17",
      Statement: [
        {
          Action: "execute-api:Invoke",
          Effect: effect,
          Resource: resource,
        },
      ],
    },
    context: { message },
  };
};

export const handler = async (
  event: APIGatewayTokenAuthorizerEvent
): Promise<AuthResponse> => {
  try {
    console.log("Event: ", event);
    const token = (event.authorizationToken || "").replace("Bearer ", "");
    if (!token) {
      const policy = await generatePolicy(
        "Deny",
        event.methodArn,
        "Missing token"
      );
      return policy as AuthResponse;
    }

    await verifyToken(token);

    const policy = await generatePolicy("Allow", event.methodArn, "Authorized");
    return policy as AuthResponse;
  } catch (error) {
    const policy = await generatePolicy(
      "Deny",
      event.methodArn,
      (error as Error).message || "Unauthorized"
    );
    return policy as AuthResponse;
  }
};
