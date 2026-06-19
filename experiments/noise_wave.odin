package experiments

import "core:math/noise"

import rl "vendor:raylib"

noise_wave :: Screen {
	init   = noise_wave_init,
	deinit = noise_wave_deinit,
	update = noise_wave_update,
}

NOISE_SEED :: 0
FREQ :: 0.005 // smaller = smoother, longer wavelength
AMPLITUDE :: 150.0 // peak height in px above/below center
SPEED :: 0.001 // how fast the wave scrolls per frame

width, height: i32
t: f64 = 0

noise_wave_init :: proc() {
	width = rl.GetScreenWidth()
	height = rl.GetScreenHeight()
}

noise_wave_deinit :: proc() {}

noise_wave_update :: proc() -> Transition {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	t += SPEED

	rl.ClearBackground(rl.RAYWHITE)

	mid := f32(height) / 2

	// sample noise once per x column and connect the points
	prev: rl.Vector2
	for x in 0 ..< width {
		n := noise.noise_2d(NOISE_SEED, {f64(x) * FREQ + t, 0})
		y := mid + n * AMPLITUDE
		p := rl.Vector2{f32(x), y}

		if x > 0 do rl.DrawLineEx(prev, p, 4, rl.BLACK)
		prev = p
	}

	if rl.GuiLabelButton(rl.Rectangle{20, 20, 40, 40}, "back") do return .BACK

	return .NONE
}
