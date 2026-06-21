package flow_field

import rl "vendor:raylib"
import exp "nature:experiments"

SCALE := 8

Field :: struct {
	rows, cols: int,
	arr:        [][2]f32,
}

f: Field

field_at :: proc(f: ^Field, x, y: int) -> ^[2]f32 {
	return &f.arr[y * f.cols + x]
}

Screen :: exp.Screen {
	init   = init,
	deinit = deinit,
	update = update,
}

init :: proc() {
	f.rows = int(rl.GetScreenHeight()) / SCALE
	f.cols = int(rl.GetScreenWidth()) / SCALE
	f.arr = make([][2]f32, f.rows * f.cols)
}

deinit :: proc() {
	delete(f.arr)
	f = {}
}

update :: proc() -> exp.Transition {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.RAYWHITE)

	if rl.GuiLabelButton(rl.Rectangle{20, 20, 40, 40}, "back") do return .BACK

	return .NONE
}
