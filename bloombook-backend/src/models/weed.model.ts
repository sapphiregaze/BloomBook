import mongoose, { Schema } from "mongoose";

import { Weed } from "../utils/types";

const WeedSchema: mongoose.Schema<Weed> = new Schema<Weed>({
  latitude: {
    type: Number,
    required: true,
  },
  longitude: {
    type: Number,
    required: true,
  },
  data: {
    type: String,
    required: true,
  },
});

const WeedModel: mongoose.Model<Weed> = mongoose.model<Weed>(
  "Weed",
  WeedSchema
);

export { WeedSchema, WeedModel };
