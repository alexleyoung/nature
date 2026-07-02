package balloon

import "core:math/noise"
import "core:math/rand"
import exp "nature:experiments"
import rl "vendor:raylib"

Screen :: exp.Screen {
	init   = init,
	deinit = deinit,
	update = update,
}

Circle :: struct {
	vel, pos: [2]f32,
	rad:      f32,
	color:    rl.Color,
}

circle: Circle
seed: i64

t: f64 = 0
HELIUM :: -.05
xt: f64
yt: f64

init :: proc() {
	circle = Circle {
		{0, 0},
		{f32(rl.GetScreenWidth() / 2), f32(rl.GetScreenHeight() / 2)},
		20,
		rl.BLACK,
	}

	seed = rand.int63()
	xt = rand.float64()
	yt = rand.float64()
}

deinit :: proc() {}

update :: proc() -> exp.Transition {
	acc: [2]f32 = 0

	heli: [2]f32 = {0, HELIUM}
	acc += heli
	wind: [2]f32 = {noise.noise_2d(seed, {t, xt}), noise.noise_2d(seed, {t, yt})} * .1
	acc += wind

	xt += 0.01
	yt += 0.013
	t += 0.01

	dt := rl.GetFrameTime()
	circle.vel += acc * dt
	circle.pos += circle.vel

	if circle.pos.y - circle.rad < 0 {
		circle.vel.y *= -.5
		circle.pos.y = circle.rad
	}

	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(rl.RAYWHITE)
	rl.DrawCircle(i32(circle.pos.x), i32(circle.pos.y), circle.rad, circle.color)

	if rl.GuiLabelButton(rl.Rectangle{20, 20, 40, 40}, "back") do return .BACK

	return .NONE
}
