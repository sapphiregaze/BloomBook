import mongoose, { Schema } from "mongoose";

import { WeedSchema } from "./weed.model";

import { Cluster } from "../utils/types";

const ClusterSchema: mongoose.Schema<Cluster> = new Schema<Cluster>({
  cluster: [WeedSchema],
});

const ClusterModel: mongoose.Model<Cluster> = mongoose.model<Cluster>(
  "Cluster",
  ClusterSchema
);

export default ClusterModel;
