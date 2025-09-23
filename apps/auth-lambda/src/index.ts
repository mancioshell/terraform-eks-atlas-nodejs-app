import { APIGatewayProxyResult, APIGatewayEvent } from "aws-lambda";
import { v4 as uuidv4 } from "uuid";
import { verifyToken } from "./verify";

const defaultHeaders = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
  "Access-Control-Allow-Credentials": "true",
};

export const handler = async (
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> => {
  try {
    const token = (event.headers.Authorization || "").replace("Bearer ", "");
    if (!token) {
      return {
        statusCode: 401,
        body: JSON.stringify({ message: "Missing token" }),
      };
    }

    await verifyToken(token);

    const data = {
      id: uuidv4(),
      message: "Hello from Lambda",
    };

    return {
      statusCode: 200,
      body: JSON.stringify(data),
      headers: {
        ...defaultHeaders,
      },
    };
  } catch (error) {
    return {
      statusCode: 401,
      body: JSON.stringify({ message: "Unauthorized" }),
    }; 
  }
};
