import type p5 from "p5";

export type Sketch = (p: p5) => void;

export interface Experiment {
  id: string;
  name: string;
  sketch: Sketch;
}
