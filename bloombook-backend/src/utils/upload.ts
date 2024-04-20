import fs from "fs";
import path from "path";
import multer, { FileFilterCallback } from "multer";
import { Callback } from "mongoose";

const filter = (
  req: Express.Request,
  file: Express.Multer.File,
  cb: FileFilterCallback
) => {
  if (file.mimetype.startsWith("image/")) {
    cb(null, true);
  } else {
    cb(new Error("Non-image type file upload attempted."));
  }
};

const storage: multer.StorageEngine = multer.diskStorage({
  destination: function (
    req: Express.Request,
    file: Express.Multer.File,
    cb: Callback
  ) {
    fs.mkdirSync("uploads", { recursive: true });
    cb(null, "uploads");
  },
  filename: async function (
    req: Express.Request,
    file: Express.Multer.File,
    cb: Callback
  ) {
    cb(
      null,
      `${String(new Date().toISOString())}-${
        path.parse(file.originalname).name
      }${path.extname(file.originalname)}`
    );
  },
});

export const upload: multer.Multer = multer({
  storage: storage,
  fileFilter: filter,
});
