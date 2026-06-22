package basic_follow_mouse

import "core:math"
import exp "nature:experiments"
import rl "vendor:raylib"

Screen :: exp.Screen {
	init   = init,
	deinit = deinit,
	update = update,
}

GRAVITY :: 0.01
DRAG :: 0.1
STOP_THRESHOLD :: 0.01

Circle :: struct {
	vel, pos: [2]f32,
	rad:      f32,
	color:    rl.Color,
}

circle: Circle

init :: proc() {
	circle = Circle {
		{0, 0},
		{f32(rl.GetScreenWidth() / 2), f32(rl.GetScreenHeight() / 2)},
		20,
		rl.BLACK,
	}
}

deinit :: proc() {}

update :: proc() -> exp.Transition {
	acc: [2]f32 = 0
	dt := rl.GetFrameTime()
	// gravitate toward mouse
	acc += (rl.GetMousePosition() - circle.pos) * GRAVITY

	circle.vel += acc * dt
	// friction
	circle.vel *= math.pow(DRAG, dt)
	speed := rl.Vector2Length(circle.vel)
	if speed < STOP_THRESHOLD && rl.Vector2Length(acc) < STOP_THRESHOLD do circle.vel = 0

	circle.pos += circle.vel

	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(rl.RAYWHITE)
	rl.DrawCircle(i32(circle.pos.x), i32(circle.pos.y), circle.rad, circle.color)

	if rl.GuiLabelButton(rl.Rectangle{20, 20, 40, 40}, "back") do return .BACK

	return .NONE
}
