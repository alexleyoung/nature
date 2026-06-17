import type { Experiment } from "../types";
import { basicNoiseTexture } from "./basic_noise_texture";
import { basicWalker } from "./basic_walker";

export const experiments: Experiment[] = [
  { id: "basicWalker", name: "Basic Walker", sketch: basicWalker },
  {
    id: "basicNoiseTexture",
    name: "Basic Noise Texture",
    sketch: basicNoiseTexture,
  },
];
