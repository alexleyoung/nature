import type p5 from "p5";
import type { Sketch } from "../types";

const WIDTH = 640;
const HEIGHT = 640;

export const basicNoiseTexture: Sketch = (p: p5) => {
  p.setup = () => {
    p.createCanvas(WIDTH, HEIGHT);
    p.background(255);

    p.loadPixels();

    let xoff = 0;
    for (let x = 0; x < WIDTH; x++) {
      let yoff = 31415926;
      for (let y = 0; y < HEIGHT; y++) {
        const bright = p.map(p.noise(xoff, yoff), 0, 1, 0, 255);
        p.set(x, y, p.floor(bright));
        yoff += 0.01;
      }
      xoff += 0.01;
    }

    p.updatePixels();
  };

  p.draw = () => {};
};
