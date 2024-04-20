import express from "express";
import { Weed } from "../utils/types";
import WeedModel from "../models/weed.model";

const WeedRouter: express.Router = express.Router();

WeedRouter.get("/", async (req: express.Request, res: express.Response) => {
  try {
    const weeds: Weed[] = await WeedModel.find().exec();
    res.status(200).json(weeds);
  } catch (err) {
    console.error("Error uploading file:", (err as Error).message);
    res.status(401).send({ error: (err as Error).message });
  }
});

export default WeedRouter;
