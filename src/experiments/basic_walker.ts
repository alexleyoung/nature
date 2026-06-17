import type p5 from "p5";
import type { Sketch } from "../types";

const WIDTH = 640;
const HEIGHT = 640;

// pixels per grid cell
const SCALE = 4;

class Walker {
  x: number;
  y: number;

  constructor(p: p5) {
    // position in grid cells, not pixels
    this.x = p.floor(WIDTH / SCALE / 2);
    this.y = p.floor(HEIGHT / SCALE / 2);
  }

  show(p: p5) {
    p.stroke(0);
    p.strokeWeight(SCALE);
    p.square(this.x * SCALE, this.y * SCALE, SCALE);
  }

  step(p: p5) {
    const dir = p.floor(p.random(4));

    switch (dir) {
      case 0:
        this.y--;
        break;
      case 1:
        this.x++;
        break;
      case 2:
        this.y++;
        break;
      case 3:
        this.x--;
        break;
    }
  }
}

export const basicWalker: Sketch = (p) => {
  let walker: Walker;

  p.setup = () => {
    p.createCanvas(WIDTH, HEIGHT);
    walker = new Walker(p);
    p.background(255);
  };

  p.draw = () => {
    walker.step(p);
    walker.show(p);
  };
};
