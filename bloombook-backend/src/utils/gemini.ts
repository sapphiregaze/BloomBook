import fs from "fs";
import {
  GenerateContentResult,
  GenerativeModel,
  GoogleGenerativeAI,
} from "@google/generative-ai";

require("dotenv").config();
const genAI: GoogleGenerativeAI = new GoogleGenerativeAI(
  process.env.GEMINI_API_KEY as string
);

function fileToBase64(file_path: string, mimeType: string) {
  return {
    inlineData: {
      data: Buffer.from(fs.readFileSync(file_path)).toString("base64"),
      mimeType,
    },
  };
}

async function run(file_path: string, mimeType: string) {
  const model: GenerativeModel = genAI.getGenerativeModel({
    model: "gemini-pro-vision",
  });

  const prompt: string =
    "What type of plant is in this image? Give me some information regarding the plant such as origin of name and what biome is it usually found in.";

  const image = fileToBase64(file_path, mimeType);
  const result: GenerateContentResult = await model.generateContent([
    prompt,
    image,
  ]);

  return result.response.text().trim();
}

export default run;
