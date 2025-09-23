import express, { Request, Response } from "express";

export const healthRouter = express.Router();

healthRouter.use(express.json());

healthRouter.get("/", async (_req: Request, res: Response) => {
  res.status(200).send();
});
