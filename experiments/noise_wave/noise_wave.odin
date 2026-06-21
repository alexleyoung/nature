package noise_wave

import "core:math/noise"
import "core:math/rand"

import exp "nature:experiments"
import rl "vendor:raylib"

FREQ :: 0.005
AMPLITUDE :: 150.0
SPEED :: 0.001

width, height: i32
noise_seed: i64
t: f64 = 0

Screen :: exp.Screen {
	init   = init,
	deinit = deinit,
	update = update,
}

init :: proc() {
	width = rl.GetScreenWidth()
	height = rl.GetScreenHeight()
	noise_seed = rand.int63()
}

deinit :: proc() {}

update :: proc() -> exp.Transition {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	t += SPEED

	rl.ClearBackground(rl.RAYWHITE)

	mid := f32(height) / 2

	prev: rl.Vector2
	for x in 0 ..< width {
		n := noise.noise_2d(noise_seed, {f64(x) * FREQ + t, 0})
		y := mid + n * AMPLITUDE
		p := rl.Vector2{f32(x), y}

		if x > 0 do rl.DrawLineEx(prev, p, 4, rl.BLACK)
		prev = p
	}

	if rl.GuiLabelButton(rl.Rectangle{20, 20, 40, 40}, "back") do return .BACK

	return .NONE
}
