import p5 from "p5";
import { experiments } from "./experiments";
import type { Experiment } from "./types";

const canvasHost = document.getElementById("canvas-host") as HTMLElement;
const picker = document.getElementById(
  "experiment-picker",
) as HTMLSelectElement;
let active: p5 | null = null;

function run(exp: Experiment) {
  // tear down the previous sketch so its canvas / draw loop stops
  active?.remove();
  active = new p5(exp.sketch, canvasHost);
  if (location.hash !== `#${exp.id}`) location.hash = exp.id;
}

function experimentFromHash(): Experiment {
  const id = location.hash.slice(1);
  return experiments.find((e) => e.id === id) ?? experiments[0];
}

picker.addEventListener("change", () => {
  const exp = experiments.find((e) => e.id === picker.value);
  if (exp) run(exp);
});

window.addEventListener("hashchange", () => {
  const exp = experimentFromHash();
  picker.value = exp.id;
  run(exp);
});

// populate the picker
for (const exp of experiments) {
  const opt = document.createElement("option");
  opt.value = exp.id;
  opt.textContent = exp.name;
  picker.append(opt);
}

// initial load
const initial = experimentFromHash();
picker.value = initial.id;
run(initial);
