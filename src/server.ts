import express from "express";
import { connectToDatabase } from "./services/database";
import { usersRouter } from "./routes/users";
import { healthRouter } from "./routes/health";
import dotenv from "dotenv";

dotenv.config();

const PORT = process.env.PORT;

async function startServer() {
  await connectToDatabase();

  const app = express();

  app.use("/users", usersRouter);
  app.use("/", healthRouter);

  app
    .listen(PORT, () => {
      console.log("Server running at PORT: ", PORT);
    })
    .on("error", (error) => {
      throw new Error(error.message);
    });
}

startServer().catch((error) => {
  console.error("Failed to start server:", error);
});
