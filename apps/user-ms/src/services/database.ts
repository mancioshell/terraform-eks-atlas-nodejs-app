import * as mongoDB from "mongodb";
import User from "../models/user";

export const collections: { users?: mongoDB.Collection<User> } = {};

export async function connectToDatabase() {

  // Create a new MongoDB client with the connection string from .env
  const client = new mongoDB.MongoClient(process.env.MONGODB_URI as string, {
    auth: {
      username: process.env.MONGODB_USERNAME,
      password: process.env.MONGODB_PASSWORD,
    },
  });

  // Connect to the cluster
  await client.connect();

  // Connect to the database with the name specified in .env
  const db = client.db(process.env.DATABASE_NAME);

  // Connect to the collection with the specific name from .env, found in the database previously specified
  const usersCollection = db.collection<User>(
    process.env.COLLECTION_NAME as string
  );

  // Persist the connection to the Games collection
  collections.users = usersCollection;

  console.log(
    `Successfully connected to database: ${db.databaseName} and collection: ${usersCollection.collectionName}`
  );
}
