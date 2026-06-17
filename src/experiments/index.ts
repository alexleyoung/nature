import type { Experiment } from "../types";
import { walker } from "./walker";

export const experiments: Experiment[] = [
  { id: "walker", name: "Random Walker", sketch: walker },
];
