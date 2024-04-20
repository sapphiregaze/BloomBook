import express from "express";

import { upload } from "../utils/upload";

const UploadRouter: express.Router = express.Router();

UploadRouter.post(
  "/",
  upload.single("photo"),
  async (req: express.Request, res: express.Response) => {
    try {
      res.status(200).json({ message: "Image uploaded successfully" });
    } catch (err) {
      console.error("Error uploading file:", (err as Error).message);
      res.status(401).send({ error: (err as Error).message });
    }
  }
);

export default UploadRouter;
